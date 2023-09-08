import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/cupertino.dart';

class CustomPainterAgregarLista extends CustomPainter {
  final bool hover;

  CustomPainterAgregarLista(this.hover);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(size.height / 2, size.height / 2),
        size.height / 2,
        Paint()
          ..color = hover
              ? aumnetarBrillo(DecoColores.rosaClaro, 0.2)
              : DecoColores.rosaClaro);
    canvas.drawRect(
        Rect.fromPoints(
            Offset(size.height / 2, 0), Offset(size.width, size.height)),
        Paint()
          ..color = hover
              ? aumnetarBrillo(DecoColores.rosaClaro, 0.2)
              : DecoColores.rosaClaro);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
