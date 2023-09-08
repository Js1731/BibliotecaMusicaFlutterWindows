import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/bloc_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/eventos_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columnas_sistema/bloc_columnas_sistema.dart';
import 'package:biblioteca_musica/bloc/columnas_sistema/eventos_columnas_sistema.dart';
import 'package:biblioteca_musica/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/dialogos/dialogo_editar_valor_columna.dart';
import 'package:biblioteca_musica/dialogos/dialogo_ingresar_texto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dialogos/dialogo_agregar_valor_columna.dart';

class AuxiliarPanelColumnas {
  AuxiliarPanelColumnas();

  Future<void> agregarColumna(BuildContext context) async {
    String? nuevoNombre = await abrirDialogoIngresarTexto(
        context, "Nueva Columna", "Ingresa el nombre de la nueva columna");

    if (nuevoNombre == null) return;

    if (context.mounted) {
      context.read<BlocColumnasSistema>().add(EvAgregarColumna(nuevoNombre));
    }
  }

  Future<void> agregarValorColumna(BuildContext context,
      {ValorColumnaData? valorColIni}) async {
    await abrirDialogoAgregarValorColumna(context,
        context.read<BlocColumnaSeleccionada>().state.columnaSeleccionada!,
        valorColIni: valorColIni);
  }

  Future<void> editarValorColumna(
      BuildContext context, ValorColumnaData valorColumna) async {
    await abrirDialogoEditarValorColumna(
        context,
        context.read<BlocColumnaSeleccionada>().state.columnaSeleccionada!,
        valorColumna);
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
