import 'package:biblioteca_musica/datos/cancion_columnas.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ModoResponsive { normal, reducido, muyReducido }

String duracionString(Duration dur) {
  var min = dur.inMinutes;
  var sec = dur.inSeconds - min * 60;

  String strMin = min <= 9 ? "0$min" : min.toString();
  String strSec = sec <= 9 ? "0$sec" : sec.toString();

  return "$strMin:$strSec";
}

String duracionHorasString(Duration dur) {
  var horas = dur.inHours;
  var min = dur.inMinutes - horas * 60;
  var sec = dur.inSeconds - horas * 60 * 60 - min * 60;

  String strHoras = horas.toString();
  String strMin = min <= 9 ? "0$min" : min.toString();
  String strSec = sec <= 9 ? "0$sec" : sec.toString();

  return "${strHoras}h ${strMin}m ${strSec}s";
}

//Obtiene cuanto tiempo dura reproducir todas las canciones en la base de datos
String obtDuracionLista(List<CancionColumnas> canciones) {
  return duracionHorasString((Duration(
      seconds: canciones.fold<int>(
          0, (anterior, siguiente) => anterior + siguiente.duracion))));
}

//Une dos listas y regresa la primera lista.
List<Widget> unirListas<T>(List<Widget> lista1, List<Widget> lista2) {
  lista1.addAll(lista2);
  return lista1;
}

Future<T?> mostrarMenuContextual<T>(BuildContext context, Offset clickPosition,
    List<PopupMenuEntry<T>> items) async {
  final RenderBox rendBox =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  return await showMenu<T>(
      context: context,
      position: RelativeRect.fromRect(
          Rect.fromPoints(clickPosition, clickPosition),
          Offset.zero & rendBox.size),
      items: items);
}

String removerEspaciosDobles(String input) {
  return input.replaceAll(RegExp(' {2,}'), ' ');
}

String removerDigitos(String input) {
  return input.replaceAll(RegExp(r'\d'), '');
}

Color aumnetarBrillo(Color color, double fact) {
  int rojo = (color.red + (color.red * fact).round()).clamp(0, 255);
  int verde = (color.green + (color.green * fact).round()).clamp(0, 255);
  int azul = (color.blue + (color.blue * fact).round()).clamp(0, 255);

  return Color.fromARGB(color.alpha, rojo, verde, azul);
}

Future<String> genUrlParams(String ruta, Map params) async =>
    "${await genUrlNoParams(ruta)}?${params.keys.map<String>((key) => "$key=${params[key]}").toList().join("&")}";

Future<String> genUrlParamUnico(String ruta, String param) async =>
    "${await genUrlNoParams(ruta)}/$param";

Future<String> genUrlNoParams(String ruta) async =>
    "http://${await _obtIpServidor()}:8080/$ruta";

Future<String?> _obtIpServidor() async {
  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  return sharedPref.getString("ipServidor");
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
  Response respuesta = await Dio().get(
      await genUrlNoParams("version/consultar"),
      options: Options(responseType: ResponseType.json));

  final dynamic ver = respuesta.data["version"];

  final int numeroVersion = ver is String ? int.parse(ver) : ver;

  return numeroVersion;
}

Future<void> actNumeroVersionServidor(int nuevaVersion) async {
  await Dio().post(
      await genUrlParams("version/actualizar", {"version": nuevaVersion}));
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

Future<void> actUltimaListaRep(int idListaRep) async {
  final shr = await SharedPreferences.getInstance();
  shr.setInt("ultimaLista", idListaRep);
}

Future<int?> obtUltimaListaRep() async {
  final shr = await SharedPreferences.getInstance();
  return shr.getInt("ultimaLista");
}

enum OrdenBiblioteca { porNombre, porDuracion }

Future<void> actOrdenBiblioteca(OrdenBiblioteca orden) async {
  final shr = await SharedPreferences.getInstance();

  OrdenBiblioteca ordenBiblioteca =
      OrdenBiblioteca.values[shr.getInt("ordenBiblioteca") ?? 0];
  bool ascend = shr.getBool("ordenBibliotecaAsc") ?? true;

  shr.setInt("ordenBiblioteca", orden.index);

  if (ordenBiblioteca == orden) {
    shr.setBool("ordenBibliotecaAsc", !ascend);
  }
}

Future<OrdenBiblioteca> obtOrdenBiblioteca() async {
  final shr = await SharedPreferences.getInstance();
  return OrdenBiblioteca.values[shr.getInt("ordenBiblioteca") ?? 0];
}

Future<bool> obtAcendOrdenBiblioteca() async {
  final shr = await SharedPreferences.getInstance();
  return shr.getBool("ordenBibliotecaAsc") ?? true;
}
