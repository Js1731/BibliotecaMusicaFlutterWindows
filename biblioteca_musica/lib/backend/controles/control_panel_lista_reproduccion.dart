import 'dart:io';

import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/Proceso.dart';
import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/pantallas/pant_principal.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_asignar_valores_columnas.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_columnas.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_progreso.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_texto.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mp3_info/mp3_info.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

///Importa archivos MP3 al sistema, crea canciones que las representan, sin asociaciones a ninguna lista.
Future<List<int>?> procesoImportarCancionesGlobal(
    Procedimiento proc, dynamic lstArchivos) async {
  if (lstArchivos != null) {
    List<String?> lstRutas = lstArchivos.paths;
    List<File> lstUrlArchivos =
        lstRutas.map<File>((path) => File(path!)).toList();
    Map<int, String> mapaIdRuta = {};

    //INSERTAR TODAS LAS CANCIONES EN LA BASE DE DATOS
    await appDb.batch((batch) =>
        batch.insertAll(appDb.cancion, lstUrlArchivos.map((archivoCancion) {
          //GENERAR ID UNICO
          int id = UniqueKey().hashCode;

          //REGISTRAR RUTA Y ID
          mapaIdRuta[id] = archivoCancion.path;

          //INSERTAR CANCION EN LA BASE DE DATOS
          return CancionCompanion.insert(
              id: Value(id),
              nombre: basenameWithoutExtension(archivoCancion.path),
              duracion:
                  MP3Processor.fromFile(archivoCancion).duration.inSeconds,
              estado: estadoLocal);
        })));

    //COPIAR ARCHIVOS A LA CARPETA DE TRABAJO
    int cant = 0;
    for (var id in mapaIdRuta.keys) {
      await copiarArchivo(mapaIdRuta[id]!, "$id.mp3");
      cant++;
      proc.actProgreso(cant / mapaIdRuta.length);
      proc.actLog("$cant/${mapaIdRuta.length}");
    }
    return mapaIdRuta.keys.toList();
  }

  return null;
}

class ContPanelListaReproduccion {
  Future<void> importarCancionesEnListaTodo() async {
    FilePickerResult? lstArchivosSeleccionados =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (lstArchivosSeleccionados == null) return;

    Procedimiento procImportarCancionesListaTodo =
        Procedimiento(procesoImportarCancionesGlobal, lstArchivosSeleccionados);
    procImportarCancionesListaTodo.encolarProceso((proc, lstIds) async {
      if (lstIds == null) return;

      await provReproductor.actualizarListaCanciones();
      await provReproductor.actualizarListaCanciones();
      await provGeneral.actualizarListaCanciones();
      await provGeneral.actualizarValoresColumnaCancion();
      provListaRep.actualizarMapaCancionesSel();

      await actualizarDatosLocales();
    });

    await abrirDialogoProgreso(
        "Importando Canciones...", procImportarCancionesListaTodo);
  }

  ///Importa archivos MP3 al sistema,crea canciones que las representan y los asocia a la lista indicada.
  Future<void> importarCancionesEnLista(int idLista) async {
    FilePickerResult? lstArchivosSeleccionados =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (lstArchivosSeleccionados == null) return;

    Procedimiento procImportarCancionesListaCualquiera =
        Procedimiento(procesoImportarCancionesGlobal, lstArchivosSeleccionados);
    procImportarCancionesListaCualquiera.encolarProceso((proc, lstIds) async {
      if (lstIds == null) return;

      await asignarCancionesLista(lstIds, idLista);

      await provReproductor.actualizarListaCanciones();
      await provGeneral.actualizarListaCanciones();
      await provGeneral.actualizarValoresColumnaCancion();
      provListaRep.actualizarMapaCancionesSel();

      await actualizarDatosLocales();
    });

    await abrirDialogoProgreso(
        "Importando Canciones...", procImportarCancionesListaCualquiera);
    //await importarCancionesGlobal();
  }

  ///Abre un dialogo para ingresar un texto. A Todos los nombres de las canciones se les recortara el texto ingresado.
  Future<void> recortarNombresCanciones() async {
    String? txtFiltro = await mostrarDialogoTexto(
        keyPantPrincipal.currentContext!, "Texto a eliminar");

    if (txtFiltro == null) return;

    provGeneral.recortarNombreCancionesTodo(txtFiltro);

    await provReproductor.actualizarListaCanciones();
  }

  ///Asocia las canciones indicadas a una Lista. Sin generar asociaciones duplicadas.
  Future<void> asignarCancionesLista(
      List<int> lstIdcanciones, int idListaRep) async {
    final Set<int> setIdsCancionesListaDestino =
        (await (appDb.select(appDb.cancionListaReproduccion)
                  ..where((tbl) => tbl.idListaRep.equals(idListaRep)))
                .get())
            .map((e) => e.idCancion)
            .toSet();

    final Set<int> lstIdsCancionesNoDuplicados =
        lstIdcanciones.toSet().difference(setIdsCancionesListaDestino);

    appDb.batch((batch) => batch.insertAll(
        appDb.cancionListaReproduccion,
        lstIdsCancionesNoDuplicados.map((idCan) =>
            CancionListaReproduccionCompanion.insert(
                idCancion: idCan, idListaRep: idListaRep))));
  }

  Future<void> eliminarCancionesDeLista(
      List<int> lstCanciones, int idLista) async {
    await appDb.batch((batch) => batch.deleteWhere(
        appDb.cancionListaReproduccion,
        (tbl) =>
            tbl.idCancion.isIn(lstCanciones) & tbl.idListaRep.equals(idLista)));

    await provGeneral.actualizarListaCanciones();
    provListaRep.actualizarMapaCancionesSel();
    if (idLista == provReproductor.idListaRep) {
      await provReproductor.actualizarListaCanciones();
    }
  }

  Future<void> eliminarCancionesTotalmente(List<int> lstCanciones) async {
    int cantCanciones = lstCanciones.length;
    bool? aceptar = await mostrarDialogoConfirmar(
        keyPantPrincipal.currentContext!,
        "Eliminar Permanentemente?",
        "Quieres eliminar $cantCanciones cancion${cantCanciones > 0 ? "es" : ""} totalmente del sistema? (De todas las listas y registro de canciones)");

    if (aceptar == null) return;

    await appDb.batch((batch) => batch.deleteWhere(
        appDb.cancionListaReproduccion,
        (tbl) => tbl.idCancion.isIn(lstCanciones)));

    await appDb.batch((batch) =>
        batch.deleteWhere(appDb.cancion, (tbl) => tbl.id.isIn(lstCanciones)));

    for (var idCancion in lstCanciones) {
      await eliminarArchivo("$idCancion.mp3");
    }

    await provGeneral.actualizarListaCanciones();
    await provReproductor.actualizarListaCanciones();

    await actualizarDatosLocales();
  }

  ///Abre un Dialogo para ingresar un texto. El nuevo nombre de la lista sera el texto ingresado.
  Future<void> renombrarLista(int idLista) async {
    String? nuevoNombre = await mostrarDialogoTexto(
        keyPantPrincipal.currentContext!, "Nuevo nombre de la lista");

    if (nuevoNombre == null) return;

    await (appDb.update(appDb.listaReproduccion)
          ..where((fila) => fila.id.equals(idLista)))
        .write(ListaReproduccionCompanion(nombre: Value(nuevoNombre)));

    await provGeneral.actualizarListaListasRep();
    provGeneral.seleccionarLista(idLista);
    provListaRep.actualizarMapaCancionesSel();
    await actualizarDatosLocales();
  }

  Future<void> eliminarListaReproduccion(int idLista) async {
    bool? confEliminar = await mostrarDialogoConfirmar(
        keyPantPrincipal.currentContext!, "Quieres eliminar esta lista? ", "");

    if (confEliminar == null || confEliminar == false) return;

    //ELIMINAR RELACIONES ENTRE CANCIONES Y LA LISTA
    await (appDb.delete(appDb.cancionListaReproduccion)
          ..where((tbl) => tbl.idListaRep.equals(idLista)))
        .go();

    //ELIMINAR LA LISTA
    await (appDb.delete(appDb.listaReproduccion)
          ..where((tbl) => tbl.id.equals(idLista)))
        .go();

    await provGeneral.actualizarListaListasRep();
    await actualizarDatosLocales();
  }

  ///Abre un dialogo para editar que columnas mostrara esta lista de reproduccion.
  ///Tambien permite seleccionar la columna principal de la lista de reproduccion.
  Future<void> editarColumnasListaRep(ListaReproduccionData lst) async {
    final columnasSeleccionas = await abrirDialogoColumnas(
        Provider.of<ProviderGeneral>(keyPantPrincipal.currentContext!,
                listen: false)
            .listaSel);

    if (columnasSeleccionas == null) return;

    final List<ColumnaData> columnasNuevas = columnasSeleccionas["columnas"];
    final ColumnaData? colPrincipal = columnasSeleccionas["colPrincipal"];

    await (appDb.delete(appDb.listaColumnas)
          ..where((tbl) => tbl.idListaRep.equals(lst.id)))
        .go();

    await appDb.batch((batch) => batch.insertAll(
        appDb.listaColumnas,
        columnasNuevas
            .map((columna) => ListaColumnasCompanion.insert(
                idListaRep: lst.id,
                idColumna: columna.id,
                posicion: columnasNuevas.indexOf(columna)))
            .toList()));

    (appDb.update(appDb.listaReproduccion)
          ..where((tbl) => tbl.id.equals(lst.id)))
        .write(ListaReproduccionCompanion(
            idColumnaPrincipal: Value(colPrincipal?.id)));

    provGeneral.seleccionarLista(lst.id);
    provListaRep.actualizarMapaCancionesSel();
    await provReproductor.actualizarDatos(provReproductor.cancionRep?.id);
    await actualizarDatosLocales();
  }

  Future<void> asignarValorColumnaACancionesSimple(
      List<int> idCancionesSel, ColumnaData columna) async {
    ValorColumnaData? valorColumna =
        await abrirDialogoSeleccionarValorColumna(columna, null);

    if (valorColumna == null) return;

    final consultaCanValColEliminar = (appDb
        .selectOnly(appDb.cancionValorColumna)
        .join([
      leftOuterJoin(
          appDb.valorColumna,
          appDb.valorColumna.id
              .equalsExp(appDb.cancionValorColumna.idValorPropiedad)),
      leftOuterJoin(appDb.columna,
          appDb.columna.id.equalsExp(appDb.valorColumna.idColumna))
    ])
      ..where(appDb.columna.id.equals(columna.id) &
          appDb.cancionValorColumna.idCancion.isIn(idCancionesSel)))
      ..addColumns([appDb.cancionValorColumna.id]);

    final resultados = await consultaCanValColEliminar.get();
    List<int> lstIdsCanValColEliminar = resultados
        .map<int>((e) => e.rawData.data["cancion_valor_columna.id"])
        .toList();

    await (appDb.delete(appDb.cancionValorColumna)
          ..where((tbl) => tbl.id.isIn(lstIdsCanValColEliminar)))
        .go();

    List<Insertable> inserts = [];

    for (var idCan in idCancionesSel) {
      inserts.add(CancionValorColumnaCompanion.insert(
          idCancion: idCan, idValorPropiedad: valorColumna.id));
    }

    await appDb
        .batch((batch) => batch.insertAll(appDb.cancionValorColumna, inserts));
    await provGeneral.actualizarValoresColumnaCancion();
    await actualizarDatosLocales();
  }

  ///Abre un dialogo para seleccionar Valores Columna de las columnas indicadas, para luego asignarlos a las canciones seleccionadas.
  Future<void> asignarValorColumnaACancionesDetallado(
      List<int> idCancionesSel, List<ColumnaData> lstColumnas) async {
    final Map<ColumnaData, ValorColumnaData?>? mapavaloresColumnaSeleccionados =
        await abrirDialogoAsignarPropiedad(lstColumnas);

    if (mapavaloresColumnaSeleccionados == null) return;

    //OBTENER UNA LISTA CON LOS IDS DE LAS COLUMNAS A LAS QUE SE LES SELECCIONO UN NUEVO VALOR COLUMNA.
    List<int> lstIdColumnasModificar = mapavaloresColumnaSeleccionados.keys
        .where((element) => mapavaloresColumnaSeleccionados[element] != null)
        .map((e) => e.id)
        .toList();

    //
    final consultaCanValColEliminar = (appDb
        .selectOnly(appDb.cancionValorColumna)
        .join([
      leftOuterJoin(
          appDb.valorColumna,
          appDb.valorColumna.id
              .equalsExp(appDb.cancionValorColumna.idValorPropiedad)),
      leftOuterJoin(appDb.columna,
          appDb.columna.id.equalsExp(appDb.valorColumna.idColumna))
    ])
      ..where(appDb.columna.id.isIn(lstIdColumnasModificar) &
          appDb.cancionValorColumna.idCancion.isIn(idCancionesSel)))
      ..addColumns([appDb.cancionValorColumna.id]);

    final resultados = await consultaCanValColEliminar.get();
    List<int> lstIdsCanValColEliminar = resultados
        .map<int>((e) => e.rawData.data["cancion_valor_columna.id"])
        .toList();

    await (appDb.delete(appDb.cancionValorColumna)
          ..where((tbl) => tbl.id.isIn(lstIdsCanValColEliminar)))
        .go();

    List<Insertable> inserts = [];

    final valoresColumna = mapavaloresColumnaSeleccionados.values;
    for (var idCan in idCancionesSel) {
      for (var valor in valoresColumna) {
        if (valor == null) continue;

        inserts.add(CancionValorColumnaCompanion.insert(
            idCancion: idCan, idValorPropiedad: valor.id));
      }
    }

    await appDb
        .batch((batch) => batch.insertAll(appDb.cancionValorColumna, inserts));
    await provGeneral.actualizarValoresColumnaCancion();
    await actualizarDatosLocales();
  }

  Future<void> renombrarCancion(CancionData cancion) async {
    final String? nuevoNombre = await mostrarDialogoTexto(
        keyPantPrincipal.currentContext!, "Nuevo nombre de la canción",
        txtIni: cancion.nombre);

    if (nuevoNombre == null || nuevoNombre == "") return;

    bool repetido = await (appDb.select(appDb.cancion)
              ..where((tbl) => tbl.nombre.equals(nuevoNombre)))
            .getSingleOrNull() !=
        null;

    if (repetido) {
      mostrarDialogoConfirmar(keyPantPrincipal.currentContext!,
          "Nombre Repetido", "'$nuevoNombre' ya existe.");
      return;
    }

    await ((appDb.update(appDb.cancion)
          ..where((tbl) => tbl.id.equals(cancion.id))))
        .write(CancionCompanion(nombre: Value(nuevoNombre)));

    await actualizarDatosLocales();
  }

  Future<void> asignarColumnaOrden(int idLista, int idColumna) async {
    await appDb
        .update(appDb.listaReproduccion)
        .write(ListaReproduccionCompanion(idColumnaOrden: Value(idColumna)));

    await provGeneral.actualizarListaCanciones();
    await actualizarDatosLocales();
  }
}
