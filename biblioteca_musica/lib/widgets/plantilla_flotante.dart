import 'package:biblioteca_musica/widgets/plantilla_hover.dart';
import 'package:flutter/material.dart';

class PlantillaFlotante extends StatefulWidget {
  final double altura;
  final double ancho;
  final bool enabled;
  final double espacioAltura;
  final Widget Function(bool hover) constructorContenido;

  const PlantillaFlotante({
    required this.constructorContenido,
    this.altura = 25,
    this.ancho = 100,
    this.enabled = true,
    this.espacioAltura = 3,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PlantillaFlotante();
}

class _PlantillaFlotante extends State<PlantillaFlotante> {
  @override
  Widget build(BuildContext context) {
    return PlantillaHover(
      enabled: widget.enabled,
      constructorContenido: (context, hover) => SizedBox(
        width: widget.ancho.toDouble(),
        height: widget.altura + widget.espacioAltura,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: (hover && widget.enabled) ? 0 : widget.espacioAltura / 2,
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
