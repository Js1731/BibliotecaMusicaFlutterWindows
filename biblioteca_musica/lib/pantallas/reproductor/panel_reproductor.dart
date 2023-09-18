import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/pantallas/reproductor/controles_panel_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/reproductor/informacion_cancion_reproducida.dart';
import 'package:biblioteca_musica/pantallas/reproductor/slider_progreso_reproduccion.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PanelReproductor extends StatelessWidget {
  final ModoResponsive modo;

  const PanelReproductor({required this.modo, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlocReproductor, EstadoReproductor,
        CancionColumnaPrincipal?>(
      selector: (state) => state.cancionReproducida,
      builder: (context, cancionRep) {
        return Container(
            height: 100,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: DecoColores.rosa,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                const SliderProgresoReproductor(),
                Row(
                  children: [
                    const Spacer(),

                    ///INFORMACION DE LA CANCION REPRODUCIDA
                    InformacionCancionReproducida(modo: modo),

                    const SizedBox(width: 20),

                    const ControlesPanelReproduccion(),

                    const Spacer()
                  ],
                ),
              ],
            ));
      },
    );
  }
}
