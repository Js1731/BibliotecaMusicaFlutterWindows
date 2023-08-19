import 'package:biblioteca_musica/backend/controles/control_panel_lista_reproduccion.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/backend/misc/utiles.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/item_cancion.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/item_columna_lista_reproduccion.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

///Panel para mostrar el contenido de una lista de reproduccion
///
///Tiene dos cintas de opciones, una para las opciones normales de la lista, y otra para las
///opciones cuando hay canciones seleccionadas.
///Se pueden configurar el contenido de ambas cintas.
abstract class PanelListaReproduccion extends StatefulWidget {
  final ContPanelListaReproduccion controlador = ContPanelListaReproduccion();
  final List<Widget> Function(
          BuildContext context, ContPanelListaReproduccion controlador)
      builderOpcionesNormales;
  final List<Widget> Function(
      BuildContext context,
      ContPanelListaReproduccion controlador,
      int cantCancionesSeleccionadas,
      int totalCanciones) builderOpcionesSeleccion;

  ///Crea un panel para mostrar el contenido de una lista de reproduccion.
  ///
  ///<p>Para configurar el contenido de la cinta de opciones normales usar [builderOpcionesNormales]
  ///<p>Para configurar el contenido de la cinta cuando se seleccionan canciones usar [builderOpcionesSeleccion],
  ///los ultimos enteros del builder son [cantidad de canciones seleccionadas y Total de canciones de la lista]
  PanelListaReproduccion(
      {required this.builderOpcionesNormales,
      required this.builderOpcionesSeleccion,
      super.key});

  @override
  State<StatefulWidget> createState() => EstadoPanelListaReproduccion();
}

class EstadoPanelListaReproduccion extends State<PanelListaReproduccion> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<
        BlocListaReproduccionSeleccionada,
        EstadoListaReproduccionSelecconada,
        Tuple3<List<CancionColumnas>, ListaReproduccionData, Map<int, bool>>>(
      selector: (state) => Tuple3(
          state.listaCanciones,
          state.listaReproduccionSeleccionada,
          state.mapaCancionesSeleccionadas),
      builder: (_, datos) {
        final canciones = datos.item1;
        final listaSel = datos.item2;
        final mapaCancionesSel = datos.item3;

        return BlocSelector<BlocReproductor, EstadoReproductor,
                CancionColumnaPrincipal?>(
            selector: (state) => state.cancionReproducida,
            builder: (context, cancionReproducida) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //INFORMACION SOBRE LISTA DE REPRODUCTOR
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(listaSel.nombre,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  width: 80,
                                  child: Row(children: [
                                    const Icon(Icons.music_note,
                                        color: Deco.cGray1),
                                    Expanded(
                                      child: TextoPer(
                                          texto: "${canciones.length}",
                                          tam: 14,
                                          align: TextAlign.center),
                                    ),
                                  ])),

                              const SizedBox(width: 10),

                              //DURACION DE TODA LA LISTA DE REPRODUCCION
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(children: [
                                    const Icon(Icons.access_time_filled,
                                        color: Deco.cGray1),
                                    const SizedBox(width: 10),
                                    Text(obtDuracionLista(canciones)),
                                  ])),
                            ]),

                        //CANTIDAD DE CANCIONES

                        const SizedBox(height: 5),

                        //BARRA DE OPCIONES
                        BlocSelector<
                                BlocListaReproduccionSeleccionada,
                                EstadoListaReproduccionSelecconada,
                                Map<int, bool>>(
                            selector: (state) =>
                                state.mapaCancionesSeleccionadas,
                            builder: (_, datos) {
                              final int cantCancionesSel = context
                                  .read<BlocListaReproduccionSeleccionada>()
                                  .state
                                  .obtCancionesSeleccionadas()
                                  .length;
                              final int cantTotalCanciones = context
                                  .read<BlocListaReproduccionSeleccionada>()
                                  .state
                                  .obtCantidadCancionesTotal();
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                        opacity: animation, child: child),
                                child: CintaOpciones(
                                  key: ValueKey(cantCancionesSel != 0),
                                  lstOpciones: cantCancionesSel == 0
                                      ? widget.builderOpcionesNormales(
                                          context, widget.controlador)
                                      : widget.builderOpcionesSeleccion(
                                          context,
                                          widget.controlador,
                                          cantCancionesSel,
                                          cantTotalCanciones),
                                ),
                              );
                            }),

                        const SizedBox(height: 10),
                        const Divider(color: Colors.black38, height: 2),
                        const SizedBox(height: 5),

                        //COLUMNAS DE LA LISTA DE REPRODUCCION
                        BlocSelector<
                                BlocListaReproduccionSeleccionada,
                                EstadoListaReproduccionSelecconada,
                                List<ColumnaData>>(
                            selector: (state) => state.lstColumnas,
                            builder: (_, lstColumnas) {
                              return SizedBox(
                                height: 25,
                                child: Row(
                                  children: [
                                    //NOMBRE
                                    Expanded(
                                        child: ItemColumnaListaReproduccion(
                                            idColumna: -1,
                                            nombre: "Nombre",
                                            align: TextAlign.left,
                                            contPanelList: widget.controlador)),

                                    //COLUMNAS
                                    for (ColumnaData prop in lstColumnas)
                                      Expanded(
                                          child: ItemColumnaListaReproduccion(
                                        nombre: prop.nombre,
                                        idColumna: prop.id,
                                        contPanelList: widget.controlador,
                                      )),

                                    //DURACION
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: ItemColumnaListaReproduccion(
                                            idColumna: -2,
                                            nombre: "Duración",
                                            align: TextAlign.right,
                                            contPanelList: widget.controlador,
                                          ),
                                        ),
                                        if (listaSel.id !=
                                            listaRepBiblioteca.id)
                                          IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () async {
                                                await context
                                                    .read<
                                                        AuxiliarListaReproduccion>()
                                                    .actColumnasListaRep(
                                                        context);
                                              },
                                              color: Deco.cGray1,
                                              icon: const Icon(
                                                  Icons.more_vert_rounded,
                                                  size: 20),
                                              splashRadius: 14)
                                      ],
                                    )),
                                  ],
                                ),
                              );
                            }),

                        const SizedBox(height: 5),
                        const Divider(color: Colors.black38, height: 2),
                        const SizedBox(height: 10),

                        //LISTA DE CANCIONES
                        Expanded(
                            child: canciones.isNotEmpty
                                ? BlocBuilder<BlocReproductor,
                                        EstadoReproductor>(
                                    builder: (context, state) {
                                    final cancionReproducida =
                                        state.cancionReproducida;
                                    return ListView.builder(
                                        itemCount: canciones.length,
                                        itemBuilder: (_, index) {
                                          CancionColumnas cancion =
                                              canciones[index];

                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 6),
                                            child: ItemCancion(
                                                contPanelListaRep:
                                                    widget.controlador,
                                                cancion: cancion,
                                                idLst: listaSel.id,
                                                modoSeleccion: provListaRep
                                                        .cantCancionesSel !=
                                                    0,
                                                seleccionado: mapaCancionesSel[
                                                        cancion.id] ??
                                                    false,
                                                reproduciendo: cancion.id ==
                                                    cancionReproducida?.id),
                                          );
                                        });
                                  })
                                : const SizedBox())
                      ]));
            });
      },
    );
  }
}
