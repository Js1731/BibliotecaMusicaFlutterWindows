import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/bloc_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/eventos_columna_seleccionada.dart';
import 'package:biblioteca_musica/dialogos/dialogo_agregar_valor_columna.dart';
import 'package:biblioteca_musica/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/dialogos/dialogo_ingresar_texto.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuxiliarPanelColumnas {
  final RepositorioColumnas _repositorioColumnas;

  AuxiliarPanelColumnas(this._repositorioColumnas);

  Future<void> agregarColumna(BuildContext context) async {
    String? nuevoNombre = await abrirDialogoIngresarTexto(
        context, "Nueva Columna", "Ingresa el nombre de la nueva columna");

    if (nuevoNombre == null) return;

    _repositorioColumnas.agregarColumna(nuevoNombre);
  }

  Future<void> agregarValorColumna(BuildContext context,
      {ValorColumnaData? valorColIni}) async {
    await abrirDialogoAgregarValorColumna(context,
        context.read<BlocColumnaSeleccionada>().state.columnaSeleccionada!,
        valorColIni: valorColIni);
  }

  Future<void> eliminarValorColumna(
      BuildContext context, ValorColumnaData valorColumna) async {
    final confirmar = await abrirDialogoConfirmar(
        context,
        "Eliminar ${valorColumna.nombre}",
        "Quires eliminar ${valorColumna.nombre}");

    if (confirmar == null) return;

    if (context.mounted) {
      context
          .read<BlocColumnaSeleccionada>()
          .add(EvEliminarValorColumna(valorColumna));
    }
  }
}
