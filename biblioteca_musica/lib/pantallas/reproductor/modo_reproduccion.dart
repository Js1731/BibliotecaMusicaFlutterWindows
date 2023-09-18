import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/reproductor/bloc_reproductor.dart';
import '../../bloc/reproductor/estado_reproductor.dart';
import '../../widgets/decoracion_.dart';
import '../../widgets/texto_per.dart';

class ModoReproduccion extends StatelessWidget {
  const ModoReproduccion({super.key});

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
