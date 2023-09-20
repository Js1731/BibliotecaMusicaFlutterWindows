import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auxiliar_lista_reproduccion.dart';

class BtnRecortarNombres extends BotonCintaOpciones {
  BtnRecortarNombres({required ModoResponsive modoResponsive, super.key})
      : super(
            icono: Icons.content_cut_rounded,
            texto: "Recortar Nombres",
            modoResponsive: modoResponsive,
            onPressed: (context) async {
              await context.read<AuxiliarListaReproduccion>().recortarNombres(
                  context,
                  context
                      .read<BlocListaReproduccionSeleccionada>()
                      .state
                      .obtCancionesSeleccionadas());
            });
}
