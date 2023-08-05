import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/backend/providers/provider_reproductor.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ItemListaRep extends BtnGenerico {
  final ListaReproduccionData lst;

  ItemListaRep({required this.lst, super.key})
      : super(builder: (hover, context) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            width: double.infinity,
            height: 25,
            child: Selector<ProviderReproductor, int?>(
                selector: (_, provRep) => provRep.idListaRep,
                builder: (_, idListaRepReproduciendo, __) {
                  return Selector<ProviderGeneral,
                          Tuple2<ListaReproduccionData?, Panel?>>(
                      selector: (_, provGen) =>
                          Tuple2(provGen.listaSel, provGen.panelSel),
                      builder: (_, data, __) {
                        final listaSel = data.item1;
                        final panel = data.item2;
                        return Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

                            //DECORACION
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: idListaRepReproduciendo == lst.id
                                    ? Colors.white
                                    : (listaSel?.id == lst.id &&
                                            (panel == Panel.listaRepTodo ||
                                                panel == Panel.listasRep))
                                        ? Colors.white
                                        : hover == true
                                            ? Colors.white12
                                            : Colors.transparent),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),

                                //NOMBRE DE LA LISTA
                                child: TextoPer(
                                  texto: lst.nombre,
                                  tam: 16,
                                  color: lst.id == idListaRepReproduciendo
                                      ? Deco.cMorado2
                                      : (listaSel?.id == lst.id &&
                                              (panel == Panel.listaRepTodo ||
                                                  panel == Panel.listasRep))
                                          ? DecoColores.rosaClaro
                                          : Colors.white,
                                )));
                      });
                }),
          );
        }, onPressed: (context) {
          //ABRIR LISTA
          Provider.of<ProviderGeneral>(context, listen: false)
              .seleccionarLista(lst.id);
          provListaRep.actualizarMapaCancionesSel();
        });
}
