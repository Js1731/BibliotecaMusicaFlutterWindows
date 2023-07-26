import 'package:biblioteca_musica/controles/control_panel_lista_reproduccion.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

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
            onPressed: (_) {
              contPanelList.asignarColumnaOrden(
                  provGeneral.listaSel.id, idColumna);
            });
}
