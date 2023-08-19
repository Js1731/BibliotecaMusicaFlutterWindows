import 'package:biblioteca_musica/backend/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/backend/misc/utiles.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/widgets/btn_accion_reproductor.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PanelReproductor extends StatefulWidget {
  const PanelReproductor({super.key});

  @override
  State<StatefulWidget> createState() => EstadoPanelReproductor();
}

class EstadoPanelReproductor extends State<PanelReproductor> {
  double posActual = 0;
  bool moviendoSlider = false;

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
          child: Column(
            children: [
              BlocSelector<BlocReproductor, EstadoReproductor, int>(
                  selector: (state) => state.progresoReproduccion,
                  builder: (context, progresoRep) {
                    return Row(
                      children: [
                        TextoPer(
                            texto: duracionString(
                                Duration(seconds: progresoRep.toInt())),
                            tam: 10,
                            color: Colors.white),
                        Expanded(
                          child: SliderTheme(
                              data: const SliderThemeData(
                                  showValueIndicator: ShowValueIndicator.always,
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 15)),
                              child: Builder(builder: (_) {
                                final durTotal = cancionRep?.duracion ?? 0;

                                if (!moviendoSlider) {
                                  posActual = 0.0 + progresoRep;
                                }

                                return Slider(
                                  activeColor: Deco.cGray0,
                                  inactiveColor: Colors.black,
                                  thumbColor: Colors.white,
                                  value: posActual,
                                  label: duracionString(
                                      Duration(seconds: posActual.toInt())),
                                  min: 0,
                                  max: (durTotal < 0 ? 0 : durTotal).toDouble(),
                                  onChangeStart: (posArrastrado) {
                                    moviendoSlider = true;
                                    posActual = posArrastrado;
                                  },
                                  onChangeEnd: (posArrastrado) async {
                                    posActual = posArrastrado;

                                    context.read<BlocReproductor>().add(
                                        EvCambiarProgreso(
                                            posArrastrado.toInt()));

                                    moviendoSlider = false;
                                  },
                                  onChanged: (posArrastrado) {
                                    setState(() {
                                      posActual = posArrastrado;
                                    });
                                  },
                                );
                              })),
                        ),
                        TextoPer(
                            texto: duracionString(
                                Duration(seconds: (cancionRep?.duracion ?? 0))),
                            tam: 10,
                            color: Colors.white)
                      ],
                    );
                  }),
              Row(
                children: [
                  const Spacer(),

                  ///INFORMACION DE LA CANCION REPRODUCIDA
                  Container(
                    width: 350,
                    height: 60,
                    padding: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: DecoColores.rosaOscuro,
                        borderRadius: BorderRadius.circular(10)),
                    child: BlocSelector<BlocReproductor, EstadoReproductor,
                            CancionColumnaPrincipal?>(
                        selector: (state) => state.cancionReproducida,
                        builder: (context, cancionRep) {
                          return Row(
                            children: [
                              ImagenRectRounded(
                                sombra: false,
                                radio: 10,
                                tam: 60,
                                // url: valorColumnaPrincipal != null
                                //     ? rutaImagen(valorColumnaPrincipal.id)
                                //     : null
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: TextoPer(
                                      texto: cancionRep?.nombre ?? "--",
                                      tam: 20,
                                      color: Colors.white,
                                      weight: FontWeight.normal,
                                    ),
                                  ),
                                  TextoPer(
                                    texto: cancionRep != null
                                        ? cancionRep.valorColumnaPrincipal
                                                ?.nombre ??
                                            "---"
                                        : "---",
                                    tam: 14,
                                    color: Deco.cGray1,
                                  )
                                ],
                              )
                            ],
                          );
                        }),
                  ),

                  const SizedBox(width: 20),

                  Container(
                      width: 500,
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: DecoColores.rosaOscuro,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 150,
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: DecoColores.rosaOscuro,
                                    border: Border.all(color: Deco.cGray1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: BlocSelector<BlocReproductor,
                                        EstadoReproductor, double>(
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
                                                        RoundSliderOverlayShape(
                                                            overlayRadius: 15)),
                                                child: Slider(
                                                  activeColor: Colors.white,
                                                  inactiveColor:
                                                      DecoColores.rosaOscuro,
                                                  value: volumen,
                                                  min: 0,
                                                  max: 1,
                                                  onChanged:
                                                      (nuevoVolumen) async {
                                                    context
                                                        .read<BlocReproductor>()
                                                        .add(EvCambiarVolumen(
                                                            nuevoVolumen));
                                                  },
                                                )),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Deco.cGray1),
                                    color: DecoColores.rosaOscuro,
                                    borderRadius: BorderRadius.circular(30)),
                                child: BlocSelector<BlocReproductor,
                                        EstadoReproductor, bool>(
                                    selector: (state) => state.reproduciendo,
                                    builder: (_, reproduciendo) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                              ),
                              const Spacer(),
                              BlocSelector<BlocReproductor, EstadoReproductor,
                                      bool>(
                                  selector: (state) => state.enOrden,
                                  builder: (_, enOrden) {
                                    return AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 150),
                                        transitionBuilder: (child, animation) =>
                                            FadeTransition(
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
                                                  color: enOrden
                                                      ? Deco.cGray1
                                                      : Colors.transparent),
                                              color: enOrden
                                                  ? DecoColores.rosaOscuro
                                                  : DecoColores.rosaClaro1,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
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
                                  })
                            ],
                          ),
                        ],
                      )),
                  const Spacer()
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
