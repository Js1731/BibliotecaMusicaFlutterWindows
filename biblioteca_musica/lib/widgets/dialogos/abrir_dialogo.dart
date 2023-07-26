import 'package:biblioteca_musica/pantallas/pant_principal.dart';
import 'package:flutter/material.dart';

///Abre un dialog generico.
Future<T?> mostrarDialogo<T>({required Widget contenido}) {
  final context = keyPantPrincipal.currentContext!;
  return showDialog<T>(
      context: context,
      builder: (context) {
        return contenido;
      });
}

///Abre un dialog generico.
Future<T?> mostrarDialogoAlerta<T>(
    {required title,
    required content,
    puedeCerrar = true,
    required List<Widget> Function(BuildContext context) actions}) {
  final context = keyPantPrincipal.currentContext!;
  return showDialog<T>(
      context: context,
      barrierDismissible: puedeCerrar,
      builder: (context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: actions(context),
        );
      });
}
