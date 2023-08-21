import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/btn_recortar_nombres.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/btn_reproducir_azar.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_reproduccion_general.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'btn_reproducir_orden.dart';

class PanelListaRepCualquiera extends PanelListaReproduccion {
  PanelListaRepCualquiera({super.key})
      : super(
            builderOpcionesNormales: (context, controlador) => [
                  SeccionCintaOpciones(lstItems: [
                    const TextoCintaOpciones(texto: "Reproducir"),

                    //REPRODUCIR EN ORDEN
                    BtnReproducirOrden(),

                    //REPRODUCIR AL AZAR
                    BtnReproducirAzar(),
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
                    BtnRecortarNombres(),

                    //ELIMINAR LISTA
                    BotonCintaOpciones(
                        icono: Icons.delete,
                        texto: "Eliminar",
                        onPressed: (context) async {
                          context
                              .read<AuxiliarListaReproduccion>()
                              .eliminarLista(context);
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
                        return List<ListaReproduccionData>.from(context
                                .read<BlocPanelLateral>()
                                .state
                                .obtListasRepExcepto(context
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
                    BotonPopUpMenuCintaOpciones<ColumnaData>(
                        icono: Icons.view_column,
                        texto: "Asignar Columnas",
                        onSelected: (columnaSel) async {
                          if (columnaSel.id == -1) {
                            await context
                                .read<AuxiliarListaReproduccion>()
                                .agregarColumna(context);
                          } else {
                            await context
                                .read<AuxiliarListaReproduccion>()
                                .asignarValoresColumnaACanciones(
                                    context, columnaSel);
                          }
                        },
                        itemBuilder: (_) {
                          final columnas = context
                              .read<BlocListaReproduccionSeleccionada>()
                              .state
                              .lstColumnas;

                          List<PopupMenuEntry<ColumnaData>> popupitems = [
                            const PopupMenuItem(
                                value: ColumnaData(
                                    id: -1, nombre: "Nueva Columna"),
                                child: Row(children: [
                                  Icon(Icons.add, color: Deco.cGray1),
                                  Text("Nueva Columna"),
                                ])),
                            ...columnas.map((col) => PopupMenuItem<ColumnaData>(
                                value: col, child: Text(col.nombre)))
                          ];

                          return popupitems;
                        }),

                    //RECORTAR NOMBRES
                    BtnRecortarNombres()
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
                            context
                                .read<BlocListaReproduccionSeleccionada>()
                                .add(EvEliminarCancionesLista());
                          } else {
                            context
                                .read<BlocListaReproduccionSeleccionada>()
                                .add(EvEliminarCancionesTotalmente());
                          }
                        })
                  ])
                ]);
}
