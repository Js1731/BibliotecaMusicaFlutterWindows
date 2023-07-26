import 'package:biblioteca_musica/widgets/btn_color.dart';
import 'package:biblioteca_musica/widgets/btn_popupmenu_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';

class BtnColorPopupMenu<T> extends BtnPopupMenuGenerico {
  BtnColorPopupMenu(
      {super.key,
      super.enabled,
      required String texto,
      required SetColores setColor,
      required super.onSelected,
      required super.itemBuilder})
      : super(
          botonBuilder: (hover, context) => Container(
            width: 100,
            height: 25,
            padding: const EdgeInsets.all(2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: enabled
                  ? !hover
                      ? SetsColores[setColor]![0]
                      : SetsColores[setColor]![1]
                  : Deco.cGray,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: Offset(0, 3))
              ],
            ),
            child: Text(texto, style: const TextStyle(color: Colors.white)),
          ),
        );
}
