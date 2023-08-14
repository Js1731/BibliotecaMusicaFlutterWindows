import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:biblioteca_musica/backend/misc/utiles.dart';
import 'package:biblioteca_musica/backend/providers/provider_reproductor.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/widgets/btn_accion_reproductor.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
    return Selector<ProviderReproductor,
        Tuple2<CancionData?, ValorColumnaData?>>(
      selector: (_, provRep) => Tuple2(null, provRep.valorColumnaPrincipal),
      builder: (_, datos, __) {
        final cancionRep = datos.item1;
        final valorColumnaPrincipal = datos.item2;

        return Container(
          height: 100,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: DecoColores.rosa, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(
                children: [
                  Selector<ProviderReproductor, int>(
                      selector: (_, provRep) => provRep.posActual,
                      builder: (_, pos, __) {
                        return TextoPer(
                            texto:
                                duracionString(Duration(seconds: pos.toInt())),
                            tam: 10,
                            color: Colors.white);
                      }),
                  Expanded(
                    child: SliderTheme(
                        data: const SliderThemeData(
                            showValueIndicator: ShowValueIndicator.always,
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 15)),
                        child: Selector<ProviderReproductor, Tuple2<int, int>>(
                            selector: (_, provRep) =>
                                Tuple2(provRep.posActual, provRep.durActual),
                            builder: (_, datos, __) {
                              final posActualCancion = datos.item1;
                              final durTotal = datos.item2;

                              if (!moviendoSlider) {
                                posActual = posActualCancion.toDouble();
                              }

                              return Slider(
                                activeColor: Deco.cGray0,
                                inactiveColor: Deco.cGray1,
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

                                  await provReproductor.moverA(Duration(
                                      microseconds:
                                          (posActual * 1000000).toInt()));
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
                  Selector<ProviderReproductor, int>(
                      selector: (_, provRep) => provRep.durActual,
                      builder: (_, durTotal, __) {
                        return TextoPer(
                            texto: duracionString(Duration(
                                seconds: (durTotal < 0 ? 0 : durTotal))),
                            tam: 10,
                            color: Colors.white);
                      })
                ],
              ),
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
                    child: Row(
                      children: [
                        ImagenRectRounded(
                            sombra: false,
                            radio: 10,
                            tam: 60,
                            url: valorColumnaPrincipal != null
                                ? rutaImagen(valorColumnaPrincipal.id)
                                : null),
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
                              texto: valorColumnaPrincipal?.nombre ?? "---",
                              tam: 14,
                              color: Deco.cGray1,
                            )
                          ],
                        )
                      ],
                    ),
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
                                child: Selector<ProviderReproductor, double>(
                                    selector: (_, provRep) => provRep.volumen,
                                    builder: (_, volumen, __) {
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
                                                    await provReproductor
                                                        .cambiarVolumen(
                                                            nuevoVolumen);
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
                                child: Selector<ProviderReproductor,
                                        Tuple2<bool, bool>>(
                                    selector: (_, provRep) => Tuple2(
                                        provRep.activo, provRep.reproduciendo),
                                    builder: (_, data, __) {
                                      final activo = data.item1;
                                      final reproduciendo = data.item2;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          BtnAccionReproductor(
                                              enabled: reproduciendo || activo,
                                              icono: Icons.skip_previous,
                                              onPressed: (_) async {
                                                await provReproductor
                                                    .reproducirAnterior();
                                              }),
                                          const SizedBox(width: 5),
                                          BtnAccionReproductor(
                                              enabled: reproduciendo || activo,
                                              icono: Icons.fast_rewind,
                                              onPressed: (_) async {
                                                await provReproductor
                                                    .regresar10s();
                                              }),
                                          const SizedBox(width: 5),
                                          BtnAccionReproductor(
                                              enabled: reproduciendo || activo,
                                              icono: reproduciendo
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              onPressed: (_) async {
                                                provReproductor
                                                    .pausarReanudar();
                                              }),
                                          const SizedBox(width: 5),
                                          BtnAccionReproductor(
                                              enabled: reproduciendo || activo,
                                              icono: Icons.fast_forward,
                                              onPressed: (_) async {
                                                await provReproductor
                                                    .adelantar10s();
                                              }),
                                          const SizedBox(width: 5),
                                          BtnAccionReproductor(
                                              enabled: reproduciendo || activo,
                                              icono: Icons.skip_next,
                                              onPressed: (_) async {
                                                await provReproductor
                                                    .reproducirSiguiente();
                                              }),
                                        ],
                                      );
                                    }),
                              ),
                              const Spacer(),
                              Selector<ProviderReproductor, bool>(
                                  selector: (_, provRep) => provRep.enOrden,
                                  builder: (_, enOrden, __) {
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
