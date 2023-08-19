import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:flutter/material.dart';

class BtnAccionReproductor extends BtnGenerico {
  BtnAccionReproductor(
      {super.enabled,
      required pausado,
      required IconData icono,
      required onPressed,
      super.key})
      : super(
            onPressed: onPressed,
            builder: (hover, context) => SizedBox(
                  child: Icon(
                    icono,
                    color: enabled
                        ? hover
                            ? Colors.white
                            : Colors.white70
                        : Colors.white10,
                    size: 30,
                  ),
                ));
}
