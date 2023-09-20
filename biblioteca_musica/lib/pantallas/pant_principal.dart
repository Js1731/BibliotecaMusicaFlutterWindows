import 'dart:io';

import 'package:biblioteca_musica/bloc/cubit_configuracion.dart';
import 'package:biblioteca_musica/bloc/cubit_gestor_columnas.dart';
import 'package:biblioteca_musica/bloc/cubit_modo_responsive.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/bloc/cubit_reproductor_movil.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/bloc/sincronizador/cubit_sincronizacion.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/pantallas/BarraVentana.dart';
import 'package:biblioteca_musica/pantallas/panel_ajustes/panel_ajustes.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas/auxiliar_panel_columnas.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas/panel_columnas_principal.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/auxiliar_panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/panel_lateral.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/panel_lista_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/panel_listas_movil/panel_listas_movil.dart';
import 'package:biblioteca_musica/pantallas/panel_log/panel_logs.dart';
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
  Widget construirPanelCentral(BuildContext context, Panel panel) {
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

    bool autoSincAct = context.read<CubitConf>().state.sincAuto;
    if (autoSincAct) {
      context.read<CubitConf>().activarSincAuto(
          context.read<BlocLog>(), context.read<CubitSincronizacion>());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final modoResp = constraints.maxWidth >= 1080
          ? ModoResponsive.normal
          : constraints.maxWidth < 1080 && constraints.maxWidth > 700
              ? ModoResponsive.reducido
              : ModoResponsive.muyReducido;

      context.read<CubitModoResponsive>().actModoResponsive(modoResp);

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
        body: BlocSelector<BlocReproductor, EstadoReproductor,
                CancionColumnaPrincipal?>(
            selector: (state) => state.cancionReproducida,
            builder: (context, cancionReproducida) {
              return SafeArea(
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
                                    create: (context) =>
                                        AuxiliarListasReproduccion(),
                                    child: const PanelLateral()),

                              //PANEL PANTALLA MOSTRADA EN LA PANTALLA CENTRAL

                              BlocSelector<
                                      BlocListaReproduccionSeleccionada,
                                      EstadoListaReproduccionSelecconada,
                                      ListaReproduccionData?>(
                                  selector: (state) =>
                                      state.listaReproduccionSeleccionada,
                                  builder: (context, listaSeleccionada) {
                                    return BlocBuilder<CubitPanelSeleccionado,
                                        Panel>(builder: (context, panel) {
                                      if (modoResp !=
                                              ModoResponsive.muyReducido &&
                                          panel == Panel.listasMovil) {
                                        context
                                            .read<CubitPanelSeleccionado>()
                                            .cambiarPanel(Panel.listasRep);
                                        context
                                            .read<
                                                BlocListaReproduccionSeleccionada>()
                                            .add(EvSeleccionarLista(
                                                listaRepBiblioteca));
                                      }

                                      return Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: modoResp ==
                                                      ModoResponsive.muyReducido
                                                  ? 10
                                                  : 0,
                                              top: 10,
                                              right: 10,
                                              bottom: 10),
                                          child: CustomPaint(
                                              key: ValueKey(panel),
                                              painter: CustomPainerPanelCentral(
                                                  modoResp),
                                              child: Stack(
                                                children: [
                                                  construirPanelCentral(
                                                      context, panel),
                                                ],
                                              )),
                                        ),
                                      );
                                    });
                                  }),
                            ]),
                          ),
                          BlocBuilder<CubitConf, EstadoConfig>(
                            builder: (context, config) {
                              return config.mostrarLog
                                  ? const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: PanelLog(),
                                    )
                                  : const SizedBox();
                            },
                          ),
                          if (modoResp == ModoResponsive.muyReducido &&
                              cancionReproducida != null)
                            const SizedBox(height: 60),
                          if (modoResp != ModoResponsive.muyReducido)
                            PanelReproductor()
                        ],
                      ),
                    ),
                    if (Platform.isWindows) const BarraVentana(),
                    if (modoResp == ModoResponsive.muyReducido &&
                        cancionReproducida != null)
                      Container(
                          margin: const EdgeInsets.only(
                              bottom: 10, right: 10, left: 10),
                          alignment: Alignment.bottomCenter,
                          child: BlocProvider(
                              create: (context) => CubitReproductorMovil(),
                              child: PanelReproductorMovil()))
                  ],
                ),
              );
            }),
      );
    });
  }
}
