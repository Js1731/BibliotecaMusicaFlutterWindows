import 'package:biblioteca_musica/widgets/btn_color.dart';
import 'package:biblioteca_musica/widgets/form/txt_field.dart';
import 'package:flutter/material.dart';

import 'abrir_dialogo.dart';

///Abre un dialog para mostrar una entrada de texto
Future<String?> mostrarDialogoTexto(BuildContext context, String titulo,
    {String? txtIni}) async {
  String texto = txtIni ?? "";

  return mostrarDialogo<String?>(
      contenido: DialogoIngresarTexto(titulo, texto, context));
}

class DialogoIngresarTexto extends AlertDialog {
  DialogoIngresarTexto(String titulo, String texto, BuildContext context,
      {super.key})
      : super(
          title: Text(titulo),
          content: TextFieldCustom(texto, (nuevo) {
            texto = nuevo;
          }),
          actions: [
            //ACEPTAR
            BtnColor(
              texto: "Aceptar",
              w: 100,
              setcolor: SetColores.morado0,
              onPressed: (_) {
                Navigator.pop<String>(context, texto);
              },
            ),

            //CERRAR
            BtnColor(
                texto: "Cancelar",
                w: 100,
                setcolor: SetColores.morado1,
                onPressed: (_) {
                  Navigator.of(context).pop();
                })
          ],
        );
}
