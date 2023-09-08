import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/dialogos/dialogo_valor_columna.dart';
import 'package:flutter/material.dart';

Future<void> abrirDialogoEditarValorColumna(BuildContext context,
    ColumnaData columna, ValorColumnaData valorColumna) async {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: DialogoValorColumna(columna, valorColIni: valorColumna),
          ));
}
