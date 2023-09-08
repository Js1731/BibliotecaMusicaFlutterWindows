import 'dart:convert';

import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../bloc/logs/Log.dart';
import '../bloc/logs/evento_bloc_log.dart';
import '../datos/AppDb.dart';
import '../misc/archivos.dart';
import '../misc/utiles.dart';
import 'sincronizacion.dart';
import 'utils_sinc.dart';

class SincronizadorServidorConLocal {
  final BlocLog blocLog;

  SincronizadorServidorConLocal(this.blocLog);

  Future<void> sincronizar() async {
    blocLog.add(EvAgregarLog(Log(
        null, "Actualizando Servidor", "Subiendo datos locales a servidor.")));
    await reemplazarDatosServidorConLocal();

    blocLog.add(EvAgregarLog(Log(null, "Actualizando Servidor",
        "Sincronizando el estado de los archivos del servidor con los locales.")));
    await sincronizarEstadoServidorConLocal();
    await actNumeroVersionServidor(await obtNumeroVersionLocal());

    blocLog.add(EvAgregarLog(Log(
        const Icon(Icons.check_circle_rounded, color: Colors.green),
        "Servidor Actualizado",
        "Los datos del servidor estan actualizados.")));
  }

  Future<void> copiarTablaLocalAServidor(String tabla) async {
    var resultados = await appDb.customSelect("SELECT * FROM $tabla;").get();

    await Dio().post(await crearURLServidor("insertarDatos", {"tabla": tabla}),
        data: jsonEncode(resultados.map((fila) => fila.data).toList()),
        options: Options(contentType: Headers.jsonContentType));
  }

  Future<void> borrarTablaServidor(String nombreTabla) async {
    await Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)))
        .post(await crearURLServidor("borrarTabla", {"tabla": nombreTabla}));
  }

  Future<void> reemplazarDatosServidorConLocal() async {
    for (String nombreTabla in [
      "cancion_lista_reproduccion",
      "lista_columnas",
      "lista_reproduccion",
      "cancion_valor_columna",
      "valor_columna",
      "columna",
      "cancion",
    ]) {
      await borrarTablaServidor(nombreTabla);
    }

    for (String nombreTabla in [
      "cancion",
      "columna",
      "valor_columna",
      "cancion_valor_columna",
      "lista_reproduccion",
      "lista_columnas",
      "cancion_lista_reproduccion",
    ]) {
      await copiarTablaLocalAServidor(nombreTabla);
    }
  }

  Future<void> sincronizarEstadoServidorConLocal() async {
    var (lstMP3Servidor, lstJPGServidor) = await obtArchivosServidor();

    //Borrar archivos del servidor

    //Obtener Canciones
    var resultadosCanciones = await Dio()
        .get(await crearURLServidor("conTablaTodo", {"tabla": "cancion"}));
    List<dynamic> lstCancionesRaw = jsonDecode(resultadosCanciones.data);
    List<int> lstIdCanciones =
        lstCancionesRaw.map<int>((e) => e["id"]).toList();

    var lstMP3Eliminar = lstMP3Servidor
        .toSet()
        .difference(lstIdCanciones.toSet())
        .map((e) => "$e.mp3")
        .toList();

    //Obtener Valores Columna
    var resultadosValoresColumna = await Dio().get(
        await crearURLServidor("conTablaTodo", {"tabla": "valor_columna"}));
    List<dynamic> lstValoresColumnaRaw =
        jsonDecode(resultadosValoresColumna.data);
    List<int> lstValoresColumna =
        lstValoresColumnaRaw.map<int>((e) => e["id"]).toList();

    var lstJPGEliminar = lstJPGServidor
        .toSet()
        .difference(lstValoresColumna.toSet())
        .map((e) => "$e.jpg")
        .toList();

    await Dio().post(await crearURLServidor("borrarArchivos", {
      "archivos": [...lstMP3Eliminar, ...lstJPGEliminar].join(",")
    }));

    var lstArchivosMP3Subir =
        lstIdCanciones.toSet().difference(lstMP3Servidor.toSet()).toList();

    await cambiarEstadoCancion(lstArchivosMP3Subir, estadoLocal);

    var lstArchivosJPGSubir =
        lstValoresColumna.toSet().difference(lstJPGServidor.toSet()).toList();

    await cambiarEstadoImagen(lstArchivosJPGSubir, estadoLocal);
  }
}
