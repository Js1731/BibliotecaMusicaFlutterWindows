import 'package:biblioteca_musica/widgets/plantilla_hover.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

import 'decoracion_.dart';

class ItemPanelLateral extends StatefulWidget {
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
  State<StatefulWidget> createState() => _EstadoItemPanelLateral();
}

class _EstadoItemPanelLateral extends State<ItemPanelLateral> {
  @override
  Widget build(BuildContext context) {
    return PlantillaHover(
        constructorContenido: (context, hover) {
          return GestureDetector(
            onTap: widget.onPressed,
            child: widget.seleccionado
                ? _ItemSeleccionado(hover: hover, nombre: widget.texto)
                : _ItemNormal(hover: hover, nombre: widget.texto),
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
              borderRadius: BorderRadius.circular(10),
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
        child: LayoutBuilder(builder: (context, constraint) {
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
                    child: TextoPer(
                      texto: widget.nombre,
                      tam: 16,
                      color: DecoColores.rosa,
                    ))),
          );
        }));
  }

  @override
  void dispose() {
    super.dispose();

    animCont.dispose();
  }
}
