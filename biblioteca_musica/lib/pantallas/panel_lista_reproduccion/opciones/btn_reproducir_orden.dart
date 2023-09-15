//REPRODUCIR EN ORDEN
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/cinta_opciones.dart';
import '../auxiliar_lista_reproduccion.dart';

class BtnReproducirOrden extends BotonCintaOpciones {
  BtnReproducirOrden({required ModoResponsive modo, super.key})
      : super(
            icono: Icons.play_arrow,
            texto: "Orden",
            modo: modo,
            onPressed: (BuildContext context) async {
              await context
                  .read<AuxiliarListaReproduccion>()
                  .reproducirListaEnOrden(context);
            });
}
