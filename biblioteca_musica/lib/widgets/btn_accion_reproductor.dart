import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:flutter/material.dart';

class BtnAccionReproductor extends BtnGenerico {
  BtnAccionReproductor(
      {super.enabled, required IconData icono, required onPressed, super.key})
      : super(
            onPressed: onPressed,
            builder: (hover, context) => SizedBox(
                  child: Icon(
                    icono,
                    color: hover ? Colors.white : Colors.white60,
                    size: 30,
                  ),
                ));
}
