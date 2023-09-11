import 'dart:async';
import 'dart:io';

import 'package:biblioteca_musica/bloc/logs/Log.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/logs/evento_bloc_log.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/bloc/sincronizador/sinc_servidor_local.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';

import '../../misc/utiles.dart';
import 'sinc_local_servidor.dart';
import 'utils_sinc.dart';

const int estadoLocal = 0;
const int estadoSubiendo = 1;
const int estadoServidor = 2;
const int estadoDescargando = 3;
const int estadoSync = 4;

enum TipoArchivo { texto, musica, imagen }

class Sincronizador {
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
                const Duration(seconds: 3),
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
    } finally {
      await server.close();
    }
  }

  Future<bool> sincronizar(BlocLog blocLog) async {
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

      return true;
    } catch (error) {
      if (error is HttpException) {
        blocLog.add(EvAgregarLog(Log(
            const Icon(Icons.highlight_remove_rounded, color: Colors.red),
            "Error Sincronizando",
            "No se pudo encontrar el servidor.")));

        return false;
      } else {
        rethrow;
      }
    }
  }
}
