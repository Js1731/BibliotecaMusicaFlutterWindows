import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auxiliar_lista_reproduccion.dart';

class BtnReproducirAzar extends BotonCintaOpciones {
  BtnReproducirAzar({required ModoResponsive modoResponsive, super.key})
      : super(
            icono: Icons.shuffle,
            texto: "Azar",
            modoResponsive: modoResponsive,
            onPressed: (context) async {
              context
                  .read<AuxiliarListaReproduccion>()
                  .reproducirListaAzar(context);
            });
}
