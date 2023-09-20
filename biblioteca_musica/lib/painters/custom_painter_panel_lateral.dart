import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPainterPanelLateral extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect =
        Rect.fromPoints(const Offset(0, 2), Offset(size.width, size.height));

    LinearGradient gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.center,
        colors: [DecoColores.rosaClaro, DecoColores.rosaOscuro]);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          bottomLeft: const Radius.circular(20),
        ),
        Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
