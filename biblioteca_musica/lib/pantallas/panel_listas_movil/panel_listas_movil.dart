import 'package:biblioteca_musica/bloc/panel_lateral/bloc_listas_reproduccion.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/estado_listas_reproduccion.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/barra_agregar_lista_rep.dart';
import 'package:biblioteca_musica/pantallas/panel_listas_movil/item_lista_rep_movil.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PanelListasMovil extends StatelessWidget {
  const PanelListasMovil({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlocReproductor, EstadoReproductor,
            ListaReproduccionData?>(
        selector: (state) => state.listaReproduccionReproducida,
        builder: (context, listaReproducida) {
          return BlocSelector<BlocListasReproduccion, EstadoListasReproduccion,
                  List<ListaReproduccionData>>(
              selector: (state) => state.listasReproduccion,
              builder: (context, listasRep) {
                return Container(
                  padding: const EdgeInsets.all(0),
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      const Text("Música",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      const Divider(color: DecoColores.gris, thickness: 10),
                      ItemListaRepMovil(
                        listaRep: listaRepBiblioteca,
                        esListaReproducida:
                            listaReproducida?.id == listaRepBiblioteca.id,
                      ),
                      const BarraAgregarListaRep(),
                      Expanded(
                          child: ListView.builder(
                        itemCount: listasRep.length,
                        itemBuilder: (context, index) {
                          return ItemListaRepMovil(
                              listaRep: listasRep[index],
                              esListaReproducida:
                                  listaReproducida?.id == listasRep[index].id);
                        },
                      ))
                    ],
                  ),
                );
              });
        });
  }
}
