import 'package:biblioteca_musica/backend/controles/control_panel_lista_reproduccion.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/utiles.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/backend/providers/provider_lista_rep.dart';
import 'package:biblioteca_musica/backend/providers/provider_reproductor.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/pantallas/item_cancion.dart';
import 'package:biblioteca_musica/pantallas/item_columna_lista_reproduccion.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Panel para mostrar el contenido de una lista de reproduccion
///
///Tiene dos cintas de opciones, una para las opciones normales de la lista, y otra para las
///opciones cuando hay canciones seleccionadas.
///Se pueden configurar el contenido de ambas cintas.
abstract class PanelListaReproduccion extends StatefulWidget {
  final ContPanelListaReproduccion controlador = ContPanelListaReproduccion();
  final List<Widget> Function(
      BuildContext context,
      ProviderListaReproduccion provListaRep,
      ContPanelListaReproduccion controlador) builderOpcionesNormales;
  final List<Widget> Function(
      BuildContext context,
      ProviderListaReproduccion provListaRep,
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
    return Selector<
        ProviderGeneral,
        Tuple3<List<CancionData>, ListaReproduccionData,
            Map<int, Map<String, String?>>>>(
      selector: (_, provGen) => Tuple3(provGen.lstCancionesListaRepSel,
          provGen.listaSel, provGen.mapaCancionesPropiedades),
      builder: (_, datos, __) {
        final canciones = datos.item1;
        final listaSel = datos.item2;
        final mapaPropiedadesCancion = datos.item3;

        return Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //INFORMACION SOBRE LISTA DE REPRODUCTOR
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(
                  child: Text(listaSel.nombre,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold)),
                ),

                //CANTIDAD DE CANCIONES
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                    padding: const EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [
                      const Icon(Icons.access_time_filled, color: Deco.cGray1),
                      const SizedBox(width: 10),
                      Text(obtDuracionLista(canciones)),
                    ]))
              ]),

              const SizedBox(height: 10),

              //BARRA DE OPCIONES
              Selector<ProviderListaReproduccion, Tuple2<int, int>>(
                  selector: (_, provListaRep) => Tuple2(
                      provListaRep.cantCancionesSel,
                      provListaRep.totalCanciones),
                  builder: (_, datos, __) {
                    final cantCancionesSel = datos.item1;
                    final cantTotalCanciones = datos.item2;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: CintaOpciones(
                        key: ValueKey(cantCancionesSel != 0),
                        lstOpciones: cantCancionesSel == 0
                            ? widget.builderOpcionesNormales(
                                context,
                                Provider.of<ProviderListaReproduccion>(context,
                                    listen: false),
                                widget.controlador)
                            : widget.builderOpcionesSeleccion(
                                context,
                                Provider.of<ProviderListaReproduccion>(context,
                                    listen: false),
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
              Consumer<ProviderListaReproduccion>(
                  builder: (_, provListaRep, __) {
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
                      for (ColumnaData prop in provGeneral.columnasListaRepSel)
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
                          provGeneral.listaSel != listaRepTodo
                              ? IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    widget.controlador.editarColumnasListaRep(
                                        provGeneral.listaSel);
                                  },
                                  color: Deco.cGray1,
                                  icon: const Icon(Icons.more_vert_rounded,
                                      size: 20),
                                  splashRadius: 14)
                              : const SizedBox()
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
              Selector<ProviderReproductor, CancionData?>(
                  selector: (_, provRep) => provRep.cancionRep,
                  builder: (_, cancionRep, __) =>
                      Selector<ProviderListaReproduccion, Map>(
                          selector: (_, provListaRep) => provListaRep.mapaSel,
                          builder: (_, mapaCanSel, __) => Expanded(
                              child: canciones.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: canciones.length,
                                      itemBuilder: (_, index) {
                                        CancionData cancion = canciones[index];
                                        List<String?> propiedades =
                                            mapaPropiedadesCancion[cancion.id]!
                                                .values
                                                .toList();

                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          child: ItemCancion(
                                              contPanelListaRep:
                                                  widget.controlador,
                                              propiedades: propiedades,
                                              cancion: cancion,
                                              idLst: provGeneral.listaSel.id,
                                              modoSeleccion: provListaRep
                                                      .cantCancionesSel !=
                                                  0,
                                              seleccionado:
                                                  mapaCanSel[cancion.id] ??
                                                      false,
                                              reproduciendo:
                                                  cancion.id == cancionRep?.id),
                                        );
                                      })
                                  : const SizedBox.expand())))
            ]));
      },
    );
  }
}
