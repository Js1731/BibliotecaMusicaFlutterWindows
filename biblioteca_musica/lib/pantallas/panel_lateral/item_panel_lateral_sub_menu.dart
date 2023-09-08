import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

///Boton ubicado en el PanelLateral, Se utiliza para acceder a paneles adicionales, como Opciones, Columnas, etc.
class ItemPanelLateralSubMenu extends BtnGenerico {
  ItemPanelLateralSubMenu(
      {required Panel panel,
      required String texto,
      required Color colorPanel,
      Color colorTextoSel = DecoColores.rosa,
      required IconData icono,
      super.key})
      : super(
            builder: (hover, context) =>
                BlocBuilder<CubitPanelSeleccionado, Panel?>(
                    builder: (context, panelSel) {
                  return Container(
                    margin: EdgeInsets.only(
                      top: 2,
                      bottom: 2,
                      right: (hover && panel != panelSel) ? 10 : 0,
                    ),
                    width: double.infinity,
                    height: 25,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

                        //DECORACION
                        decoration: BoxDecoration(
                            borderRadius: (hover && panel != panelSel)
                                ? BorderRadius.circular(10)
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                            color: panel == panelSel
                                ? colorPanel
                                : hover
                                    ? Colors.white24
                                    : Colors.transparent),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),

                            //NOMBRE DE LA LISTA
                            child: Row(
                              children: [
                                Icon(
                                  icono,
                                  color: panel == panelSel
                                      ? colorTextoSel
                                      : Colors.white,
                                ),
                                const SizedBox(width: 10),
                                TextoPer(
                                  texto: texto,
                                  tam: 16,
                                  color: panel == panelSel
                                      ? colorTextoSel
                                      : Colors.white,
                                ),
                              ],
                            ))),
                  );
                }),
            onPressed: (context) async {
              context.read<CubitPanelSeleccionado>().cambiarPanel(panel);
            });
}
