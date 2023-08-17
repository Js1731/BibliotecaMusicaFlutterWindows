import 'package:biblioteca_musica/backend/misc/CustomPainerPanelCentral.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/auxiliar_panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_rep_cualquiera.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_rep_todo.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

final GlobalKey<PantPrincipalState> keyPantPrincipal = GlobalKey();

class PantPrincipal extends StatefulWidget {
  PantPrincipal() : super(key: keyPantPrincipal);

  @override
  State createState() => PantPrincipalState();
}

class PantPrincipalState extends State<PantPrincipal> {
  bool iniciado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: DecoColores.gris,
              child: Column(
                children: [
                  Expanded(
                    child: Row(children: [
                      Provider(
                          create: (context) => AuxiliarPanelLateral(),
                          child: const PanelLateral()),

                      //PANEL PANTALLA MOSTRADA EN LA PANTALLA CENTRAL

                      BlocBuilder<CubitPanelSeleccionado, Panel>(
                        builder: (context, panel) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 10, right: 10, bottom: 10),
                            child: CustomPaint(
                              painter: CustomPainerPanelCentral(),
                              child: panel == Panel.listaRepBiblioteca
                                  ? Provider(
                                      create: (context) =>
                                          AuxiliarListaReproduccion(),
                                      child: PanellistaRepBiblioteca())
                                  : panel == Panel.listasRep
                                      ? Provider(
                                          create: (context) =>
                                              AuxiliarListaReproduccion(),
                                          child: PanelListaRepCualquiera())
                                      : const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  //const PanelBarraLog(),
                  //const PanelReproductor()
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
    );

    //const BarraSync()
  }
}
