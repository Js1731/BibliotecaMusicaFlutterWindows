import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

late String _rutadoc;

String rutaCan(int id) => rutaDoc("$id.mp3");

String? rutaImagen(int id) {
  final ruta = rutaDoc("$id.jpg");
  if (!File(ruta).existsSync()) return null;
  return ruta;
}

String obtRutaDoc() => _rutadoc;

Future<void> initRutaDoc() async {
  Directory directorio = await getApplicationDocumentsDirectory();
  _rutadoc = '${directorio.path}/LibMusica/';
  await Directory(_rutadoc).create(recursive: true);
}

///Devuelve la ruta de archivo en el directorio de trabajo local
///
///El nombre debe tener la extension anexada.
String rutaDoc(String nombreArchivoExtension) {
  return "$_rutadoc$nombreArchivoExtension";
}

Future<File> abrirArchivo(String nombreArchivo) async {
  File archivo = File(rutaDoc(nombreArchivo));

  //SI NO EXITE CREAR EL ARCHIVO
  if (!archivo.existsSync()) {
    await archivo.create(recursive: true);
  }

  return archivo;
}

///Copia un archivo a la carpeta de trabajo. Devuelve la ruta al archivo en la carpeta de trabajo.
Future<String> copiarArchivo(
    String rutaOriginal, String nombreDestinoExtension) async {
  String ruta = await rutaDoc(nombreDestinoExtension);
  await File(rutaOriginal).copy(ruta);

  return ruta;
}

//

///Carga datos del archivo indicado a una lista
Future<List<T>?> cargarDatosInd<T>(
    String nombre, Function(dynamic) func) async {
  File archivo = await abrirArchivo(nombre);
  String txt = await archivo.readAsString();

  if (txt == "") {
    return null;
  }

  //EJECUTA LA FUNCION func POR CADA ELEMENTO DEL ARCHIVO CARGADO
  List<T> l = List<T>.from((json.decode(txt)).map(func));

  return l;
}

Future<void> eliminarArchivo(String nombre) async {
  String url = rutaDoc(nombre);
  File file = File(url);
  await file.delete();
}

Future<void> borrarTodo() async {
  Directory directory = Directory(_rutadoc);
  final List<FileSystemEntity> entities = await directory.list().toList();
  final Iterable<File> files = entities.whereType<File>();

  for (File file in files) {
    await file.delete();
  }
}
