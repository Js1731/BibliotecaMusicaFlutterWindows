import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/dialogos/contenido_valor_columna.dart';
import 'package:biblioteca_musica/dialogos/dialogo_generico.dart';
import 'package:biblioteca_musica/painters/custom_painter_dialogo.dart';
import 'package:flutter/material.dart';

class DialogoValorColumna extends DialogoGenerico {
  final ColumnaData columna;
  final ValorColumnaData? valorColIni;
  DialogoValorColumna(this.columna, {this.valorColIni, super.key})
      : super(
            ancho: 300,
            altura: 400,
            customPainter: CustomPainterDialogo(),
            espacioAltura: 20);

  @override
  State<DialogoValorColumna> createState() => _DialogoValorColumnaState();
}

class _DialogoValorColumnaState
    extends EstadoDialogoGenerico<DialogoValorColumna> {
  @override
  Widget constructorContenido(BuildContext context) {
    return ContenidoValorColumna(
      columna: widget.columna,
      valorColumnaIni: widget.valorColIni,
      onAceptarValorColumna: (nuevoValorColuma) {
        Navigator.of(context).pop();
      },
    );
  }
}
