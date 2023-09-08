import 'package:biblioteca_musica/bloc/cubit_gestor_columnas.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas/auxiliar_panel_columnas.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas/panel_columnas_principal.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/auxiliar_panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_logs.dart';
import 'package:biblioteca_musica/pantallas/reproductor/panel_reproductor.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../painters/custom_painter_panel_central.dart';

final GlobalKey<PantPrincipalState> keyPantPrincipal = GlobalKey();

class PantPrincipal extends StatefulWidget {
  PantPrincipal() : super(key: keyPantPrincipal);

  @override
  State createState() => PantPrincipalState();
}

class PantPrincipalState extends State<PantPrincipal>
    with SingleTickerProviderStateMixin {
  bool iniciado = false;

  Widget? construirPanelCentral(BuildContext context, Panel panel) {
    switch (panel) {
      case Panel.listasRep:
        return BlocProvider(
            create: (context) => CubitGestorColumnas(),
            child: Provider(
                create: (context) => AuxiliarListaReproduccion(
                      context.read<RepositorioColumnas>(),
                    ),
                child: const PanelListaReproduccion()));

      case Panel.columnas:
        return Provider(
            create: (context) => AuxiliarPanelColumnas(),
            child: const PanelColumnasPrincipal());
      default:
        return const SizedBox();
    }
  }

  @override
  void initState() {
    super.initState();
  }

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

                      BlocSelector<
                              BlocListaReproduccionSeleccionada,
                              EstadoListaReproduccionSelecconada,
                              ListaReproduccionData?>(
                          selector: (state) =>
                              state.listaReproduccionSeleccionada,
                          builder: (context, listaSeleccionada) {
                            return BlocBuilder<CubitPanelSeleccionado, Panel>(
                                builder: (context, panel) {
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, right: 10, bottom: 10),
                                  child: CustomPaint(
                                      key: ValueKey(panel),
                                      painter: CustomPainerPanelCentral(),
                                      child: construirPanelCentral(
                                          context, panel)),
                                ),
                              );
                            });
                          }),
                    ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: PanelLog(),
                  ),
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
    );
  }
}
