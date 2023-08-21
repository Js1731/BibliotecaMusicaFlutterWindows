import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auxiliar_lista_reproduccion.dart';

class BtnRecortarNombres extends BotonCintaOpciones {
  BtnRecortarNombres({super.key})
      : super(
            icono: Icons.content_cut_rounded,
            texto: "Recortar Nombres",
            onPressed: (context) async {
              await context
                  .read<AuxiliarListaReproduccion>()
                  .recortarNombres(context);
            });
}
