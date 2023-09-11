import 'package:biblioteca_musica/bloc/panel_lateral/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/evento_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/sincronizador/cubit_sincronizacion.dart';
import 'package:biblioteca_musica/dialogos/dialogo_ingresar_texto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuxiliarPanelLateral {
  Future<void> agregarLista(BuildContext context) async {
    final nombreLista = await abrirDialogoIngresarTexto(
        context, "Nueva Lista", "Ingresa el nombre de la nueva lista.",
        hint: "Ej. Nueva Lista");

    if (nombreLista == null) return;

    if (context.mounted) {
      context
          .read<BlocPanelLateral>()
          .add(PanelLateralAgregarLista(nombreLista));

      context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
    }
  }
}
