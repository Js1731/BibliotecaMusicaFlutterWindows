//REPRODUCIR EN ORDEN
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/cinta_opciones.dart';
import '../auxiliar_lista_reproduccion.dart';

class BtnReproducirOrden extends BotonCintaOpciones {
  BtnReproducirOrden({required modoResponsive, super.key})
      : super(
            icono: Icons.play_arrow,
            texto: "Orden",
            modoResponsive: modoResponsive,
            onPressed: (BuildContext context) async {
              await context
                  .read<AuxiliarListaReproduccion>()
                  .reproducirListaEnOrden(context);
            });
}
