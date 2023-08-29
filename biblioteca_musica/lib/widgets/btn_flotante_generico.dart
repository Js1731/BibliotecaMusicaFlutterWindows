import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/plantilla_flotante.dart';
import 'package:flutter/material.dart';

class BtnFlotanteGenerico extends StatefulWidget {
  final Color color;
  final VoidCallback onPressed;
  final bool enabled;
  final IconData? icono;
  final int ancho;
  final Widget Function(bool hover) constructorContenido;

  const BtnFlotanteGenerico(
      {required this.onPressed,
      required this.constructorContenido,
      this.ancho = 100,
      this.icono,
      this.enabled = true,
      this.color = DecoColores.rosaClaro,
      super.key});

  @override
  State<StatefulWidget> createState() => _EstadoBtnFlotante();
}

class _EstadoBtnFlotante extends State<BtnFlotanteGenerico> {
  @override
  Widget build(BuildContext context) {
    return PlantillaFlotante(
        ancho: widget.ancho,
        enabled: widget.enabled,
        constructorContenido: (hover) => GestureDetector(
              onTap: widget.enabled ? widget.onPressed : null,
              child: widget.constructorContenido(hover),
            ));
  }
}
