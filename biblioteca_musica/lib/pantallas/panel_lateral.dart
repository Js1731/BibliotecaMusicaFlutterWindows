import 'package:biblioteca_musica/backend/controles/control_panel_lateral.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/CustomPainterAgregarLista.dart';
import 'package:biblioteca_musica/backend/misc/CustomPainterKOPI.dart';
import 'package:biblioteca_musica/backend/misc/CustomPainterPanelLateral.dart';
import 'package:biblioteca_musica/backend/misc/Intents.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/pantallas/item_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/item_panel_lateral_sub_menu.dart';
import 'package:biblioteca_musica/widgets/btn_agregar.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Panel donde se puede seleccionar una Lista de reproduccion para ver sus canciones y cualquier Panel Adicional.
class PanelLateral extends StatefulWidget {
  const PanelLateral({super.key});

  @override
  State<PanelLateral> createState() => EstadoPanelLateral();
}

class EstadoPanelLateral extends State<PanelLateral> {
  final ContPanelLateral controlador = ContPanelLateral();
  bool db = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: {
        IntentAgregarLista: CallbackAction(onInvoke: (intent) async {
          await controlador.agregarListaNueva();
          return null;
        }),
        IntentAbrirColumnas: CallbackAction(
          onInvoke: (intent) {
            provGeneral.cambiarPanelCentral(Panel.propiedades);
            return null;
          },
        ),
        IntentAbrirListaTodo: CallbackAction(
          onInvoke: (intent) {
            provGeneral.seleccionarLista(listaRepTodo.id);
            provListaRep.actualizarMapaCancionesSel();
            return null;
          },
        ),
        IntentSincronizar: CallbackAction(
          onInvoke: (intent) {
            sincronizar();
            return null;
          },
        )
      },
      child: Focus(
        autofocus: true,
        child: Container(
            width: 170,
            height: double.infinity,
            margin: const EdgeInsets.all(10),
            child: CustomPaint(
              painter: CustomPainterPanelLateral(),
              child: Column(children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomPaint(
                          painter: CustomPainterKOPI(),
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(children: [
                              Image.asset(
                                "assets/recursos/kopi_icono.png",
                                width: 40,
                                height: 40,
                                isAntiAlias: true,
                                filterQuality: FilterQuality.medium,
                              ),
                              const SizedBox(width: 5),
                              TextoPer(
                                texto: "KOPI",
                                tam: 40,
                                color: DecoColores.rosaClaro,
                              )
                            ]),
                          ),
                        ),
                        //ITEM PARA VER LISTA CON TODAS LAS CANCIONES
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: ItemListaRep(
                            lst: listaRepTodo,
                          ),
                        ),

                        Container(
                          height: 25,
                          color: DecoColores.rosaClaro1,
                          child: Stack(children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextoPer(
                                  texto: "Listas",
                                  tam: 16,
                                  color: Colors.white),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: BtnGenerico(onPressed: (_) async {
                                await controlador.agregarListaNueva();
                              }, builder: (hover, context) {
                                return CustomPaint(
                                  painter: CustomPainterAgregarLista(),
                                  child: Container(
                                    width: 80,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    height: double.maxFinite,
                                    child: TextoPer(
                                        texto: "Nuevo +",
                                        tam: 16,
                                        color: Colors.white),
                                  ),
                                );
                              }),
                            )
                          ]),
                        ),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              right: 10,
                              left: 10,
                            ),
                            child: Column(
                              children: [
                                if (db)
                                  ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DriftDbViewer(appDb)));
                                      },
                                      child: Text("Drift")),

                                //LISTA DE LISTAS DE REPRODUCCION
                                FutureBuilder(
                                    future: controlador.cargarListas(),
                                    builder: (context, snapshot) => Selector<
                                            ProviderGeneral,
                                            List<ListaReproduccionData>>(
                                        selector: (_, prov) => prov.listas,
                                        builder: (_, listas, __) => Expanded(
                                                child: ListView.builder(
                                              itemCount: listas.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final lista = listas[index];
                                                return ItemListaRep(
                                                  lst: lista,
                                                );
                                              },
                                            )))),

                                //BOTON PARA MOSTRAR INTERFAZ DE JUEGOS
                                ItemPanelLateralSubMenu(
                                  texto: "Columnas",
                                  icono: Icons.library_books,
                                  panel: Panel.propiedades,
                                ),

                                const SizedBox(height: 5),

                                //BOTON PARA MOSTRAR INTERFAZ DE CONFIGURACION
                                ItemPanelLateralSubMenu(
                                  texto: "Ajustes",
                                  icono: Icons.settings,
                                  panel: Panel.ajustes,
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                ),
              ]),
            )),
      ),
    );
  }
}
