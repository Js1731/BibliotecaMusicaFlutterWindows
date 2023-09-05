import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/dialogos/dialogo_gestionar_columnas_cancion.dart';
import 'package:biblioteca_musica/repositorios/repositorio_canciones.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../backend/datos/AppDb.dart';
import '../../bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import '../../bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import '../../dialogos/dialogo_ingresar_texto.dart';
import '../../repositorios/repositorio_reproductor.dart';

class AuxiliarListaReproduccion {
  final RepositorioReproductor _repositorioReproductor;
  final RepositorioCanciones _repositorioCanciones;
  final RepositorioColumnas _repositorioColumnas;

  AuxiliarListaReproduccion(this._repositorioReproductor,
      this._repositorioCanciones, this._repositorioColumnas);

  Future<void> importarCanciones(BuildContext context) async {
    FilePickerResult? lstArchivosSeleccionados =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (lstArchivosSeleccionados == null) return;

    if (context.mounted) {
      context
          .read<BlocListaReproduccionSeleccionada>()
          .add(EvImportarCanciones(lstArchivosSeleccionados));
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
  }

  Future<void> actColumnasListaRep(BuildContext context,
      List<ColumnaData> columnas, int? idColumnaPrincipal) async {
    if (context.mounted) {
      final bloc = context.read<BlocListaReproduccionSeleccionada>();
      bloc.add(EvActColumnasLista(columnas.map((e) => e.id).toList()));

      bloc.add(EvActColumnaPrincipal(idColumnaPrincipal));
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
    await _repositorioReproductor.reproducirCancion(
        cancion,
        context
            .read<BlocListaReproduccionSeleccionada>()
            .state
            .listaReproduccionSeleccionada,
        context.read<BlocListaReproduccionSeleccionada>().state.listaCanciones,
        _repositorioCanciones.obtStreamCanciones()!);
  }

  Future<void> reproducirListaEnOrden(BuildContext context) async {
    await _repositorioReproductor.reproducirListaOrden(
        context
            .read<BlocListaReproduccionSeleccionada>()
            .state
            .listaReproduccionSeleccionada,
        context.read<BlocListaReproduccionSeleccionada>().state.listaCanciones,
        _repositorioCanciones.obtStreamCanciones()!);
  }

  Future<void> reproducirListaAzar(BuildContext context) async {
    await _repositorioReproductor.reproducirListaAzar(
        context
            .read<BlocListaReproduccionSeleccionada>()
            .state
            .listaReproduccionSeleccionada,
        context.read<BlocListaReproduccionSeleccionada>().state.listaCanciones,
        _repositorioCanciones.obtStreamCanciones()!);
  }

  Future<void> eliminarLista(BuildContext context) async {
    bool? confirmar = await abrirDialogoConfirmar(
        context,
        "Eliminar ${context.read<BlocListaReproduccionSeleccionada>().state.listaReproduccionSeleccionada.nombre}",
        "¿Estas seguro?");

    if (confirmar == null) return;

    if (context.mounted) {
      context
          .read<BlocListaReproduccionSeleccionada>()
          .add(EvSeleccionarLista(listaRepBiblioteca));
    }
  }

  Future<ColumnaData?> agregarColumna(BuildContext context) async {
    String? nuevoNombre = await abrirDialogoIngresarTexto(
        context, "Nueva Columna", "Ingresa el nombre de la nueva columna");

    if (nuevoNombre == null) return null;

    ///ESTA ES UNA EXCEPCION
    ///SE USA UN REPOSITORIO DIRECTAMENTE POR QUE LOS ADD EVENT DE LOS BLOC NO
    ///DEVUELVEN UN VALOR
    return _repositorioColumnas.agregarColumna(nuevoNombre);
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
    }
  }

  void eliminarCancionesLista(BuildContext context, List<int> list) {
    context
        .read<BlocListaReproduccionSeleccionada>()
        .add(EvEliminarCancionesLista(list));
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
    }
  }
}
