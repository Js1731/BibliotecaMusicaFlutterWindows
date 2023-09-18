import 'package:biblioteca_musica/bloc/cubit_gestor_columnas.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/bloc/cubit_reproductor_movil.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/pantallas/panel_ajustes/panel_ajustes.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas/auxiliar_panel_columnas.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas/panel_columnas_principal.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/auxiliar_panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_listas_movil/panel_listas_movil.dart';
import 'package:biblioteca_musica/pantallas/panel_logs.dart';
import 'package:biblioteca_musica/pantallas/panel_reproductor_movil/panel_reproductor_movil.dart';
import 'package:biblioteca_musica/pantallas/reproductor/panel_reproductor.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
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

  Widget construirPanelCentral(
      BuildContext context, Panel panel, ModoResponsive modo) {
    switch (panel) {
      case Panel.listasRep:
        return BlocProvider(
            create: (context) => CubitGestorColumnas(),
            child: Provider(
                create: (context) => AuxiliarListaReproduccion(
                      context.read<RepositorioColumnas>(),
                    ),
                child: PanelListaReproduccion(
                  modoResponsive: modo,
                )));

      case Panel.columnas:
        return Provider(
            create: (context) => AuxiliarPanelColumnas(),
            child: const PanelColumnasPrincipal());

      case Panel.ajustes:
        return const PanelAjustes();

      case Panel.listasMovil:
        return const PanelListasMovil();

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
    return LayoutBuilder(builder: (context, constraints) {
      final modoResp = constraints.maxWidth >= 1000
          ? ModoResponsive.normal
          : constraints.maxWidth < 1000 && constraints.maxWidth > 700
              ? ModoResponsive.reducido
              : ModoResponsive.muyReducido;

      print(modoResp.name);
      return Scaffold(
        bottomNavigationBar: modoResp == ModoResponsive.muyReducido
            ? BlocBuilder<CubitPanelSeleccionado, Panel>(
                builder: (context, panelSel) {
                return NavigationBar(
                  selectedIndex: panelSel.index,
                  indicatorColor: DecoColores.rosaClaro2,
                  destinations: const [
                    NavigationDestination(
                        icon: Icon(Icons.music_note_rounded), label: "Musica"),
                    NavigationDestination(
                        icon: Icon(Icons.list), label: "Listas"),
                    NavigationDestination(
                        icon: Icon(Icons.settings), label: "Ajustes")
                  ],
                  onDestinationSelected: (indexSel) {
                    context
                        .read<CubitPanelSeleccionado>()
                        .cambiarPanel(Panel.values[indexSel]);
                  },
                );
              })
            : null,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                color: DecoColores.gris,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(children: [
                        if (modoResp != ModoResponsive.muyReducido)
                          Provider(
                              create: (context) => AuxiliarListasReproduccion(),
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
                                if (modoResp != ModoResponsive.muyReducido &&
                                    panel == Panel.listasMovil) {
                                  context
                                      .read<CubitPanelSeleccionado>()
                                      .cambiarPanel(Panel.listasRep);
                                  context
                                      .read<BlocListaReproduccionSeleccionada>()
                                      .add(EvSeleccionarLista(
                                          listaRepBiblioteca));
                                }

                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, right: 10, bottom: 10),
                                    child: CustomPaint(
                                        key: ValueKey(panel),
                                        painter: CustomPainerPanelCentral(),
                                        child: Stack(
                                          children: [
                                            construirPanelCentral(
                                                context, panel, modoResp),
                                          ],
                                        )),
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
                    if (modoResp == ModoResponsive.muyReducido)
                      const SizedBox(height: 60),
                    if (modoResp != ModoResponsive.muyReducido)
                      PanelReproductor(modo: modoResp)
                  ],
                ),
              ),
              //if (Platform.isWindows) const BarraVentana()
              if (modoResp == ModoResponsive.muyReducido)
                Container(
                    margin:
                        const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                    alignment: Alignment.bottomCenter,
                    child: BlocProvider(
                        create: (context) => CubitReproductorMovil(),
                        child: PanelReproductorMovil())),
            ],
          ),
        ),
      );
    });
  }
}
