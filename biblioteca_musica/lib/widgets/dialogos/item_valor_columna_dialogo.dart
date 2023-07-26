import 'dart:io';

import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

String obtDirImagen(int id) => rutaDoc("$id.jpg");

///Item dentro de un [DialogoAsignarValorColuma].
class ItemValorColumnaDialogo extends BtnGenerico {
  ItemValorColumnaDialogo(
      {super.key,
      required onSeleccionado,
      required seleccionado,
      required valorPropiedad})
      : super(
            builder: (hover, context) => SizedBox(
                  width: 100,
                  child: Column(
                    children: [
                      //IMAGEN DEL VALOR COLUMNA
                      ImagenRectRounded(
                          conBorde: seleccionado,
                          tam: 100,
                          url:
                              File(obtDirImagen(valorPropiedad.id)).existsSync()
                                  ? obtDirImagen(valorPropiedad.id)
                                  : null),

                      //NOMBRE DEL VALOR COLUMNA
                      TextoPer(
                        texto: valorPropiedad.nombre,
                        tam: 15,
                        align: TextAlign.center,
                      )
                    ],
                  ),
                ),
            onPressed: onSeleccionado);
}
