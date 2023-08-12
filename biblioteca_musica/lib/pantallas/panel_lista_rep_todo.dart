import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/bloc/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/bloc_reproductor.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion_general.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PanellistaRepBiblioteca extends PanelListaReproduccion {
  PanellistaRepBiblioteca({super.key})
      : super(
            builderOpcionesNormales: (context, controlador) => [
                  SeccionCintaOpciones(lstItems: [
                    const TextoCintaOpciones(texto: "Reproducir"),

                    //REPRODUCIR EN ORDEN
                    BotonCintaOpciones(
                        icono: Icons.play_arrow,
                        texto: "Orden",
                        onPressed: (context) async {
                          context
                              .read<BlocReproductor>()
                              .add(EvReproducirOrden(listaRepBiblioteca));
                        }),

                    //REPRODUCIR AL AZAR
                    BotonCintaOpciones(
                        icono: Icons.shuffle,
                        texto: "Azar",
                        onPressed: (context) async {
                          context
                              .read<BlocReproductor>()
                              .add(EvReproducirAzar(listaRepBiblioteca));
                        }),
                  ]),
                  const SizedBox(width: 10),
                  SeccionCintaOpciones(
                    lstItems: [
                      //IMPORTAR CANCIONES
                      BotonCintaOpciones(
                          icono: Icons.folder_copy,
                          texto: "Importar Canciones",
                          onPressed: (_) async {
                            await controlador.importarCancionesEnListaTodo();
                          }),
                    ],
                  ),
                ],
            builderOpcionesSeleccion:
                (context, controlador, cantCancSel, totalCanciones) => [
                      SeccionCintaOpciones(
                        lstItems: [
                          //CHECKBOX SELECCIONAR TODOS
                          Checkbox(
                              //BOOL TODOS SELECCIONADOS
                              value: cantCancSel == totalCanciones,
                              activeColor: Deco.cRosa0,
                              onChanged: (todoSel) {
                                context
                                    .read<BlocListaReproduccionSeleccionada>()
                                    .add(EvToogleSeleccionarTodo(todoSel!));
                              }),

                          const TextoCintaOpciones(texto: "Seleccionar Todo"),
                        ],
                      ),

                      const SizedBox(width: 10),

                      SeccionCintaOpciones(lstItems: [
                        //ASIGNAR CANCIONES SELECCIONADAS A LISTA DE REPRODUCCION
                        BotonPopUpMenuCintaOpciones(
                          icono: Icons.playlist_add_outlined,
                          enabled: cantCancSel > 0,
                          itemBuilder: (_) => (context
                              .read<BlocPanelLateral>()
                              .state
                              .listasReproduccion
                              .map<PopupMenuItem<int>>((lista) => PopupMenuItem(
                                    value: lista.id,
                                    child: Text(lista.nombre),
                                  ))).toList(),
                          onSelected: (idListaSel) async {},
                          texto: "Asignar Lista...",
                        ),

                        ///ASIGNAR VALORES COLUMNA A LAS CANCIONES SELECCIONADAS
                        BotonPopUpMenuCintaOpciones(
                            icono: Icons.view_column,
                            texto: "Asignar Columnas...",
                            onSelected: (idColumna) {},
                            itemBuilder: (_) {
                              List<PopupMenuEntry> popupitems = [];

                              final columnas = context
                                  .read<BlocListaReproduccionSeleccionada>()
                                  .state
                                  .lstColumnas;

                              for (int i = 0; i < columnas.length; i++) {
                                popupitems.add(PopupMenuItem(
                                    value: i, child: Text(columnas[i].nombre)));
                              }

                              return popupitems;
                            }),

                        //RECORTAR NOMBRES
                        BotonCintaOpciones(
                            icono: Icons.content_cut_rounded,
                            texto: "Recortar Nombres",
                            onPressed: (_) {
                              controlador.recortarNombresCanciones();
                            }),
                      ]),

                      const Spacer(),

                      //ELIMINAR CANCIONES SELECCIONADAS
                      SeccionCintaOpciones(
                        lstItems: [
                          BotonCintaOpciones(
                              icono: Icons.delete_sweep,
                              texto: "Eliminar",
                              onPressed: (_) async {
                                // await controlador.eliminarCancionesTotalmente(
                                //     provListaRep.obtCancionesSeleccionadas());
                              })
                        ],
                      ),
                    ]);
}

class btn_context {}
