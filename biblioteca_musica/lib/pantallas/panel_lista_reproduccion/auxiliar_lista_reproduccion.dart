import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/repositorios/repositorio_canciones.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_asignar_valores_columnas.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_columnas.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_texto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../backend/datos/AppDb.dart';
import '../../bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import '../../bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import '../../repositorios/repositorio_reproductor.dart';
import '../../widgets/dialogos/dialogo_seleccionar_valor_columna.dart';

class AuxiliarListaReproduccion {
  final RepositorioReproductor _repositorioReproductor;
  final RepositorioCanciones _repositorioCanciones;

  AuxiliarListaReproduccion(
      this._repositorioReproductor, this._repositorioCanciones);

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

  Future<void> asignarValoresColumnaACanciones(
      BuildContext context, ColumnaData col) async {
    ValorColumnaData? valorColumnaSel =
        await abrirDialogoSeleccionarValorColumna(col, null);

    if (valorColumnaSel == null) return;
    if (context.mounted) {
      context.read<BlocListaReproduccionSeleccionada>().add(
          EvActValorColumnaCanciones(
              valorColumnaSel.id, valorColumnaSel.idColumna));
    }
  }

  Future<void> recortarNombres(BuildContext context) async {
    context.read<BlocListaReproduccionSeleccionada>().add(
        EvRecortarNombresCancionesSeleccionadas(
            await mostrarDialogoTexto(context, "Filtro") ?? ""));
  }

  Future<void> actColumnasListaRep(BuildContext context) async {
    final resultados = await abrirDialogoColumnas(context
        .read<BlocListaReproduccionSeleccionada>()
        .state
        .listaReproduccionSeleccionada);

    if (resultados == null) return;

    final List<ColumnaData> columnas = resultados["columnas"];
    final ColumnaData? columnaPrincipal = resultados["colPrincipal"];

    if (context.mounted) {
      final bloc = context.read<BlocListaReproduccionSeleccionada>();
      bloc.add(EvActColumnasLista(columnas.map((e) => e.id).toList()));

      if (columnaPrincipal != null) {
        bloc.add(EvActColumnaPrincipal(columnaPrincipal));
      }
    }
  }

  Future<void> renombrarCancion(
      BuildContext context, CancionColumnas cancion) async {
    String? nuevoNombre = await mostrarDialogoTexto(context, "Nuevo Nombre",
        txtIni: cancion.nombre);

    if (nuevoNombre == null) return;

    if (context.mounted) {
      context
          .read<BlocListaReproduccionSeleccionada>()
          .add(EvRenombrarCancion(cancion.id, nuevoNombre));
    }
  }

  Future<void> asignarValoresColumnasDetallado(
      BuildContext context, CancionColumnas cancion) async {
    Map<ColumnaData, ValorColumnaData?>? mapa =
        await abrirDialogoAsignarPropiedad(context
            .read<BlocListaReproduccionSeleccionada>()
            .state
            .lstColumnas);

    if (mapa == null) return;

    if (context.mounted) {
      context.read<BlocListaReproduccionSeleccionada>().add(
          EvActValoresColumnaCancionUnica(
              mapa.values
                  .where((element) => element != null)
                  .toList()
                  .map((e) => e!)
                  .toList(),
              cancion.id));
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
}
