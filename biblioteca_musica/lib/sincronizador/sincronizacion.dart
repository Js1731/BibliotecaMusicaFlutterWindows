import 'dart:async';
import 'dart:io';

import 'package:biblioteca_musica/bloc/logs/Log.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/logs/evento_bloc_log.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/sincronizador/sinc_servidor_local.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../misc/utiles.dart';
import 'sinc_local_servidor.dart';
import 'utils_sinc.dart';

const int estadoLocal = 0;
const int estadoSubiendo = 1;
const int estadoServidor = 2;
const int estadoDescargando = 3;
const int estadoSync = 4;

enum TipoArchivo { texto, musica, imagen }

const Duration timeout = Duration(milliseconds: 5000);

Future<void> enviarMDNS() async {
  final queryPacket = [
    // Transaction ID
    0x00, 0x00, // Set your own transaction ID here

    // Flags
    0x00, 0x00, // Standard query, no flags set

    // Question count
    0x00, 0x01, // 1 question

    // Answer count
    0x00, 0x00, // 0 answers

    // Authority count
    0x00, 0x00, // 0 authorities

    // Additional count
    0x00, 0x00, // 0 additionals

    // Query question
    // QNAME
    // _miserv
    0x07, 0x5f, 0x6d, 0x69, 0x73, 0x65, 0x72, 0x76,
    // _tcp
    0x04, 0x5f, 0x74, 0x63, 0x70,
    // local
    0x05, 0x6c, 0x6f, 0x63, 0x61, 0x6c,
    // null terminator
    0x00,

    // QTYPE
    0x00, 0x01, // A record type

    // QCLASS
    0x00, 0x01, // IN class
  ];

  RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
    socket.send(queryPacket, InternetAddress('224.0.0.251'), 5353);
    socket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        print('Received mDNS response:');
        final datagram = socket.receive();
        if (datagram != null) {
          final responsePacket = datagram.data;
          // Process the mDNS response packet here
          print('Received mDNS response: ${responsePacket.toList()}');
        }
      }
    }, onDone: () {
      print("SNO");
    });
  });
}

Future<void> actNumeroVersionServidor(int nuevaVersion) async {
  await Dio(BaseOptions(connectTimeout: timeout))
      .post(await crearURLServidor("actVersion", {"version": nuevaVersion}));
}

Future<void> sincronizarArchivos(BlocLog blocLog) async {
  var lstCanciones = await appDb.select(appDb.cancion).get();

  for (var cancion in lstCanciones) {
    switch (cancion.estado) {
      case estadoLocal:
        blocLog.add(EvAgregarLog(Log(
            const Icon(Icons.upload, color: DecoColores.gris),
            "Sincronizando Musica",
            "Subiendo ${cancion.nombre}.mp3...")));

        await cambiarEstadoCancion([cancion.id], estadoSubiendo);

        await subirArchivo("${cancion.id}.mp3");
        blocLog.add(EvAgregarLog(Log(
            const Icon(Icons.check_circle_rounded, color: Colors.green),
            "Sincronizando Musica",
            "${cancion.nombre}.mp3 subido.")));

        await cambiarEstadoCancion([cancion.id], estadoSync);

        break;
      case estadoServidor:
        blocLog.add(EvAgregarLog(Log(
            const Icon(Icons.download, color: DecoColores.gris),
            "Sincronizando Musica",
            "Descargando ${cancion.nombre}.mp3...")));
        await cambiarEstadoCancion([cancion.id], estadoDescargando);

        await descargarArchivo("${cancion.id}.mp3", TipoArchivo.musica);
        blocLog.add(EvAgregarLog(Log(
            const Icon(Icons.check_circle_rounded, color: Colors.green),
            "Sincronizando Musica",
            "${cancion.nombre}.mp3 Descargado.")));

        await cambiarEstadoCancion([cancion.id], estadoSync);
        break;
    }
  }

  var lstImagenes = await appDb.select(appDb.valorColumna).get();

  for (var imagen in lstImagenes) {
    switch (imagen.estado) {
      case estadoLocal:
        try {
          blocLog.add(EvAgregarLog(Log(
              const Icon(Icons.upload, color: DecoColores.gris),
              "Sincronizando Portada",
              "Subiendo portada de ${imagen.nombre}...")));
          await cambiarEstadoImagen([imagen.id], estadoSubiendo);

          await subirArchivo("${imagen.id}.jpg");

          blocLog.add(EvAgregarLog(Log(
              const Icon(Icons.check_circle_rounded, color: Colors.green),
              "Sincronizando Portada",
              "Portada de ${imagen.nombre} Subida.")));
          await cambiarEstadoImagen([imagen.id], estadoSync);
        } catch (e) {
          break;
        }

        break;
      case estadoServidor:
        try {
          blocLog.add(EvAgregarLog(Log(
              const Icon(Icons.download, color: DecoColores.gris),
              "Sincronizando Portadas",
              "Descargando portada de ${imagen.nombre}...")));
          await cambiarEstadoImagen([imagen.id], estadoDescargando);

          await descargarArchivo("${imagen.id}.jpg", TipoArchivo.imagen);

          blocLog.add(EvAgregarLog(Log(
              const Icon(Icons.check_circle_rounded, color: Colors.green),
              "Sincronizando Portadas",
              "Portada de ${imagen.nombre} Descargada.")));
          await cambiarEstadoImagen([imagen.id], estadoSync);
        } catch (e) {
          break;
        }

        break;
    }
  }
  blocLog.add(EvAgregarLog(Log(
      const Icon(Icons.check_circle_rounded, color: Colors.green),
      "Archivos Sincronizados",
      "Los Archivos fueron sincronizados con exito.")));
}

Future<void> _buscarServidor(BlocLog blocLog) async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8081);

  enviarMDNS();

  try {
    final request =
        await server.firstWhere((HttpRequest request) => true).timeout(
              const Duration(seconds: 5),
            );

    await actIpServidor(request.connectionInfo!.remoteAddress.address);
    blocLog.add(EvAgregarLog(Log(
        const Icon(Icons.check_circle_rounded, color: Colors.green),
        "Servidor Encontrado",
        "Se encontro un servidor en ${await obtIpServidor()}")));
  } on TimeoutException {
    blocLog.add(EvAgregarLog(Log(
        const Icon(Icons.highlight_remove_rounded, color: Colors.red),
        "Servidor no encontrado",
        "El tiempo limite de busqueda se ha superado.")));

    throw const HttpException("Servidor no encontrado");
  }
}

Future<void> sincronizar(BlocLog blocLog) async {
  try {
    await cancelarDescargaSubida();
    blocLog.add(EvAgregarLog(Log(
        const Icon(Icons.sync, color: Deco.cGray),
        "Iniciando Sincronizacion",
        "Iniciando sincronizacion de datos con el servidor.")));

    blocLog.add(EvAgregarLog(
        Log(null, "Buscando Servidor", "Buscando un servidor en la red...")));

    await _buscarServidor(blocLog);

    int versionServidor = await obtNumeroVersionServidor();
    int versionLocal = await obtNumeroVersionLocal();

    if (versionLocal > versionServidor) {
      blocLog.add(EvAgregarLog(Log(null, "Sincronizando",
          "El cliente tiene datos mas recientes, sincronizando Servidor con Local")));

      await SincronizadorServidorConLocal(blocLog).sincronizar();
    } else if (versionLocal < versionServidor) {
      blocLog.add(EvAgregarLog(Log(null, "Sincronizando",
          "El Servidor tiene datos mas recientes, sincronizando Local con Servidor")));

      await SincronizadorLocalConServidor(blocLog).sincronizar();
    }
    blocLog.add(EvAgregarLog(Log(
        const Icon(Icons.check_circle_rounded, color: Colors.green),
        "Datos Sincronizados",
        "Los datos fueron sincronizados con exito.")));

    blocLog.add(EvAgregarLog(Log(
        const Icon(Icons.sync, color: Deco.cGray),
        "Sincronizar Archivos",
        "Iniciando sincronizacion de archivos Locales y Remotos.")));

    sincronizarArchivos(blocLog);
  } catch (error) {
    if (error is HttpException) {
      blocLog.add(EvAgregarLog(Log(
          const Icon(Icons.highlight_remove_rounded, color: Colors.red),
          "Error Sincronizando",
          "No se pudo encontrar el servidor.")));

      return;
    } else {
      //provBarraLog.texto("Error", "Hubo un error durante la sincronización.");
      rethrow;
    }
  }
}
