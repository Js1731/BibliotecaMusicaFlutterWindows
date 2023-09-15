import 'package:biblioteca_musica/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import '../../bloc/reproductor/bloc_reproductor.dart';
import '../../bloc/reproductor/estado_reproductor.dart';
import '../../bloc/reproductor/evento_reproductor.dart';
import '../../misc/utiles.dart';
import '../../widgets/texto_per.dart';

class SliderProgresoReproductor extends StatefulWidget {
  const SliderProgresoReproductor({super.key});

  @override
  State<SliderProgresoReproductor> createState() =>
      _SliderProgresoReproductorState();
}

class _SliderProgresoReproductorState extends State<SliderProgresoReproductor> {
  double posActual = 0;
  bool moviendoSlider = false;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlocReproductor, EstadoReproductor,
            Tuple2<int, CancionColumnaPrincipal?>>(
        selector: (state) =>
            Tuple2(state.progresoReproduccion, state.cancionReproducida),
        builder: (context, estado) {
          final progresoRep = estado.item1;
          final cancionRep = estado.item2;

          return Row(
            children: [
              TextoPer(
                  texto: duracionString(Duration(seconds: progresoRep.toInt())),
                  tam: 10,
                  color: Colors.white),
              Expanded(
                child: SliderTheme(
                    data: const SliderThemeData(
                        showValueIndicator: ShowValueIndicator.always,
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 15)),
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

                          context
                              .read<BlocReproductor>()
                              .add(EvCambiarProgreso(posArrastrado.toInt()));

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
        });
  }
}
