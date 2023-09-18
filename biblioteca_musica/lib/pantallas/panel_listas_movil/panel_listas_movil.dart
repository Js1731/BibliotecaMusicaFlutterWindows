import 'package:biblioteca_musica/bloc/panel_lateral/bloc_listas_reproduccion.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/estado_listas_reproduccion.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/barra_agregar_lista_rep.dart';
import 'package:biblioteca_musica/pantallas/panel_listas_movil/item_lista_rep_movil.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

class PanelListasMovil extends StatelessWidget {
  const PanelListasMovil({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlocReproductor, EstadoReproductor,
            Tuple2<ListaReproduccionData?, bool>>(
        selector: (state) =>
            Tuple2(state.listaReproduccionReproducida, state.reproduciendo),
        builder: (context, datosRep) {
          final listaReproducida = datosRep.item1;
          final reproduciendo = datosRep.item2;
          return BlocSelector<BlocListasReproduccion, EstadoListasReproduccion,
                  List<ListaReproduccionData>>(
              selector: (state) => state.listasReproduccion,
              builder: (context, listasRep) {
                return BlocSelector<BlocListaReproduccionSeleccionada,
                        EstadoListaReproduccionSelecconada, int?>(
                    selector: (state) => state.listaReproduccionSeleccionada.id,
                    builder: (context, idListaRepSel) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 20),
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text("Música",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ),
                            ItemListaRepMovil(
                              listaRep: listaRepBiblioteca,
                              estaSeleccionada:
                                  idListaRepSel == listaRepBiblioteca.id,
                              esListaReproducida:
                                  listaReproducida?.id == listaRepBiblioteca.id,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: TextoPer(
                                  texto: "Listas",
                                  tam: 25,
                                  weight: FontWeight.bold),
                            ),
                            Expanded(
                                child: ListView.builder(
                              itemCount: listasRep.length,
                              itemBuilder: (context, index) {
                                return ItemListaRepMovil(
                                    listaRep: listasRep[index],
                                    estaSeleccionada:
                                        listasRep[index].id == idListaRepSel,
                                    esListaReproducida: (listaReproducida?.id ==
                                            listasRep[index].id) &&
                                        reproduciendo);
                              },
                            ))
                          ],
                        ),
                      );
                    });
              });
        });
  }
}
