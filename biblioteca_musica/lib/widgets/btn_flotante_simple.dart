import 'package:biblioteca_musica/widgets/btn_flotante_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'btn_flotante_icono.dart';

class BtnFlotanteSimple extends StatefulWidget {
  final VoidCallback onPressed;
  final String texto;
  final bool enabled;
  final Color color;
  final IconData? icono;
  final int ancho;
  final int altura;

  const BtnFlotanteSimple(
      {super.key,
      required this.onPressed,
      required this.texto,
      this.altura = 25,
      this.ancho = 100,
      this.enabled = true,
      this.color = DecoColores.rosaClaro,
      this.icono});

  @override
  State<BtnFlotanteSimple> createState() => _BtnFlotanteSimpleState();
}

class _BtnFlotanteSimpleState extends State<BtnFlotanteSimple> {
  @override
  Widget build(BuildContext context) {
    return BtnFlotanteGenerico(
        enabled: widget.enabled,
        ancho: widget.ancho,
        onPressed: widget.onPressed,
        constructorContenido: (hover) => AnimatedContainer(
              width: widget.ancho.toDouble(),
              height: widget.altura.toDouble(),
              duration: const Duration(milliseconds: 20),
              decoration: BtnDecoration(
                hover,
                widget.enabled,
                widget.color,
              ),
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
            ));
  }
}
