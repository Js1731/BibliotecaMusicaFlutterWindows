import 'dart:io';

import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/backend/providers/provider_lista_rep.dart';
import 'package:biblioteca_musica/backend/providers/provider_log.dart';
import 'package:biblioteca_musica/backend/providers/provider_reproductor.dart';
import 'package:biblioteca_musica/pantallas/pant_principal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => provListaRep),
    ChangeNotifierProvider(create: (_) => provGeneral),
    ChangeNotifierProvider(create: (_) => provReproductor)
  ], child: const MyApp()));
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
