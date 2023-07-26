import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';

enum SetColores { morado0, morado1, morado2, rosa0 }

Map<SetColores, List<Color>> SetsColores = {
  SetColores.morado0: <Color>[Deco.cMorado1, Deco.cRosa0],
  SetColores.morado1: <Color>[Deco.cMorado3, Deco.cRosa0],
  SetColores.morado2: <Color>[Deco.cMorado4, Deco.cRosa0],
  SetColores.rosa0: <Color>[Deco.cMorado1, Deco.cRosa0]
};

class BtnColor extends BtnGenerico {
  final double? w;

  BtnColor(
      {this.w,
      enabled = true,
      required SetColores setcolor,
      required String texto,
      required onPressed,
      super.key})
      : super(
            enabled: enabled,
            builder: (hover, context) {
              return Container(
                height: 25,
                width: w,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: Offset(0, 3))
                    ],
                    color: enabled
                        ? (hover
                            ? SetsColores[setcolor]![1]
                            : SetsColores[setcolor]![0])
                        : Deco.cGray,
                    borderRadius: BorderRadius.circular(15)),
                child: Text(texto,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white)),
              );
            },
            onPressed: onPressed);
}
