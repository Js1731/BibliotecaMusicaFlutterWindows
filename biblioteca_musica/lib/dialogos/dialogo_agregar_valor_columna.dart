import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../backend/datos/AppDb.dart';
import 'dialogo_valor_columna.dart';

Future<void> abrirDialogoAgregarValorColumna(
    BuildContext context, ColumnaData columna,
    {ValorColumnaData? valorColIni}) async {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: DialogoValorColumna(columna, valorColIni: valorColIni),
          ));
}
