import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/dialogos/contenido_agregar_valor_columna.dart';
import 'package:biblioteca_musica/dialogos/dialogo_generico.dart';
import 'package:biblioteca_musica/painters/custom_painter_dialogo.dart';
import 'package:flutter/material.dart';

Future<void> abrirDialogoAgregarValorColumna(
    BuildContext context, ColumnaData columna,
    {ValorColumnaData? valorColIni}) async {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child:
                DialogoAgregarValorColumna(columna, valorColIni: valorColIni),
          ));
}

class DialogoAgregarValorColumna extends DialogoGenerico {
  final ColumnaData columna;
  final ValorColumnaData? valorColIni;
  DialogoAgregarValorColumna(this.columna, {this.valorColIni, super.key})
      : super(
            ancho: 300,
            altura: 400,
            customPainter: CustomPainterDialogo(),
            espacioAltura: 20);

  @override
  State<DialogoAgregarValorColumna> createState() =>
      _DialogoAgregarValorColumnaState();
}

class _DialogoAgregarValorColumnaState
    extends EstadoDialogoGenerico<DialogoAgregarValorColumna> {
  @override
  Widget constructorContenido(BuildContext context) {
    return ContenidoAgregarValorColumna(
      columna: widget.columna,
      onAgregarValorColumna: (nuevoValorColuma) {
        Navigator.of(context).pop();
      },
    );
  }
}
