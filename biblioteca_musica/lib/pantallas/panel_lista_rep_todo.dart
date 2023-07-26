import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/misc/sincronizacion.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion_general.dart';
import 'package:biblioteca_musica/providers/provider_general.dart';
import 'package:biblioteca_musica/providers/provider_lista_rep.dart';
import 'package:biblioteca_musica/providers/provider_reproductor.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PanelListaRepTodo extends PanelListaReproduccion {
  PanelListaRepTodo({super.key})
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
                              .reproducirListaOrden(listaRepTodo.id);
                        }),

                    //REPRODUCIR AL AZAR
                    BotonCintaOpciones(
                        icono: Icons.shuffle,
                        texto: "Azar",
                        onPressed: (_) async {
                          await Provider.of<ProviderReproductor>(context,
                                  listen: false)
                              .reproducirListaAzar(listaRepTodo.id);
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
            builderOpcionesSeleccion: (context, provListaRep, controlador,
                    cantCancSel, totalCanciones) =>
                [
                  SeccionCintaOpciones(
                    lstItems: [
                      //CHECKBOX SELECCIONAR TODOS
                      Checkbox(
                          //BOOL TODOS SELECCIONADOS
                          value: cantCancSel == totalCanciones,
                          activeColor: Deco.cRosa0,
                          onChanged: (_) {
                            Provider.of<ProviderListaReproduccion>(context,
                                    listen: false)
                                .toggleSelTodo();
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
                        texto: "Asignar Columnas...",
                        onSelected: (idColumna) {
                          controlador.asignarValorColumnaACancionesSimple(
                              provListaRep.obtCancionesSeleccionadas(),
                              provGeneral.columnasListaRepSel[idColumna]);
                        },
                        itemBuilder: (_) {
                          List<PopupMenuEntry> popupitems = [];

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
                            await controlador.eliminarCancionesTotalmente(
                                provListaRep.obtCancionesSeleccionadas());
                          })
                    ],
                  ),
                ]);
}
