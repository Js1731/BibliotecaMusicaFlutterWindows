import 'package:flutter/cupertino.dart';

class TextoPer extends Text {
  TextoPer(
      {required String texto,
      double tam = 12,
      FontWeight weight = FontWeight.normal,
      TextAlign align = TextAlign.left,
      Color? color,
      int filasTexto = 1,
      super.key})
      : super(texto,
            textAlign: align,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: filasTexto,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none,
                color: color,
                fontSize: tam,
                fontWeight: weight));
}
