import 'package:biblioteca_musica/bloc/cubit_modo_responsive.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

class OpcionesListaGenerica extends StatelessWidget {
  const OpcionesListaGenerica({super.key});

  List<Widget> construirOpcionesNormales(
      BuildContext context, ModoResponsive modoResponsive) {
    throw "No se definio un constructor para las opciones normales";
  }

  List<Widget> construirOpcionesSeleccion(
      BuildContext context, ModoResponsive modoResponsive) {
    throw "No se definio un constructor para las opciones de seleccion";
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlocListaReproduccionSeleccionada,
            EstadoListaReproduccionSelecconada, Tuple2<Map<int, bool>, int>>(
        selector: (state) => Tuple2(state.mapaCancionesSeleccionadas,
            state.obtCantidadCancionesSeleccionadas()),
        builder: (context, data) {
          final cancionesSeleccionadas = data.item2 != 0;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: BlocBuilder<CubitModoResponsive, ModoResponsive>(
              builder: (context, modoResponsive) => CintaOpciones(
                  key: ValueKey(cancionesSeleccionadas),
                  lstOpciones: [
                    ...cancionesSeleccionadas
                        ? construirOpcionesSeleccion(context, modoResponsive)
                        : construirOpcionesNormales(context, modoResponsive)
                  ]),
            ),
          );
        });
  }
}
