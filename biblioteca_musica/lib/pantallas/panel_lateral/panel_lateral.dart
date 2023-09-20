import 'package:biblioteca_musica/bloc/cubit_configuracion.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/bloc_listas_reproduccion.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/estado_listas_reproduccion.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/barra_agregar_lista_rep.dart';
import 'package:biblioteca_musica/pantallas/panel_log/btn_sincronizar.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/item_panel_lateral_lista_rep.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import '../../bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import '../../painters/custom_painter_kopi.dart';
import '../../painters/custom_painter_panel_lateral.dart';
import 'item_panel_lateral_sub_menu.dart';

///Panel donde se puede seleccionar una Lista de reproduccion para ver sus canciones y cualquier Panel Adicional.

class PanelLateral extends StatelessWidget {
  const PanelLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ConstructorPanelLateral();
  }
}

class _ConstructorPanelLateral extends StatelessWidget {
  final bool db = false;

  const _ConstructorPanelLateral();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 170,
        height: double.maxFinite,
        margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Column(
          children: [
            Expanded(
              child: CustomPaint(
                painter: CustomPainterPanelLateral(),
                child: BlocBuilder<BlocListasReproduccion,
                        EstadoListasReproduccion>(
                    builder: (context, estadoPanelLateral) {
                  return BlocSelector<BlocReproductor, EstadoReproductor,
                          Tuple2<ListaReproduccionData?, bool>>(
                      selector: (state) => Tuple2(
                          state.listaReproduccionReproducida,
                          state.reproduciendo),
                      builder: (context, dataReproductor) {
                        final listaReproducida = dataReproductor.item1;
                        final reproduciendo = dataReproductor.item2;

                        return BlocSelector<
                                BlocListaReproduccionSeleccionada,
                                EstadoListaReproduccionSelecconada,
                                ListaReproduccionData>(
                            selector: (state) =>
                                state.listaReproduccionSeleccionada,
                            builder: (context, listaRepSeleccionada) {
                              return BlocBuilder<CubitPanelSeleccionado, Panel>(
                                  builder: (context, panelSeleccionado) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //BANNER
                                      CustomPaint(
                                        painter: CustomPainterKOPI(),
                                        child: Container(
                                          height: 60,
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Row(children: [
                                            Image.asset(
                                              "assets/recursos/kopi_icono.png",
                                              width: 40,
                                              height: 40,
                                              isAntiAlias: true,
                                              filterQuality:
                                                  FilterQuality.medium,
                                            ),
                                            const SizedBox(width: 5),
                                            TextoPer(
                                              texto: "KOPI",
                                              tam: 40,
                                              color: DecoColores.rosaClaro,
                                            )
                                          ]),
                                        ),
                                      ),

                                      //ITEM PARA VER LISTA CON TODAS LAS CANCIONES

                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 10,
                                        ),
                                        child: ItemPanelLateralListaRep(
                                          texto: listaRepBiblioteca.nombre,
                                          seleccionado: panelSeleccionado ==
                                                  Panel.listasRep &&
                                              listaRepSeleccionada.id ==
                                                  listaRepBiblioteca.id,
                                          onPressed: () {
                                            context
                                                .read<CubitPanelSeleccionado>()
                                                .cambiarPanel(Panel.listasRep);

                                            context
                                                .read<
                                                    BlocListaReproduccionSeleccionada>()
                                                .add(EvSeleccionarLista(
                                                    listaRepBiblioteca));
                                          },
                                          reproduciendo: listaReproducida?.id ==
                                                  listaRepBiblioteca.id &&
                                              reproduciendo,
                                        ),
                                      ),

                                      //BARRA AGREGAR LISTA
                                      const BarraAgregarListaRep(),

                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                            left: 10,
                                          ),
                                          child: Column(
                                            children: [
                                              if (db)
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DriftDbViewer(
                                                                      appDb)));
                                                    },
                                                    child: const Text("Drift")),

                                              //LISTA DE LISTAS DE REPRODUCCION
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: estadoPanelLateral
                                                      .listasReproduccion
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final lista = estadoPanelLateral
                                                            .listasReproduccion[
                                                        index];
                                                    return ItemPanelLateralListaRep(
                                                      reproduciendo:
                                                          listaReproducida
                                                                      ?.id ==
                                                                  lista.id &&
                                                              reproduciendo,
                                                      texto: lista.nombre,
                                                      seleccionado:
                                                          panelSeleccionado ==
                                                                  Panel
                                                                      .listasRep &&
                                                              listaRepSeleccionada
                                                                      .id ==
                                                                  lista.id,
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                CubitPanelSeleccionado>()
                                                            .cambiarPanel(Panel
                                                                .listasRep);

                                                        context
                                                            .read<
                                                                BlocListaReproduccionSeleccionada>()
                                                            .add(
                                                                EvSeleccionarLista(
                                                              lista,
                                                            ));
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),

                                              //BOTON PARA MOSTRAR INTERFAZ DE COLUMNAS
                                              ItemPanelLateralSubMenu(
                                                texto: "Columnas",
                                                icono: Icons.library_books,
                                                panel: Panel.columnas,
                                                colorPanel: DecoColores.rosa,
                                                colorTextoSel: Colors.white,
                                              ),

                                              const SizedBox(height: 5),

                                              //BOTON PARA MOSTRAR INTERFAZ DE CONFIGURACION
                                              ItemPanelLateralSubMenu(
                                                texto: "Ajustes",
                                                icono: Icons.settings,
                                                panel: Panel.ajustes,
                                                colorPanel: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]);
                              });
                            });
                      });
                }),
              ),
            ),
            BlocBuilder<CubitConf, EstadoConfig>(
              builder: (context, state) {
                return !state.mostrarLog
                    ? Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 40,
                        child: const BtnSincronizar(
                          conLog: false,
                        ))
                    : const SizedBox();
              },
            )
          ],
        ));
  }
}
