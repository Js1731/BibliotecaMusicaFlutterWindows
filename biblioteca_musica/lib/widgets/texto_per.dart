import 'package:flutter/cupertino.dart';

class TextoPer extends Text {
  TextoPer(
      {required String texto,
      required double tam,
      FontWeight weight = FontWeight.normal,
      TextAlign align = TextAlign.left,
      Color? color,
      super.key})
      : super(texto,
            textAlign: align,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 1,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none,
                color: color,
                fontSize: tam,
                fontWeight: weight));
}
