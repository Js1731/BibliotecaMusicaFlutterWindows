import 'dart:convert';
import 'dart:io';

import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<String> crearURLServidor(String tipo, Map parametros) async {
  final String ipServidor = await obtIpServidor();
  String url = "http://$ipServidor:8080/?tipo=$tipo";

  for (var paramKey in parametros.keys) {
    url += "&$paramKey=${parametros[paramKey]}";
  }

  return url;
}

Future<String> obtIpServidor() async {
  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString("ipServidor") ?? "0.0.0.0";
}

Future<void> actIpServidor(String nuevaIP) async {
  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  await sharedPref.setString("ipServidor", nuevaIP);
}

Future<int> obtNumeroVersionLocal() async {
  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getInt("version") ?? 0;
}

Future<void> actNumeroVersionLocal(int nuevaVersion) async {
  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  await sharedPref.setInt("version", nuevaVersion);
}

Future<int> obtNumeroVersionServidor() async {
  Response respuesta = await Dio(BaseOptions(connectTimeout: timeout)).get(
      await crearURLServidor("conVersion", {}),
      options: Options(responseType: ResponseType.json));

  final dynamic ver = respuesta.data["version"];

  final int numeroVersion = ver is String ? int.parse(ver) : ver;

  return numeroVersion;
}

Future<void> actNumeroVersionServidor(int nuevaVersion) async {
  await Dio(BaseOptions(connectTimeout: timeout))
      .post(await crearURLServidor("actVersion", {"version": nuevaVersion}));
}

Future<void> borrarTablaServidor(String nombreTabla) async {
  await Dio(BaseOptions(connectTimeout: timeout))
      .post(await crearURLServidor("borrarTabla", {"tabla": nombreTabla}));
}

Future<void> borrarTablaLocal(String nombreTabla) async {
  await appDb.customStatement("DELETE FROM $nombreTabla");
}

Future<void> copiarTablaLocal(String tabla) async {
  var resultadoRaw =
      await Dio().get(await crearURLServidor("conTablaTodo", {"tabla": tabla}));

  var resultado = jsonDecode(resultadoRaw.data);

  var query = "INSERT INTO $tabla ";

  var columnas = "(";
  var values = "";

  if (resultado.isEmpty) {
    return;
  }

  ///OBTENER COLUMNAS DE LA TABLA
  var llaves = resultado[0].keys.toList();
  for (var e = 0; e < llaves.length; e++) {
    columnas += llaves[e];

    if (e < (llaves.length - 1)) {
      columnas += ",";
    }
  }

  columnas += ")";

  ///GENERAR VALORES PARA INSERTAR
  for (var i = 0; i < resultado.length; i++) {
    var fila = resultado[i];

    values += "(";

    for (var e = 0; e < llaves.length; e++) {
      var dato = fila[llaves[e]];

      if (dato is String) {
        values += "'${fila[llaves[e]]}'";
      } else {
        values += "${fila[llaves[e]]}";
      }

      if (e < llaves.length - 1) {
        values += ",";
      }
    }
    values += ")";

    if (i < resultado.length - 1) {
      values += ",";
    }
  }

  query = "INSERT INTO $tabla $columnas VALUES $values;";

  await appDb.customInsert(query);
}

Future<void> copiarTablaServidor(String tabla) async {
  var resultados = await appDb.customSelect("SELECT * FROM $tabla;").get();

  await Dio().post(await crearURLServidor("insertarDatos", {"tabla": tabla}),
      data: jsonEncode(resultados.map((fila) => fila.data).toList()),
      options: Options(contentType: Headers.jsonContentType));
}

Future<void> reemplazarDatosServidor() async {
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
    await copiarTablaServidor(nombreTabla);
  }
}

Future<void> reemplazarDatosLocal() async {
  for (String nombreTabla in [
    "cancion_lista_reproduccion",
    "lista_columnas",
    "lista_reproduccion",
    "cancion_valor_columna",
    "valor_columna",
    "columna",
    "cancion",
  ]) {
    await borrarTablaLocal(nombreTabla);
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
    await copiarTablaLocal(nombreTabla);
  }
}

(List, List) dividirListaTipo(List lst) {
  List<int> listaMP3 = lst
      .where(
        (element) => extension(element) == ".mp3",
      )
      .toList()
      .map<int>((e) => int.parse(basenameWithoutExtension(e)))
      .toList();

  List<int> listaJPG = lst
      .where(
        (element) => extension(element) == ".jpg",
      )
      .toList()
      .map<int>((e) => int.parse(basenameWithoutExtension(e)))
      .toList();

  return (listaMP3, listaJPG);
}

Future<(List, List)> obtArchivosServidor() async {
  var resultadosServidor =
      await Dio().get(await crearURLServidor("conArchivos", {}));
  return dividirListaTipo(resultadosServidor.data);
}

Future<(List, List)> obtArchivosLocal() async {
  var ruta = obtRutaDoc();
  var dir = Directory(ruta);
  var listaArchivosLocalRaw = dir.listSync();
  var listArchivosLocal =
      listaArchivosLocalRaw.map((e) => basename(e.path)).toList();
  return dividirListaTipo(listArchivosLocal);
}

Future<void> cambiarEstadoCancion(List<int> lstCanciones, int estado) async {
  appDb.update(appDb.cancion)
    ..where((tbl) => tbl.id.isIn(lstCanciones))
    ..write(CancionCompanion(estado: Value(estado)));
}

Future<void> cambiarEstadoImagen(List<int> lstImagenes, int estado) async {
  appDb.update(appDb.valorColumna)
    ..where((tbl) => tbl.id.isIn(lstImagenes))
    ..write(ValorColumnaCompanion(estado: Value(estado)));
}

Future<void> cancelarDescargaSubida() async {
  appDb.update(appDb.cancion)
    ..where((tbl) => tbl.estado.equals(estadoDescargando))
    ..write(const CancionCompanion(estado: Value(estadoServidor)));

  appDb.update(appDb.cancion)
    ..where((tbl) => tbl.estado.equals(estadoSubiendo))
    ..write(const CancionCompanion(estado: Value(estadoLocal)));

  appDb.update(appDb.valorColumna)
    ..where((tbl) => tbl.estado.equals(estadoDescargando))
    ..write(const ValorColumnaCompanion(estado: Value(estadoServidor)));

  appDb.update(appDb.valorColumna)
    ..where((tbl) => tbl.estado.equals(estadoSubiendo))
    ..write(const ValorColumnaCompanion(estado: Value(estadoLocal)));
}

Future<void> sincronizarLocalServidor() async {
  var (lstMP3Servidor, lstJPGServidor) = await obtArchivosServidor();

  //Borrar archivos del servidor

  //Obtener Canciones
  var resultadosCanciones = await Dio()
      .get(await crearURLServidor("conTablaTodo", {"tabla": "cancion"}));
  List<dynamic> lstCancionesRaw = jsonDecode(resultadosCanciones.data);
  List<int> lstIdCanciones = lstCancionesRaw.map<int>((e) => e["id"]).toList();

  var lstMP3Eliminar = lstMP3Servidor
      .toSet()
      .difference(lstIdCanciones.toSet())
      .map((e) => "$e.mp3")
      .toList();

  //Obtener Valores Columna
  var resultadosValoresColumna = await Dio()
      .get(await crearURLServidor("conTablaTodo", {"tabla": "valor_columna"}));
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

Future<void> sincronizarServidorLocal() async {
  var (lstMP3Local, lstJPGLocal) = await obtArchivosLocal();

  //Borrar archivos del servidor

  //Obtener Canciones
  var lstCanciones = await appDb.select(appDb.cancion).get();
  List<int> lstIdCanciones = lstCanciones.map<int>((e) => e.id).toList();

  var lstMP3Eliminar = lstMP3Local
      .toSet()
      .difference(lstIdCanciones.toSet())
      .map((e) => "$e.mp3")
      .toList();

  //Obtener Valores Columna
  var lstValoresColumna = await appDb.select(appDb.valorColumna).get();
  List<int> lstIdValorColumna =
      lstValoresColumna.map<int>((e) => e.id).toList();
  var lstJPGEliminar = lstJPGLocal
      .toSet()
      .difference(lstIdValorColumna.toSet())
      .map((e) => "$e.jpg")
      .toList();

  for (var archivo in [...lstMP3Eliminar, ...lstJPGEliminar]) {
    var file = File(rutaDoc(archivo));
    await file.delete();
  }

  var lstArchivosMP3Descargar =
      lstIdCanciones.toSet().difference(lstMP3Local.toSet()).toList();

  await cambiarEstadoCancion(lstArchivosMP3Descargar, estadoServidor);

  var lstArchivosJPGDescargar =
      lstIdValorColumna.toSet().difference(lstJPGLocal.toSet()).toList();

  await cambiarEstadoImagen(lstArchivosJPGDescargar, estadoServidor);
}

Future<void> subirArchivo(String nombreArchivoExtension) async {
  await Dio(BaseOptions(connectTimeout: timeout)).post(
      await crearURLServidor("subirArchivo", {}),
      data: FormData.fromMap({
        "file": await MultipartFile.fromFile(rutaDoc(nombreArchivoExtension),
            filename: nombreArchivoExtension)
      }));
}

Future<void> descargarArchivo(
    String nombreArchivoExtension, TipoArchivo tipo) async {
  String tp = tipo == TipoArchivo.texto
      ? "t"
      : tipo == TipoArchivo.musica
          ? "m"
          : tipo == TipoArchivo.imagen
              ? "i"
              : "";

  await Dio(BaseOptions(connectTimeout: timeout)).download(
    await crearURLServidor(
        "descargarArchivo", {"tipodato": tp, "nombre": nombreArchivoExtension}),
    rutaDoc(nombreArchivoExtension),
  );
}

Future<void> actualizarDatosLocales() async {
  final versionLocal = await obtNumeroVersionLocal();
  await actNumeroVersionLocal(versionLocal + 1);

  sincronizar();
}

Future<void> sincronizarArchivos() async {
  var lstCanciones = await appDb.select(appDb.cancion).get();

  for (var cancion in lstCanciones) {
    switch (cancion.estado) {
      case estadoLocal:
        //provBarraLog.texto("Sincronizando", "Subiendo ${cancion.id}.mp3");

        await cambiarEstadoCancion([cancion.id], estadoSubiendo);
        //await provGeneral.actualizarListaCanciones();

        await subirArchivo("${cancion.id}.mp3");
        //provBarraLog.texto("Sincronizando", "${cancion.id}.mp3 subido.");

        await cambiarEstadoCancion([cancion.id], estadoSync);
        //await provGeneral.actualizarListaCanciones();

        break;
      case estadoServidor:
        //provBarraLog.texto("Sincronizando", "Descargando ${cancion.id}.mp3");
        await cambiarEstadoCancion([cancion.id], estadoDescargando);

        //await provGeneral.actualizarListaCanciones();
        await descargarArchivo("${cancion.id}.mp3", TipoArchivo.musica);

        //provBarraLog.texto("Sincronizando", "${cancion.id}.mp3 descargando.");

        await cambiarEstadoCancion([cancion.id], estadoSync);
        //await provGeneral.actualizarListaCanciones();
        break;
    }
  }

  var lstImagenes = await appDb.select(appDb.valorColumna).get();

  for (var imagen in lstImagenes) {
    switch (imagen.estado) {
      case estadoLocal:
        try {
          //provBarraLog.texto("Sincronizando", "Subiendo ${imagen.id}.jpg.");
          await cambiarEstadoImagen([imagen.id], estadoSubiendo);
          //await provGeneral.actualizarListaCanciones();
          await subirArchivo("${imagen.id}.jpg");
          //provBarraLog.texto("Sincronizando", "${imagen.id}.jpg. subido.");
          await cambiarEstadoImagen([imagen.id], estadoSync);
          //await provGeneral.actualizarListaCanciones();
        } catch (e) {
          break;
        }

        break;
      case estadoServidor:
        try {
          //provBarraLog.texto("Sincronizando", "Descargando ${imagen.id}.jpg.");
          await cambiarEstadoImagen([imagen.id], estadoDescargando);
          //await provGeneral.actualizarListaCanciones();
          await descargarArchivo("${imagen.id}.jpg", TipoArchivo.musica);
          //provBarraLog.texto("Sincronizando", "${imagen.id}.jpg. descargado.");
          await cambiarEstadoImagen([imagen.id], estadoSync);
          //await provGeneral.actualizarListaCanciones();
        } catch (e) {
          break;
        }

        break;
    }
  }

  //provBarraLog.texto("Sincronizando", "Archivos Sincronizados.");
}

Future<void> sincronizar() async {
  try {
    //provBarraLog.cambiarEstadoSinc(false);

    await cancelarDescargaSubida();

    //provBarraLog.texto("Sincronizando", "Iniciando Sincronización...");
    int versionServidor = await obtNumeroVersionServidor();
    int versionLocal = await obtNumeroVersionLocal();

    if (versionLocal > versionServidor) {
      await reemplazarDatosServidor();
      await sincronizarLocalServidor();
      //await provGeneral.actualizarListaCanciones();
      await actNumeroVersionServidor(versionLocal);
    } else if (versionLocal < versionServidor) {
      await reemplazarDatosLocal();
      await sincronizarServidorLocal();
      //await provGeneral.actualizarListaCanciones();
      await actNumeroVersionLocal(versionServidor);
    }

    //provBarraLog.texto("Sincronizando", "Datos Sincronizados.");
    //provBarraLog.cambiarEstadoSinc(true);

    sincronizarArchivos();
  } catch (error) {
    if (error is DioException) {
      //provBarraLog.texto(
      //    "Error", "Hubo un error con la comunicación con el servidor.");
      return;
    } else {
      //provBarraLog.texto("Error", "Hubo un error durante la sincronización.");
      rethrow;
    }
  }
}
