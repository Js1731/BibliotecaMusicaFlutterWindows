import 'package:biblioteca_musica/backend/misc/Intents.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/backend/providers/provider_panel_propiedad.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/pantallas/panel_barra_log.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_rep_todo.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas_principal.dart';
import 'package:biblioteca_musica/pantallas/panel_reproductor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'panel_lista_rep_cualquiera.dart';

final GlobalKey<PantPrincipalState> keyPantPrincipal = GlobalKey();

class PantPrincipal extends StatefulWidget {
  PantPrincipal() : super(key: keyPantPrincipal);

  @override
  State createState() => PantPrincipalState();
}

class PantPrincipalState extends State<PantPrincipal> {
  bool iniciado = false;

  @override
  void initState() {
    super.initState();

    provGeneral.seleccionarLista(listaRepTodo.id);
    provListaRep.actualizarMapaCancionesSel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Shortcuts(
          shortcuts: {
            const SingleActivator(LogicalKeyboardKey.keyL):
                IntentAgregarLista(),
            const SingleActivator(LogicalKeyboardKey.keyC):
                IntentAbrirColumnas(),
            const SingleActivator(LogicalKeyboardKey.keyT):
                IntentAbrirListaTodo(),
            const SingleActivator(LogicalKeyboardKey.keyS, control: true):
                IntentSincronizar()
          },
          child: Column(
            children: [
              Expanded(
                child: Row(children: <Widget>[
                  const PanelLateral(),

                  //PANEL PANTALLA MOSTRADA EN LA PANTALLA CENTRAL

                  Selector<ProviderGeneral, Panel?>(
                    selector: (_, provGeneral) => provGeneral.panelSel,
                    builder: (_, panel, __) => Expanded(
                      child: panel == Panel.listaRepTodo
                          ? PanelListaRepTodo()
                          : panel == Panel.listasRep
                              ? PanelListaRepCualquiera()
                              : panel == Panel.propiedades
                                  ? ChangeNotifierProvider(
                                      create: (context) =>
                                          ProviderPanelColumnas(),
                                      child: const PanelColumnasPrincipal())
                                  : const SizedBox(),
                    ),
                  ),
                ]),
              ),
              const PanelBarraLog(),
              const PanelReproductor()
            ],
          ),
        ),
      ),

      //const BarraSync()
    );
  }
}
