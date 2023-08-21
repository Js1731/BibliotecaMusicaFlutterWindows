import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/columnas_sistema/bloc_columnas_sistema.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/btn_importar_canciones.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/btn_recortar_nombres.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/btn_reproducir_orden.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_reproduccion_general.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/columnas_sistema/estado_columnas_sistema.dart';
import 'btn_reproducir_azar.dart';

class PanelBiblioteca extends PanelListaReproduccion {
  PanelBiblioteca({super.key})
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
                  SeccionCintaOpciones(
                    lstItems: [
                      //IMPORTAR CANCIONES
                      BtnImportarCanciones()
                    ],
                  ),
                ],
            builderOpcionesSeleccion: (context, controlador, cantCancSel,
                    totalCanciones) =>
                [
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
                                .add(EvToggleSeleccionarTodo());
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
                      onSelected: (idListaSel) async {
                        context
                            .read<BlocListaReproduccionSeleccionada>()
                            .add(EvAsignarCancionesALista(idListaSel));
                      },
                      texto: "Asignar Lista...",
                    ),

                    ///ASIGNAR VALORES COLUMNA A LAS CANCIONES SELECCIONADAS
                    BlocBuilder<BlocColumnasSistema, EstadoColumnasSistema>(
                        builder: (context, state) {
                      return BotonPopUpMenuCintaOpciones<ColumnaData>(
                          icono: Icons.view_column,
                          texto: "Asignar Columnas...",
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
                            final columnas = state.columnas;
                            List<PopupMenuEntry<ColumnaData>> popupitems = [
                              const PopupMenuItem<ColumnaData>(
                                  value: ColumnaData(id: -1, nombre: "Nueva"),
                                  child: Row(children: [
                                    Icon(Icons.add, color: Deco.cGray1),
                                    Text("Nueva Columna"),
                                  ])),
                              ...columnas.map((col) =>
                                  PopupMenuItem<ColumnaData>(
                                      value: col, child: Text(col.nombre)))
                            ];

                            return popupitems;
                          });
                    }),

                    //RECORTAR NOMBRES
                    BtnRecortarNombres()
                  ]),

                  const Spacer(),

                  //ELIMINAR CANCIONES SELECCIONADAS
                  SeccionCintaOpciones(
                    lstItems: [
                      BotonCintaOpciones(
                          icono: Icons.delete_sweep,
                          texto: "Eliminar",
                          onPressed: (_) async {
                            context
                                .read<BlocListaReproduccionSeleccionada>()
                                .add(EvEliminarCancionesTotalmente());
                          })
                    ],
                  ),
                ]);
}
