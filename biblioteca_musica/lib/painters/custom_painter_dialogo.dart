import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';

class CustomPainterDialogo extends CustomPainter {
  final int _radio = 20;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
          topLeft: Radius.circular(_radio.toDouble() / 2),
          topRight: Radius.circular(_radio.toDouble() / 2),
          bottomLeft: Radius.circular(_radio.toDouble()),
          bottomRight: Radius.circular(_radio.toDouble()),
        ),
        Paint()..color = Colors.white);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromPoints(Offset.zero, Offset(size.width, 10)),
            topLeft: Radius.circular(_radio.toDouble() / 2),
            topRight: Radius.circular(_radio.toDouble() / 2),
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero),
        Paint()..color = DecoColores.rosaClaro);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromPoints(
                Offset(0, size.height - 40), Offset(size.width, size.height)),
            topLeft: Radius.zero,
            topRight: Radius.zero,
            bottomLeft: Radius.circular(_radio.toDouble() / 2),
            bottomRight: Radius.circular(_radio.toDouble() / 2)),
        Paint()..color = Deco.cGray);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
