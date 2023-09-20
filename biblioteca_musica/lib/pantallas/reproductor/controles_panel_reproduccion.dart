import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/pantallas/reproductor/controles_reproduccion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/reproductor/bloc_reproductor.dart';
import '../../bloc/reproductor/estado_reproductor.dart';
import '../../bloc/reproductor/evento_reproductor.dart';
import '../../widgets/decoracion_.dart';
import 'modo_reproduccion.dart';

class ControlesPanelReproduccion extends StatelessWidget {
  final ModoResponsive modoResp;

  const ControlesPanelReproduccion(
      {super.key, this.modoResp = ModoResponsive.normal});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 500,
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            color: DecoColores.rosaOscuro,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const _ControlVolumen(),
                const Spacer(),
                ControlesReproduccion(
                  modoResp: modoResp,
                ),
                const Spacer(),
                const ModoReproduccion()
              ],
            ),
          ],
        ));
  }
}

class _ControlVolumen extends StatelessWidget {
  const _ControlVolumen();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: DecoColores.rosaOscuro,
          border: Border.all(color: Deco.cGray1),
          borderRadius: BorderRadius.circular(30)),
      child: BlocSelector<BlocReproductor, EstadoReproductor, double>(
          selector: (state) => state.volumen,
          builder: (_, volumen) {
            return Row(
              children: [
                Icon(
                  volumen > 0.5
                      ? Icons.volume_up
                      : volumen > 0.25
                          ? Icons.volume_down
                          : volumen == 0
                              ? Icons.volume_off
                              : Icons.volume_down,
                  color: Deco.cGray,
                ),
                const Spacer(),
                SizedBox(
                  width: 100,
                  child: SliderTheme(
                      data: const SliderThemeData(
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 15)),
                      child: Slider(
                        activeColor: Colors.white,
                        inactiveColor: DecoColores.rosaOscuro,
                        value: volumen,
                        min: 0,
                        max: 1,
                        onChanged: (nuevoVolumen) async {
                          context
                              .read<BlocReproductor>()
                              .add(EvCambiarVolumen(nuevoVolumen));
                        },
                      )),
                ),
              ],
            );
          }),
    );
  }
}
