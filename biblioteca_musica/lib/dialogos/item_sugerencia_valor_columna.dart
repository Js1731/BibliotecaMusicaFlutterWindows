import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/bloc_dialogo_seleccionar_columnas.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/eventos_dialogo_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/plantilla_hover.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/imagen_round_rect.dart';

class ItemSugerenciaValorColumna extends StatefulWidget {
  final ValorColumnaData valorColumna;
  final bool seleccionado;

  const ItemSugerenciaValorColumna(
      {super.key, required this.valorColumna, required this.seleccionado});

  @override
  State<StatefulWidget> createState() => _EstadoItemSugerenciaValorColumna();
}

class _EstadoItemSugerenciaValorColumna
    extends State<ItemSugerenciaValorColumna> {
  final altura = 40;

  @override
  Widget build(BuildContext context) {
    return PlantillaHover(
      enabled: true,
      constructorContenido: (context, hover) => Container(
        margin: const EdgeInsets.symmetric(vertical: 2.5),
        height: altura.toDouble(),
        child: GestureDetector(
          onTap: () {
            context
                .read<BlocDialogoSeleccionarValorColumna>()
                .add(EvSeleccionarValorColumna(widget.valorColumna));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: widget.seleccionado
                        ? DecoColores.rosaClaro
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
                color: hover ? Colors.black26 : Colors.black12),
            child: Row(
              children: [
                ImagenRectRounded(
                  url: rutaImagen(widget.valorColumna.id),
                  radio: 5,
                  sombra: false,
                  tam: altura.toDouble() - 10,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextoPer(
                      texto: widget.valorColumna.nombre,
                      tam: 16,
                      color:
                          widget.seleccionado ? DecoColores.rosa : Colors.black,
                      weight: widget.seleccionado
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
