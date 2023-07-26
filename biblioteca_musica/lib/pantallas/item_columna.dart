import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/providers/provider_panel_propiedad.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemColumna extends BtnGenerico {
  ItemColumna({required ColumnaData columna, required onPressed, super.key})
      : super(
            builder: (hover, context) {
              return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  width: double.infinity,
                  height: 30,
                  child: Selector<ProviderPanelColumnas, ColumnaData?>(
                      selector: (_, provProp) => provProp.tipoPropiedadSel,
                      builder: (_, columnaSel, __) {
                        return Container(

                            //PROPIEDADES
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

                            //DECORACION
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (columnaSel?.id == columna.id)
                                    ? Colors.white30
                                    : hover == true
                                        ? Colors.white12
                                        : Colors.transparent),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextoPer(
                                  texto: columna.nombre,
                                  tam: 16,
                                  color: Deco.cGray,
                                )));
                      }));
            },
            onPressed: onPressed);
}
