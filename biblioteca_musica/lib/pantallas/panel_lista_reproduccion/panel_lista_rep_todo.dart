import 'package:biblioteca_musica/backend/controles/control_panel_columna_lateral.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/cubit_columnas.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_reproduccion_general.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_texto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      return BotonPopUpMenuCintaOpciones(
                          icono: Icons.view_column,
                          texto: "Asignar Columnas...",
                          onSelected: (indexColumna) async {
                            if (indexColumna == -1) {
                              await agregarColumna();
                            } else {
                              final bloc = context.read<BlocColumnasSistema>();
                              ValorColumnaData? valorColumnaSel =
                                  await abrirDialogoSeleccionarValorColumna(
                                      bloc.state.columnas[indexColumna], null);

                              if (valorColumnaSel == null) return;
                              if (context.mounted) {
                                context
                                    .read<BlocListaReproduccionSeleccionada>()
                                    .add(EvActValorColumnaCanciones(
                                        valorColumnaSel.id,
                                        valorColumnaSel.idColumna));
                              }
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

                            final columnas = state.columnas;

                            for (int i = 0; i < columnas.length; i++) {
                              popupitems.add(PopupMenuItem(
                                  value: i, child: Text(columnas[i].nombre)));
                            }

                            return popupitems;
                          });
                    }),

                    //RECORTAR NOMBRES
                    BotonCintaOpciones(
                        icono: Icons.content_cut_rounded,
                        texto: "Recortar Nombres",
                        onPressed: (_) async {
                          context.read<BlocListaReproduccionSeleccionada>().add(
                              EvRecortarNombresCancionesSeleccionadas(
                                  await mostrarDialogoTexto(
                                          context, "Filtro") ??
                                      ""));
                          //controlador.recortarNombresCanciones();
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
                            context
                                .read<BlocListaReproduccionSeleccionada>()
                                .add(EvEliminarCancionesTotalmente());
                          })
                    ],
                  ),
                ]);
}
