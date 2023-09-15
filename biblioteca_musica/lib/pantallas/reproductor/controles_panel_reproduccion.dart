import 'package:biblioteca_musica/datos/cancion_columna_principal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/reproductor/bloc_reproductor.dart';
import '../../bloc/reproductor/estado_reproductor.dart';
import '../../bloc/reproductor/evento_reproductor.dart';
import '../../widgets/decoracion_.dart';
import '../../widgets/texto_per.dart';
import 'btn_accion_reproductor.dart';

class ControlesPanelReproduccion extends StatefulWidget {
  const ControlesPanelReproduccion({super.key});

  @override
  State<ControlesPanelReproduccion> createState() =>
      _ControlesPanelReproduccionState();
}

class _ControlesPanelReproduccionState
    extends State<ControlesPanelReproduccion> {
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
                BlocSelector<BlocReproductor, EstadoReproductor,
                        CancionColumnaPrincipal?>(
                    selector: (state) => state.cancionReproducida,
                    builder: (context, cancionRep) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Deco.cGray1),
                            color: DecoColores.rosaOscuro,
                            borderRadius: BorderRadius.circular(30)),
                        child: BlocSelector<BlocReproductor, EstadoReproductor,
                                bool>(
                            selector: (state) => state.reproduciendo,
                            builder: (_, reproduciendo) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BtnAccionReproductor(
                                      pausado: reproduciendo,
                                      enabled: cancionRep != null,
                                      icono: Icons.skip_previous,
                                      onPressed: (_) async {
                                        context
                                            .read<BlocReproductor>()
                                            .add(EvRegresarCancion());
                                      }),
                                  const SizedBox(width: 5),
                                  BtnAccionReproductor(
                                      pausado: reproduciendo,
                                      enabled: cancionRep != null,
                                      icono: Icons.fast_rewind,
                                      onPressed: (_) async {
                                        context
                                            .read<BlocReproductor>()
                                            .add(EvRegresar10s());
                                      }),
                                  const SizedBox(width: 5),
                                  BtnAccionReproductor(
                                      pausado: reproduciendo,
                                      enabled: cancionRep != null,
                                      icono: reproduciendo
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      onPressed: (_) async {
                                        context
                                            .read<BlocReproductor>()
                                            .add(EvTogglePausa());
                                      }),
                                  const SizedBox(width: 5),
                                  BtnAccionReproductor(
                                      pausado: reproduciendo,
                                      enabled: cancionRep != null,
                                      icono: Icons.fast_forward,
                                      onPressed: (_) async {
                                        context
                                            .read<BlocReproductor>()
                                            .add(EvAvanzar10s());
                                      }),
                                  const SizedBox(width: 5),
                                  BtnAccionReproductor(
                                      pausado: reproduciendo,
                                      enabled: cancionRep != null,
                                      icono: Icons.skip_next,
                                      onPressed: (_) async {
                                        context
                                            .read<BlocReproductor>()
                                            .add(EvAvanzarCancion());
                                      }),
                                ],
                              );
                            }),
                      );
                    }),
                const Spacer(),
                const _ModoReproduccion()
              ],
            ),
          ],
        ));
  }
}

class _ControlVolumen extends StatefulWidget {
  const _ControlVolumen({super.key});

  @override
  State<_ControlVolumen> createState() => _ControlVolumenState();
}

class _ControlVolumenState extends State<_ControlVolumen> {
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

class _ModoReproduccion extends StatefulWidget {
  const _ModoReproduccion({super.key});

  @override
  State<_ModoReproduccion> createState() => _ModoReproduccionState();
}

class _ModoReproduccionState extends State<_ModoReproduccion> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlocReproductor, EstadoReproductor, bool>(
        selector: (state) => state.enOrden,
        builder: (_, enOrden) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
              child: Container(
                key: ValueKey(enOrden),
                width: 110,
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: enOrden ? Deco.cGray1 : Colors.transparent),
                    color: enOrden
                        ? DecoColores.rosaOscuro
                        : DecoColores.rosaClaro1,
                    borderRadius: BorderRadius.circular(20)),
                child: !enOrden
                    ? Row(
                        children: [
                          const Icon(
                            Icons.shuffle,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: TextoPer(
                              align: TextAlign.center,
                              texto: "Aleatorio",
                              tam: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const Icon(
                            Icons.shuffle,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: TextoPer(
                              align: TextAlign.center,
                              texto: "Orden",
                              tam: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ));
        });
  }
}
