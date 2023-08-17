import 'package:biblioteca_musica/bloc/panel_lateral/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/evento_panel_lateral.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_texto.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuxiliarPanelLateral {
  Future<void> agregarLista(BuildContext context) async {
    final nombreLista = await mostrarDialogoTexto(context, "Nueva Lista");

    if (nombreLista == null) return;

    if (context.mounted) {
      context
          .read<BlocPanelLateral>()
          .add(PanelLateralAgregarLista(nombreLista));
    }
  }
}
