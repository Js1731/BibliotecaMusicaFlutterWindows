import 'package:biblioteca_musica/backend/misc/CustomPainerPanelCentral.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/bloc/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_rep_cualquiera.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_rep_todo.dart';
import 'package:biblioteca_musica/repositorios/repositorio_canciones.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:biblioteca_musica/repositorios/repositorio_listas_reproduccion.dart';
import 'package:biblioteca_musica/repositorios/repositorio_reproductor.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => CubitPanelSeleccionado()),
                BlocProvider(
                    create: (context) =>
                        BlocReproductor(context.read<RepositorioReproductor>())
                          ..add(EvEscucharReproductor())),
                BlocProvider(
                    create: (context) => BlocListaReproduccionSeleccionada(
                        context.read<RepositorioCanciones>(),
                        context.read<RepositorioColumnas>(),
                        context.read<RepositorioListasReproduccion>())
                      ..add(EvSeleccionarLista(listaRepBiblioteca)))
              ],
              child: Container(
                color: DecoColores.gris,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(children: [
                        PanelLateral(),

                        //PANEL PANTALLA MOSTRADA EN LA PANTALLA CENTRAL

                        BlocBuilder<CubitPanelSeleccionado, Panel>(
                          builder: (context, panel) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 10, right: 10, bottom: 10),
                              child: CustomPaint(
                                painter: CustomPainerPanelCentral(),
                                child: panel == Panel.listaRepBiblioteca
                                    ? PanellistaRepBiblioteca()
                                    : panel == Panel.listasRep
                                        ? PanelListaRepCualquiera()
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
