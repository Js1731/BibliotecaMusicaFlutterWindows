import 'dart:io';

import 'package:biblioteca_musica/bloc/cubit_configuracion.dart';
import 'package:biblioteca_musica/bloc/cubit_modo_responsive.dart';
import 'package:biblioteca_musica/bloc/sincronizador/cubit_sincronizacion.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/bloc/sincronizador/sincronizacion.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/bloc_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columnas_sistema/bloc_columnas_sistema.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/bloc_listas_reproduccion.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/evento_listas_reproduccion.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/data_provider/dbp_canciones.dart';
import 'package:biblioteca_musica/data_provider/dbp_columnas.dart';
import 'package:biblioteca_musica/data_provider/dbp_listas_reproduccion.dart';
import 'package:biblioteca_musica/data_provider/reproductor.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/pantallas/pant_principal.dart';
import 'package:biblioteca_musica/repositorios/repositorio_canciones.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:biblioteca_musica/repositorios/repositorio_listas_reproduccion.dart';
import 'package:biblioteca_musica/repositorios/repositorio_reproductor.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/columnas_sistema/eventos_columnas_sistema.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await actNumeroVersionLocal(0);
  await initRutaDoc();

  final repositorioCanciones = RepositorioCanciones(DBPCanciones());
  final CubitConf cubitConfig = CubitConf();
  await cubitConfig.cargarConfig();

  runApp(
    MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => Sincronizador()),
          RepositoryProvider(
            create: (context) =>
                RepositorioListasReproduccion(DBPListasReproduccion()),
          ),
          RepositoryProvider(
            create: (context) => repositorioCanciones,
          ),
          RepositoryProvider(
            create: (context) => RepositorioColumnas(DBPColumnas()),
          ),
          RepositoryProvider(
              create: (context) =>
                  RepositorioReproductor(Reproductor(), repositorioCanciones))
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider(
              create: (context) => CubitModoResponsive(ModoResponsive.normal)),
          BlocProvider(create: (context) => cubitConfig),
          BlocProvider(
              create: (context) =>
                  CubitSincronizacion(context.read<Sincronizador>())),
          BlocProvider(create: (context) => BlocLog()),
          BlocProvider(create: (context) => CubitPanelSeleccionado()),
          BlocProvider(
              create: (context) =>
                  BlocColumnasSistema(context.read<RepositorioColumnas>())
                    ..add(EvEscucharColumnasSistema())),
          BlocProvider(
              create: (context_) => BlocListasReproduccion(
                  context_.read<RepositorioListasReproduccion>())
                ..add(PanelLateralEscucharStreamListasReproduccion())),
          BlocProvider(
              create: (context) =>
                  BlocReproductor(context.read<RepositorioReproductor>())
                    ..add(EvEscucharReproductor())),
          BlocProvider(
              create: (context) => BlocListaReproduccionSeleccionada(
                  context.read<RepositorioCanciones>(),
                  context.read<RepositorioColumnas>(),
                  context.read<RepositorioListasReproduccion>())
                ..add(EvIniciar())),
          BlocProvider(
              create: (context) =>
                  BlocColumnaSeleccionada(context.read<RepositorioColumnas>())),
        ], child: const MyApp())),
  );

  if (Platform.isWindows) {
    doWhenWindowReady(() {
      const initialSize = Size(1100, 700);
      appWindow.minSize = const Size(800, 700);
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'KOPI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PantPrincipal());
  }
}
