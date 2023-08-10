import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/backend/providers/provider_panel_propiedad.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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
            builder: (hover, context) => Selector<ProviderGeneral, Panel?>(
                selector: (_, p) => p.panelSel,
                builder: (context, panelSel, child) {
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
              provGeneral.cambiarPanelCentral(panel);
              Provider.of<ProviderPanelColumnas>(context, listen: false)
                  .seleccionarColumna(
                      (await provGeneral.obtTodasColumnas()).first);
            });
}
