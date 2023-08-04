import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPainterPanelLateral extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromPoints(Offset.zero, Offset(size.width, size.height));

    LinearGradient gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.center,
        colors: [DecoColores.rosaClaro, DecoColores.rosaOscuro]);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
