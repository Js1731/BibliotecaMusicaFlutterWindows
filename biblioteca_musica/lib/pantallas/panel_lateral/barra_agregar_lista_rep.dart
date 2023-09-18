import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../painters/custom_painter_agregar_lista.dart';
import '../../widgets/btn_generico.dart';
import '../../widgets/decoracion_.dart';
import '../../widgets/texto_per.dart';
import 'auxiliar_panel_lateral.dart';

class BarraAgregarListaRep extends StatelessWidget {
  const BarraAgregarListaRep({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      color: DecoColores.rosaClaro1,
      child: Stack(children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 8.0),
          child: TextoPer(texto: "Listas", tam: 16, color: Colors.white),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: BtnGenerico(onPressed: (_) async {
            await context
                .read<AuxiliarListasReproduccion>()
                .agregarLista(context);
          }, builder: (hover, context) {
            return CustomPaint(
              painter: CustomPainterAgregarLista(hover),
              child: Container(
                width: 80,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: double.maxFinite,
                child: TextoPer(texto: "Nuevo +", tam: 16, color: Colors.white),
              ),
            );
          }),
        )
      ]),
    );
  }
}
