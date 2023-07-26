import 'package:biblioteca_musica/backend/controles/control_panel_lateral.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/Intents.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/pantallas/item_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/item_panel_lateral_sub_menu.dart';
import 'package:biblioteca_musica/widgets/btn_agregar.dart';
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
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Deco.cMorado1, Deco.cMorado],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)),
            width: 200,
            height: double.infinity,
            child: Column(children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TITULO
                          TextoPer(
                            texto: "Canciones",
                            tam: 30,
                            color: Colors.white,
                            weight: FontWeight.bold,
                          ),

                          const Divider(
                            color: Deco.cGray,
                            height: 3,
                          ),

                          //ITEM PARA VER LISTA CON TODAS LAS CANCIONES
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ItemListaRep(
                              lst: listaRepTodo,
                            ),
                          ),

                          const Divider(
                            color: Deco.cGray,
                            height: 3,
                          ),

                          Row(
                            children: [
                              //TITULO
                              Expanded(
                                child: TextoPer(
                                  texto: "Listas",
                                  tam: 30,
                                  color: Colors.white,
                                  weight: FontWeight.bold,
                                ),
                              ),

                              //AGREGAR LISTA DE REPRODUCCION NUEVA
                              BtnAgregar(onPressed: (_) async {
                                await controlador.agregarListaNueva();
                              }),
                            ],
                          ),

                          if (db)
                            ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
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
                                            (BuildContext context, int index) {
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
                        ])),
              ),
            ])),
      ),
    );
  }
}
