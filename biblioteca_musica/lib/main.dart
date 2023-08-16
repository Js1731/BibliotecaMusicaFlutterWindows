import 'dart:io';

import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/backend/providers/provider_lista_rep.dart';
import 'package:biblioteca_musica/backend/providers/provider_log.dart';
import 'package:biblioteca_musica/backend/providers/provider_reproductor.dart';
import 'package:biblioteca_musica/bloc/bloc_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/cubit_columnas.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
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

Future<void> iniciarServidor() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8081);

  await server.forEach((HttpRequest request) async {
    provBarraLog.texto("Servidor",
        "Servidor encontrado en ${request.connectionInfo!.remoteAddress.address}");
    await actIpServidor(request.connectionInfo!.remoteAddress.address);
  });
}

ProviderListaReproduccion provListaRep = ProviderListaReproduccion();
ProviderReproductor provReproductor =
    ProviderReproductor(providerGeneral: provGeneral);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  actNumeroVersionLocal(0);
  await initRutaDoc();
  enviarMDNS();
  iniciarServidor();

  sincronizar();

  runApp(
    MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) =>
                RepositorioListasReproduccion(DBPListasReproduccion()),
          ),
          RepositoryProvider(
            create: (context) => RepositorioCanciones(DBPCanciones()),
          ),
          RepositoryProvider(
            create: (context) => RepositorioColumnas(DBPColumnas()),
          ),
          RepositoryProvider(
              create: (context) => RepositorioReproductor(Reproductor()))
        ],
        child: MultiBlocProvider(providers: [
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
                ..add(EvSeleccionarLista(listaRepBiblioteca)))
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
      home: PantPrincipal(),
    );
  }
}
