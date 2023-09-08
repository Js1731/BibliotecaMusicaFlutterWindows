// import 'package:biblioteca_musica/backend/misc/archivos.dart';
// import 'package:biblioteca_musica/backend/misc/configuracion.dart';
// import 'package:dio/dio.dart';
// import 'package:path/path.dart';

// enum TipoArchivo { texto, musica, imagen }

// int timeout = 1000;

// Future<void> subirArchivo(String nombreArchivoExtension) async {
//   await Dio(BaseOptions(connectTimeout: timeout)).post(
//       'http://${configIP}:8080/?tipo=subirarchivo',
//       data: FormData.fromMap({
//         "file": await MultipartFile.fromFile(rutaDoc(nombreArchivoExtension),
//             filename: nombreArchivoExtension)
//       }));
// }

// Future<void> descargarArchivo(
//     String nombreArchivoExtension, TipoArchivo tipo) async {
//   String tp = tipo == TipoArchivo.texto
//       ? "t"
//       : tipo == TipoArchivo.musica
//           ? "m"
//           : tipo == TipoArchivo.imagen
//               ? "i"
//               : "";

//   await Dio(BaseOptions(connectTimeout: timeout)).download(
//       'http://${configIP}:8080/?tipo=descargararchivo&nom=$nombreArchivoExtension&tipodato=$tp',
//       rutaDoc(nombreArchivoExtension));
// }

// Future<void> descargarArchivoRenombrar(String nombreArchivoExtension,
//     String nombreNuevoExtension, TipoArchivo tipo) async {
//   String tp = tipo == TipoArchivo.texto
//       ? "t"
//       : tipo == TipoArchivo.musica
//           ? "m"
//           : tipo == TipoArchivo.imagen
//               ? "i"
//               : "";

//   await Dio(BaseOptions(connectTimeout: timeout)).download(
//       'http://${configIP}:8080/?tipo=descargararchivo&nom=$nombreArchivoExtension&tipodato=$tp',
//       rutaDoc(nombreNuevoExtension));
// }

// Future<void> borrarArchivoServidor(String nombreArchivoExtension) async {
//   await Dio(BaseOptions(connectTimeout: timeout)).post(
//       'http://${configIP}:8080/?tipo=borrararchivo&nom=$nombreArchivoExtension');
// }

// ///Consulta al servidor la fecha de la ultima actualizacion que se le hizo
// Future<DateTime?> consultarUltimaActualizacion() async {
//   Response respuesta = await Dio(BaseOptions(connectTimeout: timeout)).get(
//       'http://${configIP}:8080/?tipo=ultimaact',
//       options: Options(responseType: ResponseType.json));
//   String datos = respuesta.data['fecha'];

//   if (datos == "") {
//     return null;
//   }

//   return DateTime.parse(datos);
// }

// Future<void> actualizarFechaServidor(String fecha) async {
//   await Dio(BaseOptions(connectTimeout: timeout))
//       .post("http://${configIP}:8080/?tipo=actfecha&fecha=${fecha}");
// }
