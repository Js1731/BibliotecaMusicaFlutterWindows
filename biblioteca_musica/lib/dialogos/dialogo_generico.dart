import 'package:biblioteca_musica/bloc/dimensiones_panel.dart/bloc_dimesiones_panel.dart';
import 'package:biblioteca_musica/bloc/dimensiones_panel.dart/estado_dimensiones_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
        create: (context) => BlocDimensionesPanel(
            EstadoDimensionesPanel(ancho: widget.ancho, altura: widget.altura)),
        child: BlocBuilder<BlocDimensionesPanel, EstadoDimensionesPanel>(
            builder: (context, dimensiones) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: dimensiones.ancho,
            height: dimensiones.altura + widget.espacioAltura,
            curve: Curves.easeOutExpo,
            child: Center(
              child: LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      top: animacionInicial ? widget.espacioAltura : 0,
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutExpo,
                          width: dimensiones.ancho < constraints.maxWidth
                              ? constraints.maxWidth
                              : dimensiones.ancho,
                          height: dimensiones.altura,
                          child: CustomPaint(
                              painter: widget.customPainter,
                              child: Container(
                                  width: dimensiones.ancho,
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Center(
                                      child: constructorContenido(context))))),
                    ),
                  ],
                );
              }),
            ),
          );
        }));
  }
}
