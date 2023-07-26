import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

///Boton generico con un icono de +.
class BtnAgregar extends BtnGenerico {
  BtnAgregar({color1 = Deco.cGray, color2 = Colors.white, onPressed, super.key})
      : super(
            onPressed: onPressed,
            builder: (hover, context) => SizedBox(
                width: 28,
                height: 28,
                child: DottedBorder(
                    dashPattern: const [5, 5],
                    color: hover ? color2 : color1,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(20),
                    child: Container(
                        //PROPIEDADES
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.add,
                          color: hover ? color2 : color1,
                        )))));
}
