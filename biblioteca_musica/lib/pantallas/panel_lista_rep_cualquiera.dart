import 'package:biblioteca_musica/backend/controles/control_panel_columna_lateral.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/backend/providers/provider_lista_rep.dart';
import 'package:biblioteca_musica/backend/providers/provider_reproductor.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion_general.dart';

import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PanelListaRepCualquiera extends PanelListaReproduccion {
  PanelListaRepCualquiera({super.key})
      : super(
            builderOpcionesNormales: (context, provListaRep, controlador) => [
                  SeccionCintaOpciones(lstItems: [
                    const TextoCintaOpciones(texto: "Reproducir"),

                    //REPRODUCIR EN ORDEN
                    BotonCintaOpciones(
                        icono: Icons.play_arrow,
                        texto: "Orden",
                        onPressed: (_) async {
                          await Provider.of<ProviderReproductor>(context,
                                  listen: false)
                              .reproducirListaOrden(provGeneral.listaSel.id);
                        }),

                    //REPRODUCIR AL AZAR
                    BotonCintaOpciones(
                        icono: Icons.shuffle,
                        texto: "Azar",
                        onPressed: (_) async {
                          await Provider.of<ProviderReproductor>(context,
                                  listen: false)
                              .reproducirListaAzar(provGeneral.listaSel.id);
                        }),
                  ]),
                  const SizedBox(width: 10),
                  SeccionCintaOpciones(lstItems: [
                    //IMPORTAR CANCIONES
                    BotonCintaOpciones(
                        icono: Icons.folder_copy,
                        texto: "Importar Canciones",
                        onPressed: (_) async {
                          await controlador.importarCancionesEnLista(
                              provGeneral.listaSel.id);
                        }),
                  ]),
                  const Spacer(),
                  SeccionCintaOpciones(lstItems: [
                    //RENOMBRAR LISTA
                    BotonCintaOpciones(
                        icono: Icons.edit,
                        texto: "Renombrar",
                        onPressed: (_) async {
                          await controlador
                              .renombrarLista(provGeneral.listaSel.id);
                        }),
                    //ELIMINAR LISTA
                    BotonCintaOpciones(
                        icono: Icons.delete,
                        texto: "Eliminar",
                        onPressed: (_) async {
                          await controlador.eliminarListaReproduccion(
                              provGeneral.listaSel.id);
                        }),
                  ]),
                ],
            builderOpcionesSeleccion: (context, provListaRep, controlador,
                    cantCancSel, totalCanciones) =>
                [
                  SeccionCintaOpciones(lstItems: [
                    //CHECKBOX SELECCIONAR TODOS
                    Checkbox(
                        //BOOL TODOS SELECCIONADOS
                        activeColor: Deco.cRosa0,
                        value: cantCancSel == totalCanciones,
                        onChanged: (_) {
                          Provider.of<ProviderListaReproduccion>(context,
                                  listen: false)
                              .toggleSelTodo();
                        }),

                    const TextoCintaOpciones(texto: "Seleccionar Todo"),
                  ]),

                  const SizedBox(width: 10),

                  SeccionCintaOpciones(lstItems: [
                    //ASIGNAR CANCIONES SELECCIONADAS A LISTA DE REPRODUCCION
                    BotonPopUpMenuCintaOpciones(
                      icono: Icons.playlist_add_outlined,
                      enabled: cantCancSel > 0,
                      itemBuilder: (_) => (provGeneral.listas
                          .map<PopupMenuItem<int>>((lista) => PopupMenuItem(
                                value: lista.id,
                                child: Text(lista.nombre),
                              ))).toList(),
                      onSelected: (idListaSel) async {
                        await controlador.asignarCancionesLista(
                            Provider.of<ProviderListaReproduccion>(context,
                                    listen: false)
                                .obtCancionesSeleccionadas(),
                            idListaSel);
                        await actualizarDatosLocales();
                      },
                      texto: "Asignar Lista...",
                    ),

                    ///ASIGNAR VALORES COLUMNA A LAS CANCIONES SELECCIONADAS
                    BotonPopUpMenuCintaOpciones(
                        icono: Icons.view_column,
                        texto: "Asignar Columnas",
                        onSelected: (idColumna) async {
                          if (idColumna == -1) {
                            await agregarColumna();
                          } else {
                            await controlador
                                .asignarValorColumnaACancionesSimple(
                                    provListaRep.obtCancionesSeleccionadas(),
                                    provGeneral.columnasListaRepSel[idColumna]);
                          }
                        },
                        itemBuilder: (_) {
                          List<PopupMenuEntry> popupitems = [
                            const PopupMenuItem(
                                value: -1,
                                child: Row(children: [
                                  Icon(Icons.add, color: Deco.cGray1),
                                  Text("Nueva Columna"),
                                ]))
                          ];
                          for (int i = 0;
                              i < provGeneral.columnasListaRepSel.length;
                              i++) {
                            popupitems.add(PopupMenuItem(
                                value: i,
                                child: Text(provGeneral
                                    .columnasListaRepSel[i].nombre)));
                          }

                          return popupitems;
                        }),

                    //RECORTAR NOMBRES
                    BotonCintaOpciones(
                        icono: Icons.cut,
                        texto: "Recortar Nombres",
                        onPressed: (_) {
                          controlador.recortarNombresCanciones();
                        }),
                  ]),

                  const Spacer(),

                  ///ELIMINAR CANCIONES SELECCIONADAS
                  SeccionCintaOpciones(lstItems: [
                    BotonPopUpMenuCintaOpciones(
                        icono: Icons.delete_sweep,
                        texto: "Eliminar...",
                        itemBuilder: (_) => [
                              const PopupMenuItem(
                                  value: 0, child: Text("De esta Lista")),
                              const PopupMenuItem(
                                  value: 1, child: Text("Totalmente"))
                            ],
                        onSelected: (opSel) async {
                          if (opSel == 0) {
                            await controlador.eliminarCancionesDeLista(
                                provListaRep.obtCancionesSeleccionadas(),
                                provGeneral.listaSel.id);
                          } else {
                            await controlador.eliminarCancionesTotalmente(
                                provListaRep.obtCancionesSeleccionadas());
                          }
                        })
                  ])
                ]);
}
