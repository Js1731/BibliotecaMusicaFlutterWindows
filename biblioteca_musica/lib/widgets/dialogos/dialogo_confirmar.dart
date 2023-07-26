import 'package:biblioteca_musica/widgets/btn_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'abrir_dialogo.dart';

Future<bool?> mostrarDialogoConfirmar(
    BuildContext context, String titulo, String desc) {
  return mostrarDialogo<bool?>(
      contenido: DialogoConfirmar(titulo, desc, context));
}

class DialogoConfirmar extends AlertDialog {
  DialogoConfirmar(String titulo, String desc, BuildContext context,
      {super.key})
      : super(
          title: Text(titulo,
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          content:
              SizedBox.fromSize(size: const Size(200, 100), child: Text(desc)),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BtnColor(
                    setcolor: SetColores.morado0,
                    texto: "Aceptar",
                    onPressed: (_) {
                      Navigator.pop<bool?>(context, true);
                    }),
                SizedBox.fromSize(size: const Size(10, 0)),
                BtnColor(
                    setcolor: SetColores.morado2,
                    texto: "Cancelar",
                    onPressed: (_) {
                      Navigator.pop(context);
                    })
              ],
            )
          ],
        );
}
