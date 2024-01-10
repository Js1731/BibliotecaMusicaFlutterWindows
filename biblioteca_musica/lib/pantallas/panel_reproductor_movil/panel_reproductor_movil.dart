import 'package:biblioteca_musica/bloc/cubit_reproductor_movil.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/pantallas/panel_reproductor_movil/panel_reproductor_movil_expandido.dart';
import 'package:biblioteca_musica/pantallas/panel_reproductor_movil/panel_reproductor_movil_reducido.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/plantilla_hover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PanelReproductorMovil extends StatefulWidget {
  const PanelReproductorMovil({super.key});

  @override
  State<StatefulWidget> createState() => _EstadoPanelReproductorMovil();
}

class _EstadoPanelReproductorMovil extends State<PanelReproductorMovil> {
  bool animTerminado = true;
  Color colorHoverReproductor = aumnetarBrillo(DecoColores.rosaOscuro, 0.3);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitReproductorMovil, bool>(
        builder: (context, expandido) {
      return LayoutBuilder(builder: (context, constraints) {
        return PlantillaHover(
          enabled: !expandido,
          constructorContenido: (context, hover) => GestureDetector(
            onTap: () {
              if (context.read<CubitReproductorMovil>().state == false) {
                setState(() {
                  animTerminado = false;
                });
                context.read<CubitReproductorMovil>().toggleModo();
              }
            },
            child: AnimatedContainer(
              onEnd: () {
                setState(() {
                  animTerminado = true;
                });
              },
              duration: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
              height:
                  expandido ? (constraints.maxHeight - 20).clamp(0, 600) : 50,
              decoration: BoxDecoration(
                  color: hover ? colorHoverReproductor : DecoColores.rosaOscuro,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: expandido
                      ? animTerminado
                          ? const PanelExpandido()
                          : const SizedBox(width: double.maxFinite)
                      : const PanelReducido()),
            ),
          ),
        );
      });
    });
  }
}
