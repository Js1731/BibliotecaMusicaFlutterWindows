import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class DialogoGenerico extends StatefulWidget {
  final double altura;
  final double ancho;
  final double espacioAltura;

  final CustomPainter customPainter;

  const DialogoGenerico(
      {super.key,
      required this.altura,
      required this.ancho,
      required this.espacioAltura,
      required this.customPainter});
}

abstract class EstadoDialogoGenerico<T extends DialogoGenerico>
    extends State<T> {
  bool animacionInicial = false;

  Widget constructorContenido(BuildContext context) {
    throw Exception(
        "No se definio un constructor del contenido de este dialogo o no se asigno el estado correcto en el metodo Create del widget.");
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 0),
      () {
        setState(() {
          animacionInicial = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.ancho,
      height: widget.altura + widget.espacioAltura,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            top: animacionInicial ? widget.espacioAltura / 2 : 0,
            child: CustomPaint(
                painter: widget.customPainter,
                child: Container(
                    width: widget.ancho,
                    height: widget.altura,
                    padding:
                        const EdgeInsets.only(left: 10, top: 10, right: 10),
                    child: constructorContenido(context))),
          ),
        ],
      ),
    );
  }
}
