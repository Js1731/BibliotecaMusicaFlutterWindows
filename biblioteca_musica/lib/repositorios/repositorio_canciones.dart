import 'dart:io';

import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/backend/misc/Proceso.dart';
import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/bloc/bloc_reproductor.dart';
import 'package:biblioteca_musica/data/dbp_canciones.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:mp3_info/mp3_info.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

class RepositorioCanciones {
  final DBPCanciones _dbpCanciones;

  ///Importa archivos MP3 al sistema, crea canciones que las representan, sin asociaciones a ninguna lista.
  Future<List<int>?> procesoImportarCancionesGlobal(
      Procedimiento proc, dynamic data) async {
    FilePickerResult? lstArchivos = data.item1;
    int idListaRep = data.item2;
    if (lstArchivos != null) {
      List<String?> lstRutas = lstArchivos.paths;
      List<File> lstUrlArchivos =
          lstRutas.map<File>((path) => File(path!)).toList();

      List<CancionData> lstCanciones = lstUrlArchivos
          .map((archivo) => CancionData(
              id: UniqueKey().hashCode,
              nombre: basenameWithoutExtension(archivo.path),
              duracion: MP3Processor.fromFile(archivo).duration.inSeconds,
              estado: estadoLocal))
          .toList();

      await _dbpCanciones.insertarCanciones(lstCanciones);
      if (idListaRep != listaRepBiblioteca.id) {
        await _dbpCanciones.asignarCancionesListaReproduccion(
            lstCanciones.map((can) => can.id).toList(), idListaRep);
      }

      //COPIAR ARCHIVOS A LA CARPETA DE TRABAJO
      int cant = 0;
      for (int i = 0; i < lstCanciones.length; i++) {
        String ruta = lstRutas[i]!;
        int id = lstCanciones[i].id;

        await copiarArchivo(ruta, "$id.mp3");
        cant++;
        proc.actProgreso(cant / lstCanciones.length);
        proc.actLog("$cant/${lstCanciones.length}");
      }
    }

    return null;
  }

  RepositorioCanciones(this._dbpCanciones);

  Stream<List<CancionColumnas>> crearStreamCancionesLista(
      int idListaRep, List<ColumnaData> columnasLista) {
    return _dbpCanciones.crearStreamListaCancion(idListaRep, columnasLista);
  }

  Stream<List<CancionColumnas>> crearStreamCancionesBiblioteca() {
    return _dbpCanciones.crearStramCancionesBiblioteca();
  }

  void importarCancionesLista(
      FilePickerResult lstCanciones, int idLista) async {
    Procedimiento procImportarCancionesListaTodo = Procedimiento(
        procesoImportarCancionesGlobal, Tuple2(lstCanciones, idLista));
    procImportarCancionesListaTodo.iniciar();

    // await abrirDialogoProgreso(
    //     "Importando Canciones...", procImportarCancionesListaTodo);
  }

  void asignarCancionesListaRep(List<int> lstIdCanciones, int idListaRep) {
    _dbpCanciones.asignarCancionesListaReproduccion(lstIdCanciones, idListaRep);
  }
}
