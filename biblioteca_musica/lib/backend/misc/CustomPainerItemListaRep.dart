import 'package:flutter/material.dart';

class CustomPainerItemListaRep extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
          topLeft: const Radius.circular(20),
          bottomLeft: const Radius.circular(20),
        ),
        Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
