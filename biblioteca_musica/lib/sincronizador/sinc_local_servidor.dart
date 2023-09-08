import 'dart:convert';
import 'dart:io';

import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:dio/dio.dart';

import '../datos/AppDb.dart';
import '../misc/archivos.dart';
import '../misc/utiles.dart';
import 'sincronizacion.dart';
import 'utils_sinc.dart';

class SincronizadorLocalConServidor {
  final BlocLog blocLog;

  SincronizadorLocalConServidor(this.blocLog);

  Future<void> sincronizar() async {
    await reemplazarDatosLocalConServidor();
    await sincronizarEstadoLocalConServidor();
    await actNumeroVersionLocal(await obtNumeroVersionServidor());
  }

  Future<void> copiarTablaServidorALocal(String tabla) async {
    var resultadoRaw = await Dio()
        .get(await crearURLServidor("conTablaTodo", {"tabla": tabla}));

    var resultado = jsonDecode(resultadoRaw.data);

    var query = "INSERT INTO $tabla ";

    var columnas = "(";
    var values = "";

    if (resultado.isEmpty) {
      return;
    }

    ///OBTENER COLUMNAS DE LA TABLA
    var llaves = resultado[0].keys.toList();
    for (var e = 0; e < llaves.length; e++) {
      columnas += llaves[e];

      if (e < (llaves.length - 1)) {
        columnas += ",";
      }
    }

    columnas += ")";

    ///GENERAR VALORES PARA INSERTAR
    for (var i = 0; i < resultado.length; i++) {
      var fila = resultado[i];

      values += "(";

      for (var e = 0; e < llaves.length; e++) {
        var dato = fila[llaves[e]];

        if (dato is String) {
          values += "'${fila[llaves[e]]}'";
        } else {
          values += "${fila[llaves[e]]}";
        }

        if (e < llaves.length - 1) {
          values += ",";
        }
      }
      values += ")";

      if (i < resultado.length - 1) {
        values += ",";
      }
    }

    query = "INSERT INTO $tabla $columnas VALUES $values;";

    await appDb.customInsert(query);
  }

  Future<void> borrarTablaLocal(String nombreTabla) async {
    await appDb.customStatement("DELETE FROM $nombreTabla");
  }

  Future<void> reemplazarDatosLocalConServidor() async {
    for (String nombreTabla in [
      "cancion_lista_reproduccion",
      "lista_columnas",
      "lista_reproduccion",
      "cancion_valor_columna",
      "valor_columna",
      "columna",
      "cancion",
    ]) {
      await borrarTablaLocal(nombreTabla);
    }

    for (String nombreTabla in [
      "cancion",
      "columna",
      "valor_columna",
      "cancion_valor_columna",
      "lista_reproduccion",
      "lista_columnas",
      "cancion_lista_reproduccion",
    ]) {
      await copiarTablaServidorALocal(nombreTabla);
    }
  }

  Future<void> sincronizarEstadoLocalConServidor() async {
    var (lstMP3Local, lstJPGLocal) = await obtArchivosLocal();

    //Borrar archivos del servidor

    //Obtener Canciones
    var lstCanciones = await appDb.select(appDb.cancion).get();
    List<int> lstIdCanciones = lstCanciones.map<int>((e) => e.id).toList();

    var lstMP3Eliminar = lstMP3Local
        .toSet()
        .difference(lstIdCanciones.toSet())
        .map((e) => "$e.mp3")
        .toList();

    //Obtener Valores Columna
    var lstValoresColumna = await appDb.select(appDb.valorColumna).get();
    List<int> lstIdValorColumna =
        lstValoresColumna.map<int>((e) => e.id).toList();
    var lstJPGEliminar = lstJPGLocal
        .toSet()
        .difference(lstIdValorColumna.toSet())
        .map((e) => "$e.jpg")
        .toList();

    for (var archivo in [...lstMP3Eliminar, ...lstJPGEliminar]) {
      var file = File(rutaDoc(archivo));
      await file.delete();
    }

    var lstArchivosMP3Descargar =
        lstIdCanciones.toSet().difference(lstMP3Local.toSet()).toList();

    await cambiarEstadoCancion(lstArchivosMP3Descargar, estadoServidor);

    var lstArchivosJPGDescargar =
        lstIdValorColumna.toSet().difference(lstJPGLocal.toSet()).toList();

    await cambiarEstadoImagen(lstArchivosJPGDescargar, estadoServidor);
  }
}
