import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/reproductor/bloc_reproductor.dart';
import '../../bloc/reproductor/estado_reproductor.dart';
import '../../bloc/reproductor/evento_reproductor.dart';
import '../../misc/archivos.dart';
import '../../widgets/decoracion_.dart';
import '../../widgets/imagen_round_rect.dart';
import '../../widgets/texto_per.dart';
import '../reproductor/btn_accion_reproductor.dart';

class PanelReducido extends StatelessWidget {
  const PanelReducido({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocReproductor, EstadoReproductor>(
        builder: (context, stateRep) {
      return Column(
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImagenRectRounded(
                url: rutaImagen(
                    stateRep.cancionReproducida?.valorColumnaPrincipal?.id),
                tam: 30,
                sombra: false,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextoPer(
                          texto: stateRep.cancionReproducida?.nombre ?? "---",
                          color: Colors.white,
                        ),
                        TextoPer(
                          texto: stateRep.cancionReproducida
                                  ?.valorColumnaPrincipal?.nombre ??
                              "---",
                          color: Colors.white24,
                        )
                      ]),
                ),
              ),
              BtnAccionReproductor(
                  pausado: stateRep.reproduciendo,
                  icono:
                      stateRep.reproduciendo ? Icons.pause : Icons.play_arrow,
                  onPressed: (ctxt) {
                    context.read<BlocReproductor>().add(EvTogglePausa());
                  })
            ],
          )),
          LinearProgressIndicator(
            color: DecoColores.rosaClaro1,
            backgroundColor: Colors.grey,
            value: (stateRep.progresoReproduccion /
                    (stateRep.cancionReproducida?.duracion ?? 1))
                .clamp(0, 1),
            minHeight: 2,
          )
        ],
      );
    });
  }
}
