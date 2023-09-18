import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:flutter/material.dart';

class CustomPainerPanelCentral extends CustomPainter {
  final ModoResponsive modoResp;

  CustomPainerPanelCentral(this.modoResp);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
          bottomRight: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: modoResp == ModoResponsive.muyReducido
              ? const Radius.circular(20)
              : Radius.zero,
          topLeft: modoResp == ModoResponsive.muyReducido
              ? const Radius.circular(20)
              : Radius.zero,
        ),
        Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
