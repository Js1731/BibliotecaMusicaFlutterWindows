import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/providers/provider_panel_propiedad.dart';
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
                  margin: const EdgeInsets.only(top: 2, bottom: 2, left: 10),
                  width: double.infinity,
                  height: 30,
                  child: Selector<ProviderPanelColumnas, ColumnaData?>(
                      selector: (_, provProp) => provProp.tipoPropiedadSel,
                      builder: (_, columnaSel, __) {
                        return Container(
                            margin: EdgeInsets.only(
                              top: 2,
                              bottom: 2,
                              right: (hover && columnaSel?.id != columna.id)
                                  ? 10
                                  : 0,
                            ), //(hover && listaS!.id != lst.id) ? 10 : 0),
                            width: double.infinity,
                            height: 25,
                            child: Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

                                //DECORACION
                                decoration: BoxDecoration(
                                    borderRadius: (hover &&
                                            columnaSel?.id != columna.id)
                                        ? BorderRadius.circular(10)
                                        : BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                    color: columnaSel?.id == columna.id
                                        ? Colors.white
                                        : hover == true
                                            ? Colors.white12
                                            : Colors.transparent),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),

                                    //NOMBRE DE LA LISTA
                                    child: TextoPer(
                                      texto: columna.nombre,
                                      tam: 16,
                                      color: columnaSel?.id == columna.id
                                          ? DecoColores.rosa
                                          : Colors.white,
                                    ))));
                      }));
            },
            onPressed: onPressed);
}
