import 'package:biblioteca_musica/bloc/panel_lateral/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import 'btn_importar_canciones.dart';
import 'btn_recortar_nombres.dart';
import 'btn_reproducir_azar.dart';
import 'btn_reproducir_orden.dart';
import 'opciones_lista_generica.dart';

class OpcionesListaBiblioteca extends OpcionesListaGenerica {
  const OpcionesListaBiblioteca({super.key});

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
      SeccionCintaOpciones(
        lstItems: [
          //IMPORTAR CANCIONES
          BtnImportarCanciones()
        ],
      )
    ];
  }

  @override
  List<Widget> construirOpcionesSeleccion(BuildContext context) {
    return [
      SeccionCintaOpciones(
        lstItems: [
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
                    value: cantCancSel == totalCanciones,
                    activeColor: Deco.cRosa0,
                    onChanged: (todoSel) {
                      context
                          .read<BlocListaReproduccionSeleccionada>()
                          .add(EvToggleSeleccionarTodo());
                    });
              }),

          const TextoCintaOpciones(texto: "Seleccionar Todo"),
        ],
      ),

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
      SeccionCintaOpciones(
        lstItems: [
          BotonCintaOpciones(
              icono: Icons.delete_sweep,
              texto: "Eliminar",
              onPressed: (_) async {
                context
                    .read<AuxiliarListaReproduccion>()
                    .eliminarCancionesTotalmente(
                        context,
                        context
                            .read<BlocListaReproduccionSeleccionada>()
                            .state
                            .obtCancionesSeleccionadas());
              })
        ],
      ),
    ];
  }
}
