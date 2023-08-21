import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca_musica/backend/misc/utiles.dart';

class BtnFlotante extends StatefulWidget {
  final Color color;
  final String texto;
  final int altura;
  final int ancho;
  final VoidCallback onPressed;
  final bool enabled;
  final IconData? icono;

  const BtnFlotante(
      {required this.onPressed,
      required this.texto,
      this.icono,
      this.altura = 25,
      this.ancho = 100,
      this.enabled = true,
      this.color = DecoColores.rosaClaro,
      super.key});

  @override
  State<StatefulWidget> createState() => _EstadoBtnFlotante();
}

class _EstadoBtnFlotante extends State<BtnFlotante> {
  bool hover = false;
  final double altura = 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.ancho.toDouble(),
      height: widget.altura + altura,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            top: (hover && widget.enabled) ? 0 : altura / 2,
            child: MouseRegion(
              cursor: widget.enabled
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              onEnter: (event) => setState(() {
                hover = true;
              }),
              onExit: (event) => setState(() {
                hover = false;
              }),
              child: GestureDetector(
                onTap: widget.enabled ? widget.onPressed : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 20),
                  width: widget.ancho.toDouble(),
                  height: widget.altura.toDouble(),
                  decoration: BtnDecoration(
                    hover,
                    widget.enabled,
                    widget.color,
                  ),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icono != null)
                        Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: Icon(
                              widget.icono,
                              color: Colors.white,
                              size: 20,
                            )),
                      TextoPer(
                        texto: widget.texto,
                        tam: 14,
                        color: Colors.white,
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BtnDecoration extends BoxDecoration {
  BtnDecoration(bool hover, bool enabled, Color color)
      : super(
            color: enabled
                ? hover
                    ? aumnetarBrillo(color, 0.1)
                    : color
                : Colors.grey.shade600,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(blurRadius: (hover && enabled) ? 2 : 0, color: color)
            ]);
}
