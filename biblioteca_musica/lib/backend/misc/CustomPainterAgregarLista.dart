import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/cupertino.dart';

class CustomPainterAgregarLista extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.height / 2, size.height / 2), size.height / 2,
        Paint()..color = DecoColores.rosaClaro);
    canvas.drawRect(
        Rect.fromPoints(
            Offset(size.height / 2, 0), Offset(size.width, size.height)),
        Paint()..color = DecoColores.rosaClaro);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
