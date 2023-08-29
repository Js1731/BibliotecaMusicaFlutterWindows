import 'package:biblioteca_musica/widgets/plantilla_hover.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

import 'decoracion_.dart';

class ItemPanelLateral extends StatelessWidget {
  final String texto;
  final bool seleccionado;
  final VoidCallback onPressed;
  final Widget? extra;

  const ItemPanelLateral(
      {super.key,
      required this.texto,
      required this.seleccionado,
      required this.onPressed,
      this.extra});

  @override
  Widget build(BuildContext context) {
    return PlantillaHover(
        constructorContenido: (context, hover) {
          return GestureDetector(
            onTap: onPressed,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  seleccionado
                      ? _ItemSeleccionado(hover: hover, nombre: texto)
                      : _ItemNormal(hover: hover, nombre: texto),
                  Align(alignment: Alignment.bottomRight, child: extra)
                ],
              ),
            ),
          );
        },
        enabled: true);
  }
}

class _ItemNormal extends StatelessWidget {
  final bool hover;
  final String nombre;

  const _ItemNormal({required this.hover, required this.nombre});

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
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                //NOMBRE DE LA LISTA
                child: TextoPer(
                  texto: nombre,
                  tam: 16,
                  color: Colors.white,
                ))));
  }
}

class _ItemSeleccionado extends StatefulWidget {
  final bool hover;
  final String nombre;

  const _ItemSeleccionado({required this.hover, required this.nombre});

  @override
  State<StatefulWidget> createState() => _EstadoItemSeleccionado();
}

class _EstadoItemSeleccionado extends State<_ItemSeleccionado>
    with SingleTickerProviderStateMixin {
  late AnimationController animCont;

  @override
  void initState() {
    super.initState();

    animCont = AnimationController(
        lowerBound: 0,
        upperBound: 1,
        duration: const Duration(milliseconds: 100),
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
        child: LayoutBuilder(builder: (context, constraint) {
          return AnimatedContainer(
              width: constraint.maxWidth * animCont.value,
              duration: const Duration(milliseconds: 100),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

              //DECORACION
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.zero,
                    topRight: Radius.zero),
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),

                  //NOMBRE DE LA LISTA
                  child: TextoPer(
                    texto: widget.nombre,
                    tam: 16,
                    color: DecoColores.rosa,
                  )));
        }));
  }

  @override
  void dispose() {
    super.dispose();

    animCont.dispose();
  }
}
