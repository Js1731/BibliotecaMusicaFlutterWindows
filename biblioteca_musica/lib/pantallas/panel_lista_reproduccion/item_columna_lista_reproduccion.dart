import 'package:biblioteca_musica/backend/controles/control_panel_lista_reproduccion.dart';
import 'package:biblioteca_musica/bloc/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemColumnaListaReproduccion extends BtnGenerico {
  ItemColumnaListaReproduccion(
      {super.key,
      align = TextAlign.center,
      required String nombre,
      required int idColumna,
      required ContPanelListaReproduccion contPanelList,
      bool esPrincipal = false})
      : super(
            builder: (hover, context) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: hover ? Deco.cGray0 : Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextoPer(texto: nombre, tam: 15, align: align),
                  ),
                ),
            onPressed: (context) {
              context
                  .read<BlocListaReproduccionSeleccionada>()
                  .add(EvOrdenarListaPorColumna(idColumna));
            });
}
