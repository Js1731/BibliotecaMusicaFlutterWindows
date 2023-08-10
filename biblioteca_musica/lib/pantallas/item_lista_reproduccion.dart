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
          return Selector<ProviderReproductor, int?>(
              selector: (_, provRep) => provRep.idListaRep,
              builder: (_, idListaRepReproduciendo, __) {
                return Selector<ProviderGeneral, Tuple2<int, Panel?>>(
                    selector: (_, p) => Tuple2(p.listaSel.id, p.panelSel),
                    builder: (context, data, child) {
                      final idListaSel = data.item1;
                      final panel = data.item2;
                      return Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                top: 2,
                                bottom: 2,
                                right: (hover && idListaSel != lst.id) ? 10 : 0,
                              ),
                              width: double.infinity,
                              height: 25,
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

                                  //DECORACION
                                  decoration: BoxDecoration(
                                      borderRadius: (hover &&
                                              idListaSel != lst.id)
                                          ? BorderRadius.circular(10)
                                          : BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                      color: idListaSel == lst.id
                                          ? Colors.white
                                          : hover == true
                                              ? Colors.white12
                                              : Colors.transparent),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),

                                      //NOMBRE DE LA LISTA
                                      child: TextoPer(
                                        texto: lst.nombre,
                                        tam: 16,
                                        color: lst.id == idListaSel
                                            ? Deco.cMorado2
                                            : (idListaSel == lst.id &&
                                                    (panel ==
                                                            Panel
                                                                .listaRepTodo ||
                                                        panel ==
                                                            Panel.listasRep))
                                                ? DecoColores.rosaClaro
                                                : Colors.white,
                                      )))),
                          if (idListaRepReproduciendo == lst.id)
                            Container(
                              margin: const EdgeInsets.only(top: 3),
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.play_arrow,
                                color: idListaSel == lst.id
                                    ? DecoColores.rosaClaro
                                    : Colors.white,
                              ),
                            )
                        ],
                      );
                    });
              });
        }, onPressed: (context) {
          //ABRIR LISTA
          Provider.of<ProviderGeneral>(context, listen: false)
              .seleccionarLista(lst.id);
          provListaRep.actualizarMapaCancionesSel();
        });
}
