import 'package:biblioteca_musica/bloc/panel_lateral/bloc_listas_reproduccion.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/opciones/btn_importar_canciones.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
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
  List<Widget> construirOpcionesNormales(
      BuildContext context, ModoResponsive modoResponsive) {
    return [
      SeccionCintaOpciones(lstItems: [
        const TextoCintaOpciones(texto: "Reproducir"),

        //REPRODUCIR EN ORDEN
        BtnReproducirOrden(modoResponsive: modoResponsive),

        //REPRODUCIR AL AZAR
        BtnReproducirAzar(modoResponsive: modoResponsive),
      ]),
      const SizedBox(width: 10),
      if (modoResponsive != ModoResponsive.muyReducido)
        SeccionCintaOpciones(lstItems: [
          //IMPORTAR CANCIONES
          BtnImportarCanciones(modoResponsive: modoResponsive)
        ]),
      const Spacer(),
      SeccionCintaOpciones(lstItems: [
        //RENOMBRAR LISTA
        if (modoResponsive != ModoResponsive.muyReducido)
          BotonCintaOpciones(
            icono: Icons.drive_file_rename_outline,
            texto: "Renombrar",
            modoResponsive: modoResponsive,
            onPressed: (context) async {
              await context
                  .read<AuxiliarListaReproduccion>()
                  .renombrarLista(context);
            },
          ),

        BlocSelector<BlocListaReproduccionSeleccionada,
                EstadoListaReproduccionSelecconada, List<ColumnaData>>(
            selector: (state) => state.lstColumnas,
            builder: (context, columnas) {
              return BotonPopUpMenuCintaOpciones<int>(
                  icono: Icons.sort,
                  texto: "Ordenar",
                  enabled: true,
                  modoResponsive: modoResponsive,
                  onSelected: (idColumnaSel) {
                    context
                        .read<AuxiliarListaReproduccion>()
                        .ordenarListaPorColumna(context, idColumnaSel);
                  },
                  itemBuilder: (context) {
                    List<PopupMenuItem<int>> listaColumnas = columnas
                        .map((columna) => PopupMenuItem(
                            value: columna.id, child: Text(columna.nombre)))
                        .toList();

                    listaColumnas.insert(0,
                        const PopupMenuItem(value: -1, child: Text("Nombre")));

                    listaColumnas.add(const PopupMenuItem(
                        value: -2, child: Text("Duracion")));

                    return listaColumnas;
                  });
            }),

        //ELIMINAR LISTA
        if (modoResponsive != ModoResponsive.muyReducido)
          BotonCintaOpciones(
              icono: Icons.delete,
              texto: "Eliminar",
              modoResponsive: modoResponsive,
              onPressed: (context) async {
                await context
                    .read<AuxiliarListaReproduccion>()
                    .eliminarLista(context);
              }),
      ]),
    ];
  }

  @override
  List<Widget> construirOpcionesSeleccion(
      BuildContext context, ModoResponsive modoResponsive) {
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
                modoResponsive: modoResponsive,
                itemBuilder: (_) {
                  return List<ListaReproduccionData>.from(context
                          .read<BlocListasReproduccion>()
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
          modoResponsive: modoResponsive,
          onPressed: (context) async {
            await context
                .read<AuxiliarListaReproduccion>()
                .asignarValoresColumnaACanciones(context);
          },
        ),

        //RECORTAR NOMBRES
        BtnRecortarNombres(modoResponsive: modoResponsive)
      ]),

      const Spacer(),

      ///ELIMINAR CANCIONES SELECCIONADAS
      SeccionCintaOpciones(lstItems: [
        BotonPopUpMenuCintaOpciones(
            icono: Icons.delete_sweep,
            texto: "Eliminar...",
            modoResponsive: modoResponsive,
            itemBuilder: (_) => [
                  const PopupMenuItem(value: 0, child: Text("De esta Lista")),
                  const PopupMenuItem(value: 1, child: Text("Totalmente"))
                ],
            onSelected: (opSel) async {
              if (opSel == 0) {
                context
                    .read<AuxiliarListaReproduccion>()
                    .eliminarCancionesLista(
                        context,
                        context
                            .read<BlocListaReproduccionSeleccionada>()
                            .state
                            .obtCancionesSeleccionadas());
              } else {
                context
                    .read<AuxiliarListaReproduccion>()
                    .eliminarCancionesTotalmente(
                        context,
                        context
                            .read<BlocListaReproduccionSeleccionada>()
                            .state
                            .obtCancionesSeleccionadas());
              }
            })
      ])
    ];
  }
}
