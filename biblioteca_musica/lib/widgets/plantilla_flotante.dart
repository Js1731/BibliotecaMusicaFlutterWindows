import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/plantilla_hover.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca_musica/backend/misc/utiles.dart';

class PlantillaFlotante extends StatefulWidget {
  final int altura;
  final int ancho;
  final bool enabled;
  final Widget Function(bool hover) constructorContenido;

  const PlantillaFlotante(
      {required this.constructorContenido,
      this.altura = 25,
      this.ancho = 100,
      this.enabled = true,
      super.key});

  @override
  State<StatefulWidget> createState() => _PlantillaFlotante();
}

class _PlantillaFlotante extends State<PlantillaFlotante> {
  final double altura = 3;

  @override
  Widget build(BuildContext context) {
    return PlantillaHover(
      enabled: widget.enabled,
      constructorContenido: (context, hover) => SizedBox(
        width: widget.ancho.toDouble(),
        height: widget.altura + altura,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: (hover && widget.enabled) ? 0 : altura / 2,
              child: PlantillaHover(
                  constructorContenido: (context, hover) =>
                      widget.constructorContenido(hover),
                  enabled: widget.enabled),
            ),
          ],
        ),
      ),
    );
  }
}
