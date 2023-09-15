import 'package:biblioteca_musica/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/pantallas/reproductor/btn_accion_reproductor.dart';
import 'package:biblioteca_musica/pantallas/reproductor/controles_panel_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/reproductor/informacion_cancion_reproducida.dart';
import 'package:biblioteca_musica/pantallas/reproductor/slider_progreso_reproduccion.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../misc/archivos.dart';

class PanelReproductor extends StatefulWidget {
  const PanelReproductor({super.key});

  @override
  State<StatefulWidget> createState() => EstadoPanelReproductor();
}

class EstadoPanelReproductor extends State<PanelReproductor> {
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
              color: DecoColores.rosa, borderRadius: BorderRadius.circular(20)),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                const SliderProgresoReproductor(),
                Row(
                  children: [
                    const Spacer(),

                    ///INFORMACION DE LA CANCION REPRODUCIDA
                    InformacionCancionReproducida(
                        modo: constraints.maxWidth > 900
                            ? ModoInfoCancionReproducida.normal
                            : ModoInfoCancionReproducida.reducida),

                    const SizedBox(width: 20),

                    const ControlesPanelReproduccion(),

                    const Spacer()
                  ],
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
