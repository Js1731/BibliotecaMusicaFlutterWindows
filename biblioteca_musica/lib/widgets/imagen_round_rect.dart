import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImagenRectRounded extends StatelessWidget {
  final String? url;
  final double tam;
  final bool conBorde;
  final double radio;
  final bool sombra;

  const ImagenRectRounded(
      {this.url,
      this.conBorde = false,
      this.tam = 80,
      this.radio = 20,
      this.sombra = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    ImageProvider im;

    if (url != null) {
      im = FileImage(File(url!));
    } else {
      im = const AssetImage("assets/recursos/ImNoImagen.png");
    }

    return Container(
      width: tam,
      height: tam,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radio),
          border: Border.all(
              color: conBorde ? Deco.cRosa0 : Colors.transparent, width: 5),
          image: DecorationImage(
            fit: BoxFit.contain,
            image: im,
          ),
          boxShadow: sombra
              ? const [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 5,
                      spreadRadius: 5)
                ]
              : null),
    );
  }
}
