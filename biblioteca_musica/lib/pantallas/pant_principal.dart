import 'package:biblioteca_musica/backend/misc/CustomPainerPanelCentral.dart';
import 'package:biblioteca_musica/backend/misc/Intents.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/backend/providers/provider_panel_propiedad.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/pantallas/panel_barra_log.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_rep_todo.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas_principal.dart';
import 'package:biblioteca_musica/pantallas/panel_reproductor.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
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
          child: Stack(
            children: [
              Container(
                color: DecoColores.gris,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(children: <Widget>[
                        const PanelLateral(),

                        //PANEL PANTALLA MOSTRADA EN LA PANTALLA CENTRAL

                        Selector<ProviderGeneral, Panel?>(
                          selector: (_, provGeneral) => provGeneral.panelSel,
                          builder: (_, panel, __) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 10, right: 10, bottom: 10),
                              child: CustomPaint(
                                painter: CustomPainerPanelCentral(),
                                child: panel == Panel.listaRepTodo
                                    ? PanelListaRepTodo()
                                    : panel == Panel.listasRep
                                        ? PanelListaRepCualquiera()
                                        : panel == Panel.propiedades
                                            ? const PanelColumnasPrincipal()
                                            : const SizedBox(),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    const PanelBarraLog(),
                    const PanelReproductor()
                  ],
                ),
              ),
              WindowTitleBarBox(child: MoveWindow()),
              Container(
                margin: const EdgeInsets.all(10),
                alignment: Alignment.topRight,
                child: WindowTitleBarBox(
                    child: Row(
                  children: [
                    const Spacer(),
                    MinimizeWindowButton(),
                    MaximizeWindowButton(),
                    CloseWindowButton(
                      colors:
                          WindowButtonColors(mouseOver: DecoColores.rosaClaro1),
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),

      //const BarraSync()
    );
  }
}
