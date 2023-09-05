import 'dart:math';

import 'package:flutter/material.dart';

class IconoAnimado extends StatelessWidget {
  final Color color;

  const IconoAnimado({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 30,
      child: Row(
        children: [
          _BarraAnimada(color: color, alturaMax: 0.5),
          _BarraAnimada(color: color),
          _BarraAnimada(color: color, alturaMax: 0.5)
        ],
      ),
    );
  }
}

class _BarraAnimada extends StatefulWidget {
  final double alturaMax;
  final Color color;

  const _BarraAnimada({required this.color, this.alturaMax = 1.0});

  @override
  State<StatefulWidget> createState() => _EstadoBarraAnimada();
}

class _EstadoBarraAnimada extends State<_BarraAnimada>
    with TickerProviderStateMixin {
  late AnimationController anim;
  late Animation<double> animFin;

  @override
  void initState() {
    super.initState();

    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    animFin = Tween(begin: widget.alturaMax, end: 0.3 * widget.alturaMax)
        .animate(CurveTween(curve: Curves.bounceInOut).animate(anim))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (mounted) {
            anim.forward(from: Random().nextDouble());
          }
        }
      });

    anim.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 6,
        height: 15,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: animFin.value * 15,
              decoration: BoxDecoration(
                  color: widget.color, borderRadius: BorderRadius.circular(3)),
            )
          ],
        ));
  }

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }
}
