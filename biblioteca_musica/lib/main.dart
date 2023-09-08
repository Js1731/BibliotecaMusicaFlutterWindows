import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/sincronizador/sincronizacion.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/bloc_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columnas_sistema/bloc_columnas_sistema.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/evento_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/data/dbp_canciones.dart';
import 'package:biblioteca_musica/data/dbp_columnas.dart';
import 'package:biblioteca_musica/data/dbp_listas_reproduccion.dart';
import 'package:biblioteca_musica/data/reproductor.dart';
import 'package:biblioteca_musica/pantallas/pant_principal.dart';
import 'package:biblioteca_musica/repositorios/repositorio_canciones.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:biblioteca_musica/repositorios/repositorio_listas_reproduccion.dart';
import 'package:biblioteca_musica/repositorios/repositorio_reproductor.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/columnas_sistema/eventos_columnas_sistema.dart';
import 'misc/utiles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //actNumeroVersionLocal(0);
  await initRutaDoc();

  final repositorioCanciones = RepositorioCanciones(DBPCanciones());

  runApp(
    MultiRepositoryProvider(
        providers: [
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
          BlocProvider(create: (context) => BlocLog()),
          BlocProvider(create: (context) => CubitPanelSeleccionado()),
          BlocProvider(
              create: (context) =>
                  BlocColumnasSistema(context.read<RepositorioColumnas>())
                    ..add(EvEscucharColumnasSistema())),
          BlocProvider(
              create: (context_) => BlocPanelLateral(
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
                ..add(EvSeleccionarLista(listaRepBiblioteca))),
          BlocProvider(
              create: (context) =>
                  BlocColumnaSeleccionada(context.read<RepositorioColumnas>())),
        ], child: const MyApp())),
  );

  doWhenWindowReady(() {
    const initialSize = Size(1024, 700);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: sincronizar(context.read<BlocLog>()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return PantPrincipal();
            } else {
              return const Center(
                child: Text("Sincronizando..."),
              );
            }
          }),
    );
  }
}
