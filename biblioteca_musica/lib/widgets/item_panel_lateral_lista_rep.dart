import 'package:biblioteca_musica/pantallas/panel_lateral/icono_animado.dart';
import 'package:biblioteca_musica/widgets/plantilla_hover.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

import 'decoracion_.dart';

class ItemPanelLateralListaRep extends StatelessWidget {
  final String texto;
  final bool seleccionado;
  final bool reproduciendo;
  final VoidCallback onPressed;

  const ItemPanelLateralListaRep(
      {super.key,
      required this.texto,
      required this.seleccionado,
      required this.onPressed,
      required this.reproduciendo});

  @override
  Widget build(BuildContext context) {
    return PlantillaHover(
        constructorContenido: (context, hover) {
          return GestureDetector(
            onTap: onPressed,
            child: seleccionado
                ? _ItemSeleccionado(
                    hover: hover,
                    nombre: texto,
                    reproducida: reproduciendo,
                  )
                : _ItemNormal(
                    hover: hover,
                    nombre: texto,
                    reproducida: reproduciendo,
                  ),
          );
        },
        enabled: true);
  }
}

class _ItemNormal extends StatelessWidget {
  final bool hover;
  final String nombre;
  final bool reproducida;

  const _ItemNormal(
      {required this.hover, required this.nombre, required this.reproducida});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          top: 2,
          bottom: 2,
          right: 10,
        ),
        width: double.infinity,
        height: 25,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

            //DECORACION
            decoration: BoxDecoration(
              color: hover ? Colors.white10 : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                //NOMBRE DE LA LISTA
                child: Row(
                  children: [
                    Expanded(
                      child: TextoPer(
                        texto: nombre,
                        tam: 16,
                        color: Colors.white,
                      ),
                    ),
                    if (reproducida) const IconoAnimado(color: Colors.white)
                  ],
                ))));
  }
}

class _ItemSeleccionado extends StatefulWidget {
  final bool hover;
  final String nombre;
  final bool reproducida;

  const _ItemSeleccionado(
      {required this.hover, required this.nombre, required this.reproducida});

  @override
  State<StatefulWidget> createState() => _EstadoItemSeleccionado();
}

class _EstadoItemSeleccionado extends State<_ItemSeleccionado>
    with SingleTickerProviderStateMixin {
  late AnimationController animCont;
  late Animation<double> anim;

  @override
  void initState() {
    super.initState();

    animCont = AnimationController(
        lowerBound: 0,
        upperBound: 1,
        duration: const Duration(milliseconds: 200),
        vsync: this)
      ..addListener(() {
        setState(() {});
      });

    animCont.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(
          top: 2,
          bottom: 2,
        ),
        height: 25,
        child: Stack(
          children: [
            LayoutBuilder(builder: (context, constraint) {
              return Opacity(
                  opacity: animCont.value,
                  child: Container(
                      width: constraint.maxWidth * animCont.value,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

                      //DECORACION
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.zero,
                            topRight: Radius.zero),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),

                        //NOMBRE DE LA LISTA
                        child: SizedBox(
                          width: 120 - (widget.reproducida ? 20 : 0),
                          child: TextoPer(
                            texto: widget.nombre,
                            tam: 16,
                            color: DecoColores.rosa,
                          ),
                        ),
                      )));
            }),
            Align(
              alignment: Alignment.centerRight,
              child: widget.reproducida
                  ? const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: IconoAnimado(color: DecoColores.rosa),
                    )
                  : const SizedBox(),
            )
          ],
        ));
  }

  @override
  void dispose() {
    animCont.dispose();
    super.dispose();
  }
}
