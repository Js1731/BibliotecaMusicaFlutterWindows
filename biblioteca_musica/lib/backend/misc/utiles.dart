import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:flutter/material.dart';

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
String obtDuracionLista(List<CancionData> canciones) {
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

Color aumnetarBrillo(Color color, int cantidad) {
  int rojo = (color.red + cantidad).clamp(0, 255);
  int verde = (color.green + cantidad).clamp(0, 255);
  int azul = (color.blue + cantidad).clamp(0, 255);

  return Color.fromARGB(color.alpha, rojo, verde, azul);
}
