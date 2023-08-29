import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auxiliar_lista_reproduccion.dart';

class BtnReproducirAzar extends BotonCintaOpciones {
  BtnReproducirAzar({super.key})
      : super(
            icono: Icons.shuffle,
            texto: "Azar",
            onPressed: (context) async {
              context
                  .read<AuxiliarListaReproduccion>()
                  .reproducirListaAzar(context);
            });
}
