import 'package:biblioteca_musica/backend/controles/control_panel_columna_lateral.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_reproduccion_general.dart';

import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_seleccionar_valor_columna.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PanelListaRepCualquiera extends PanelListaReproduccion {
  PanelListaRepCualquiera({super.key})
      : super(
            builderOpcionesNormales: (context, controlador) => [
                  SeccionCintaOpciones(lstItems: [
                    const TextoCintaOpciones(texto: "Reproducir"),

                    //REPRODUCIR EN ORDEN
                    BotonCintaOpciones(
                        icono: Icons.play_arrow,
                        texto: "Orden",
                        onPressed: (context) async {
                          context.read<BlocReproductor>().add(EvReproducirOrden(
                              context
                                  .read<BlocListaReproduccionSeleccionada>()
                                  .state
                                  .listaReproduccionSeleccionada));
                        }),

                    //REPRODUCIR AL AZAR
                    BotonCintaOpciones(
                        icono: Icons.shuffle,
                        texto: "Azar",
                        onPressed: (context) async {
                          context.read<BlocReproductor>().add(EvReproducirOrden(
                              context
                                  .read<BlocListaReproduccionSeleccionada>()
                                  .state
                                  .listaReproduccionSeleccionada));
                        }),
                  ]),
                  const SizedBox(width: 10),
                  SeccionCintaOpciones(lstItems: [
                    //IMPORTAR CANCIONES
                    BotonCintaOpciones(
                        icono: Icons.folder_copy,
                        texto: "Importar Canciones",
                        onPressed: (context) async {
                          FilePickerResult? lstArchivosSeleccionados =
                              await FilePicker.platform
                                  .pickFiles(allowMultiple: true);

                          if (lstArchivosSeleccionados == null) return;
                          if (context.mounted) {
                            context
                                .read<BlocListaReproduccionSeleccionada>()
                                .add(EvImportarCanciones(
                                    lstArchivosSeleccionados));
                          }
                        }),
                  ]),
                  const Spacer(),
                  SeccionCintaOpciones(lstItems: [
                    //RENOMBRAR LISTA
                    BotonCintaOpciones(
                        icono: Icons.edit,
                        texto: "Renombrar",
                        onPressed: (context) async {
                          context
                              .read<BlocListaReproduccionSeleccionada>()
                              .add(EvRenombrarLista());
                        }),
                    //ELIMINAR LISTA
                    BotonCintaOpciones(
                        icono: Icons.delete,
                        texto: "Eliminar",
                        onPressed: (context) async {
                          context
                              .read<BlocListaReproduccionSeleccionada>()
                              .add(EvEliminarLista());
                        }),
                  ]),
                ],
            builderOpcionesSeleccion: (context, controlador, cantCancSel,
                    totalCanciones) =>
                [
                  SeccionCintaOpciones(lstItems: [
                    //CHECKBOX SELECCIONAR TODOS
                    Checkbox(
                        //BOOL TODOS SELECCIONADOS
                        activeColor: Deco.cRosa0,
                        value: cantCancSel == totalCanciones,
                        onChanged: (selTodo) {
                          context
                              .read<BlocListaReproduccionSeleccionada>()
                              .add(EvToggleSeleccionarTodo());
                        }),

                    const TextoCintaOpciones(texto: "Seleccionar Todo"),
                  ]),

                  const SizedBox(width: 10),

                  SeccionCintaOpciones(lstItems: [
                    //ASIGNAR CANCIONES SELECCIONADAS A LISTA DE REPRODUCCION
                    BotonPopUpMenuCintaOpciones(
                      icono: Icons.playlist_add_outlined,
                      enabled: cantCancSel > 0,
                      itemBuilder: (_) {
                        return (List<ListaReproduccionData>.from(context
                                .read<BlocPanelLateral>()
                                .state
                                .listasReproduccion)
                              ..removeWhere((element) =>
                                  element.id ==
                                  context
                                      .read<BlocListaReproduccionSeleccionada>()
                                      .state
                                      .listaReproduccionSeleccionada
                                      .id))
                            .map<PopupMenuItem<int>>((lista) => PopupMenuItem(
                                  value: lista.id,
                                  child: Text(lista.nombre),
                                ))
                            .toList();
                      },
                      onSelected: (idListaSel) async {
                        context
                            .read<BlocListaReproduccionSeleccionada>()
                            .add(EvAsignarCancionesALista(idListaSel));
                      },
                      texto: "Asignar Lista...",
                    ),

                    ///ASIGNAR VALORES COLUMNA A LAS CANCIONES SELECCIONADAS
                    BotonPopUpMenuCintaOpciones(
                        icono: Icons.view_column,
                        texto: "Asignar Columnas",
                        onSelected: (indexColumna) async {
                          if (indexColumna == -1) {
                            await agregarColumna();
                          } else {
                            final bloc = context
                                .read<BlocListaReproduccionSeleccionada>();
                            ValorColumnaData? valorColumnaSel =
                                await abrirDialogoSeleccionarValorColumna(
                                    bloc.state.lstColumnas[indexColumna], null);

                            if (valorColumnaSel == null) return;

                            bloc.add(EvActValorColumnaCanciones(
                                valorColumnaSel.id, valorColumnaSel.idColumna));
                          }
                        },
                        itemBuilder: (_) {
                          final columnas = context
                              .read<BlocListaReproduccionSeleccionada>()
                              .state
                              .lstColumnas;

                          List<PopupMenuEntry> popupitems = [
                            const PopupMenuItem(
                                value: -1,
                                child: Row(children: [
                                  Icon(Icons.add, color: Deco.cGray1),
                                  Text("Nueva Columna"),
                                ]))
                          ];
                          for (int i = 0; i < columnas.length; i++) {
                            popupitems.add(PopupMenuItem(
                                value: i, child: Text(columnas[i].nombre)));
                          }

                          return popupitems;
                        }),

                    //RECORTAR NOMBRES
                    BotonCintaOpciones(
                        icono: Icons.cut,
                        texto: "Recortar Nombres",
                        onPressed: (_) {
                          //controlador.recortarNombresCanciones();
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
                          // if (opSel == 0) {
                          //   await controlador.eliminarCancionesDeLista(
                          //       provListaRep.obtCancionesSeleccionadas(),
                          //       provGeneral.listaSel.id);
                          // } else {
                          //   await controlador.eliminarCancionesTotalmente(
                          //       provListaRep.obtCancionesSeleccionadas());
                          // }
                        })
                  ])
                ]);
}
