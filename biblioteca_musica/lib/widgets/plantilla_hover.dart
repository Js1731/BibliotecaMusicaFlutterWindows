import 'package:flutter/material.dart';

class PlantillaHover extends StatefulWidget {
  final bool enabled;
  final Widget Function(BuildContext context, bool hover) constructorContenido;

  const PlantillaHover(
      {super.key, required this.constructorContenido, required this.enabled});

  @override
  State<StatefulWidget> createState() => _EstadoPlantillaHover();
}

class _EstadoPlantillaHover extends State<PlantillaHover> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (event) => setState(() {
              hover = true;
            }),
        onExit: (event) => setState(() {
              hover = false;
            }),
        child: widget.constructorContenido(context, hover));
  }
}
