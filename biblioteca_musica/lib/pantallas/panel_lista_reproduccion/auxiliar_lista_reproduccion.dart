import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/bloc/sincronizador/cubit_sincronizacion.dart';
import 'package:biblioteca_musica/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/dialogos/dialogo_gestionar_columnas_cancion.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import '../../bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import '../../datos/AppDb.dart';
import '../../dialogos/dialogo_ingresar_texto.dart';

class AuxiliarListaReproduccion {
  final RepositorioColumnas _repositorioColumnas;

  AuxiliarListaReproduccion(this._repositorioColumnas);

  Future<void> importarCanciones(BuildContext context) async {
    FilePickerResult? lstArchivosSeleccionados = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.audio);

    if (lstArchivosSeleccionados == null) return;

    if (context.mounted) {
      context
          .read<BlocListaReproduccionSeleccionada>()
          .add(EvImportarCanciones(lstArchivosSeleccionados));

      context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
    }
  }

  Future<void> asignarValoresColumnaACanciones(BuildContext context) async {
    await abrirDialogoGestionarColumnasCancion(
        context,
        context
            .read<BlocListaReproduccionSeleccionada>()
            .state
            .obtCancionesSelecionadasCompleta());
  }

  Future<void> recortarNombres(
      BuildContext context, List<int> canciones) async {
    context.read<BlocListaReproduccionSeleccionada>().add(
        EvRecortarNombresCancionesSeleccionadas(
            await abrirDialogoIngresarTexto(context, "Recortar Canciones",
                    "Ingresa un texto que eliminar de los nombres de las canciones.",
                    altura: 180) ??
                "",
            canciones));
    if (context.mounted) {
      context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
    }
  }

  Future<void> actColumnasListaRep(BuildContext context,
      List<ColumnaData> columnas, int? idColumnaPrincipal) async {
    if (context.mounted) {
      final bloc = context.read<BlocListaReproduccionSeleccionada>();
      bloc.add(EvActColumnasLista(columnas.map((e) => e.id).toList()));

      bloc.add(EvActColumnaPrincipal(idColumnaPrincipal));

      context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
    }
  }

  Future<void> renombrarCancion(
      BuildContext context, CancionColumnas cancion) async {
    String? nuevoNombre = await abrirDialogoIngresarTexto(
        context, "Nuevo Nombre", "Ingresa el nuevo nombre de la cancion.",
        hint: "Ej. Nuevo Nombre", txtIni: cancion.nombre);

    if (nuevoNombre == null) return;

    if (context.mounted) {
      context
          .read<BlocListaReproduccionSeleccionada>()
          .add(EvRenombrarCancion(cancion.id, nuevoNombre));

      context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
    }
  }

  Future<void> asignarValoresColumnasDetallado(
      BuildContext context, CancionColumnas cancion) async {
    if (context
            .read<BlocListaReproduccionSeleccionada>()
            .state
            .obtCantidadCancionesSeleccionadas() ==
        0) {
      await abrirDialogoGestionarColumnasCancion(context, [cancion]);
    } else {
      await abrirDialogoGestionarColumnasCancion(
          context,
          context
              .read<BlocListaReproduccionSeleccionada>()
              .state
              .obtCancionesSelecionadasCompleta());
    }
  }

  Future<void> reproducirCancion(
      BuildContext context, CancionData cancion) async {
    final estadoListaSel =
        context.read<BlocListaReproduccionSeleccionada>().state;
    context.read<BlocReproductor>().add(EvReproducirCancion(
        estadoListaSel.listaReproduccionSeleccionada,
        cancion,
        estadoListaSel.listaCanciones));
  }

  Future<void> reproducirListaEnOrden(BuildContext context) async {
    final estadoListaSel =
        context.read<BlocListaReproduccionSeleccionada>().state;
    context.read<BlocReproductor>().add(EvReproducirListaOrden(
        estadoListaSel.listaReproduccionSeleccionada,
        estadoListaSel.listaCanciones));
  }

  Future<void> reproducirListaAzar(BuildContext context) async {
    final estadoListaSel =
        context.read<BlocListaReproduccionSeleccionada>().state;
    context.read<BlocReproductor>().add(EvReproducirListaAzar(
        estadoListaSel.listaReproduccionSeleccionada,
        estadoListaSel.listaCanciones));
  }

  Future<void> eliminarLista(BuildContext context) async {
    bool? confirmar = await abrirDialogoConfirmar(
        context,
        "Eliminar ${context.read<BlocListaReproduccionSeleccionada>().state.listaReproduccionSeleccionada.nombre}",
        "¿Estas seguro?");

    if (confirmar == null) return;

    if (context.mounted) {
      context.read<BlocListaReproduccionSeleccionada>().add(EvEliminarLista());
      context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
    }
  }

  Future<ColumnaData?> agregarColumna(BuildContext context) async {
    String? nuevoNombre = await abrirDialogoIngresarTexto(
        context, "Nueva Columna", "Ingresa el nombre de la nueva columna");

    if (nuevoNombre == null) return null;

    ///ESTA ES UNA EXCEPCION
    ///SE USA UN REPOSITORIO DIRECTAMENTE POR QUE LOS ADD EVENT DE LOS BLOC NO
    ///DEVUELVEN UN VALOR
    ///SE NECESITA LA COLUMNA QUE SE AGREGA PARA ASIGNARLA AL GESTOR DE COLUMNAS
    final nuevaColumna = _repositorioColumnas.agregarColumna(nuevoNombre);

    if (context.mounted) {
      context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
    }

    return nuevaColumna;
  }

  Future<void> eliminarCancionesTotalmente(
      BuildContext context, List<int> canciones) async {
    final confirmar = await abrirDialogoConfirmar(
        context,
        "Eliminar Totalmente",
        "Quieres eliminar ${canciones.length} canciones del sistema. Seran eliminadas de todas las listas de reproduccion.");

    if (confirmar == null) return;

    if (context.mounted) {
      context
          .read<BlocListaReproduccionSeleccionada>()
          .add(EvEliminarCancionesTotalmente(canciones));

      context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
    }
  }

  void eliminarCancionesLista(BuildContext context, List<int> list) {
    context
        .read<BlocListaReproduccionSeleccionada>()
        .add(EvEliminarCancionesLista(list));

    context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
  }

  Future<void> renombrarLista(BuildContext context) async {
    final lista = context
        .read<BlocListaReproduccionSeleccionada>()
        .state
        .listaReproduccionSeleccionada;
    final nuevoNombre = await abrirDialogoIngresarTexto(
        context, "Renombrar Lista", "Ingrese el nuevo nombre de la lista.",
        txtIni: lista.nombre);

    if (nuevoNombre == null) return;

    if (context.mounted) {
      context
          .read<BlocListaReproduccionSeleccionada>()
          .add(EvRenombrarLista(nuevoNombre));

      context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
    }
  }

  void ordenarListaPorColumna(BuildContext context, int idColumna) {
    context
        .read<BlocListaReproduccionSeleccionada>()
        .add(EvOrdenarListaPorColumna(idColumna));
  }
}
