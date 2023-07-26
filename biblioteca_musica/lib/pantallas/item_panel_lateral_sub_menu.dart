import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Boton ubicado en el PanelLateral, Se utiliza para acceder a paneles adicionales, como Opciones, Columnas, etc.
class ItemPanelLateralSubMenu extends BtnGenerico {
  ItemPanelLateralSubMenu(
      {required Panel panel,
      required String texto,
      required IconData icono,
      super.key})
      : super(
            builder: (hover, context) => Selector<ProviderGeneral, Panel?>(
                selector: (_, provG) => provG.panelSel,
                builder: (_, panelSel, __) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: panelSel == panel
                            ? Colors.white30
                            : hover
                                ? Colors.white10
                                : Colors.transparent),
                    child: Row(
                      children: [
                        Icon(
                          icono,
                          color: Deco.cGray,
                        ),
                        const SizedBox(width: 10),
                        TextoPer(
                          texto: texto,
                          tam: 14,
                          color: Deco.cGray,
                        )
                      ],
                    ),
                  );
                }),
            onPressed: (_) {
              provGeneral.cambiarPanelCentral(panel);
            });
}
