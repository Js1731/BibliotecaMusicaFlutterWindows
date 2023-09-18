import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/encabezado_columnas.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/item_cancion.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import 'opciones/cinta_opciones_lista.dart';

///Panel para mostrar el contenido de una lista de reproduccion
///
///Tiene dos cintas de opciones, una para las opciones normales de la lista, y otra para las
///opciones cuando hay canciones seleccionadas.
///Se pueden configurar el contenido de ambas cintas.
class PanelListaReproduccion extends StatefulWidget {
  ///Crea un panel para mostrar el contenido de una lista de reproduccion.
  ///
  ///<p>Para configurar el contenido de la cinta de opciones normales usar [builderOpcionesNormales]
  ///<p>Para configurar el contenido de la cinta cuando se seleccionan canciones usar [builderOpcionesSeleccion],
  ///los ultimos enteros del builder son [cantidad de canciones seleccionadas y Total de canciones de la lista]
  final ModoResponsive modoResponsive;
  const PanelListaReproduccion({required this.modoResponsive, super.key});

  @override
  State<StatefulWidget> createState() => EstadoPanelListaReproduccion();
}

class EstadoPanelListaReproduccion extends State<PanelListaReproduccion> {
  bool modoActColumnas = false;

  Widget _constructorInfoLista(List<CancionColumnas> canciones) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          width: 80,
          child: Row(children: [
            const Icon(Icons.music_note, color: Deco.cGray1),
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            const Icon(Icons.access_time_filled, color: Deco.cGray1),
            const SizedBox(width: 10),
            Text(obtDuracionLista(canciones)),
          ])),
    ]);
  }

  Widget _construirTitulo(ModoResponsive modo, ListaReproduccionData listaSel,
      List<CancionColumnas> canciones) {
    return modo != ModoResponsive.muyReducido
        ? Row(children: [
            Expanded(
                child: Text(listaSel.nombre,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold))),
            _constructorInfoLista(canciones)
          ])
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(listaSel.nombre,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              _constructorInfoLista(canciones)
            ],
          );
  }

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
                        _construirTitulo(
                            widget.modoResponsive, listaSel, canciones),

                        //CANTIDAD DE CANCIONES

                        const SizedBox(height: 5),

                        //CINTA DE OPCIONES
                        CintaOpcionesLista(modo: widget.modoResponsive),

                        //COLUMNAS DE LA LISTA DE REPRODUCCION
                        if (widget.modoResponsive != ModoResponsive.muyReducido)
                          LimitedBox(
                              maxHeight: 50,
                              child: EncabezadoColumnas(
                                  modo: widget.modoResponsive)),

                        //LISTA DE CANCIONES
                        Expanded(
                            child: canciones.isNotEmpty
                                ? BlocSelector<
                                        BlocListaReproduccionSeleccionada,
                                        EstadoListaReproduccionSelecconada,
                                        Map<int, bool>>(
                                    selector: (state) =>
                                        state.mapaCancionesSeleccionadas,
                                    builder: (context, mapaCancionesSel) {
                                      return BlocBuilder<BlocReproductor,
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3),
                                                child: ItemCancion(
                                                    cancion: cancion,
                                                    idLst: listaSel.id,
                                                    modoSeleccion:
                                                        mapaCancionesSel[
                                                                cancion.id] ??
                                                            false,
                                                    seleccionado:
                                                        mapaCancionesSel[
                                                                cancion.id] ??
                                                            false,
                                                    reproduciendo: cancion.id ==
                                                        cancionReproducida?.id,
                                                    idColumnaPrincipal: listaSel
                                                        .idColumnaPrincipal,
                                                    modo:
                                                        widget.modoResponsive),
                                              );
                                            });
                                      });
                                    })
                                : const SizedBox())
                      ]));
            });
      },
    );
  }
}
