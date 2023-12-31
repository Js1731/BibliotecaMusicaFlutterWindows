import 'package:flutter/material.dart';

class CustomPainterKOPI extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
          bottomLeft: const Radius.circular(20),
        ),
        Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
