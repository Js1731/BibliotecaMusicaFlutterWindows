import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import 'btn_recortar_nombres.dart';
import 'btn_reproducir_azar.dart';
import 'btn_reproducir_orden.dart';
import 'opciones_lista_generica.dart';

class OpcionesListaCualquiera extends OpcionesListaGenerica {
  const OpcionesListaCualquiera({super.key});

  @override
  List<Widget> construirOpcionesNormales(BuildContext context) {
    return [
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
                  await FilePicker.platform.pickFiles(allowMultiple: true);

              if (lstArchivosSeleccionados == null) return;
              if (context.mounted) {
                context
                    .read<BlocListaReproduccionSeleccionada>()
                    .add(EvImportarCanciones(lstArchivosSeleccionados));
              }
            }),
      ]),
      const Spacer(),
      SeccionCintaOpciones(lstItems: [
        //RENOMBRAR LISTA
        BotonCintaOpciones(
          icono: Icons.drive_file_rename_outline,
          texto: "Renombrar",
          onPressed: (context) async {
            await context
                .read<AuxiliarListaReproduccion>()
                .renombrarLista(context);
          },
        ),

        //ELIMINAR LISTA
        BotonCintaOpciones(
            icono: Icons.delete,
            texto: "Eliminar",
            onPressed: (context) async {
              context.read<AuxiliarListaReproduccion>().eliminarLista(context);
            }),
      ]),
    ];
  }

  @override
  List<Widget> construirOpcionesSeleccion(BuildContext context) {
    return [
      SeccionCintaOpciones(lstItems: [
        //CHECKBOX SELECCIONAR TODOS
        BlocSelector<BlocListaReproduccionSeleccionada,
                EstadoListaReproduccionSelecconada, Tuple2<int, int>>(
            selector: (state) => Tuple2(
                state.obtCantidadCancionesSeleccionadas(),
                state.obtCantidadCancionesTotal()),
            builder: (context, data) {
              final cantCancSel = data.item1;
              final totalCanciones = data.item2;
              return Checkbox(
                  //BOOL TODOS SELECCIONADOS
                  activeColor: Deco.cRosa0,
                  value: cantCancSel == totalCanciones,
                  onChanged: (selTodo) {
                    context
                        .read<BlocListaReproduccionSeleccionada>()
                        .add(EvToggleSeleccionarTodo());
                  });
            }),

        const TextoCintaOpciones(texto: "Seleccionar Todo"),
      ]),

      const SizedBox(width: 10),

      SeccionCintaOpciones(lstItems: [
        //ASIGNAR CANCIONES SELECCIONADAS A LISTA DE REPRODUCCION
        BlocSelector<BlocListaReproduccionSeleccionada,
                EstadoListaReproduccionSelecconada, int>(
            selector: (state) => state.obtCantidadCancionesSeleccionadas(),
            builder: (context, cantCancSel) {
              return BotonPopUpMenuCintaOpciones(
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
              );
            }),

        ///ASIGNAR VALORES COLUMNA A LAS CANCIONES SELECCIONADAS
        BotonCintaOpciones(
          icono: Icons.view_column,
          texto: "Asignar Columnas...",
          onPressed: (context) async {
            await context
                .read<AuxiliarListaReproduccion>()
                .asignarValoresColumnaACanciones(context);
          },
        ),

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
                  const PopupMenuItem(value: 0, child: Text("De esta Lista")),
                  const PopupMenuItem(value: 1, child: Text("Totalmente"))
                ],
            onSelected: (opSel) async {
              if (opSel == 0) {
                context.read<BlocListaReproduccionSeleccionada>().add(
                    EvEliminarCancionesLista(context
                        .read<BlocListaReproduccionSeleccionada>()
                        .state
                        .obtCancionesSeleccionadas()));
              } else {
                context.read<BlocListaReproduccionSeleccionada>().add(
                    EvEliminarCancionesTotalmente(context
                        .read<BlocListaReproduccionSeleccionada>()
                        .state
                        .obtCancionesSeleccionadas()));
              }
            })
      ])
    ];
  }
}
