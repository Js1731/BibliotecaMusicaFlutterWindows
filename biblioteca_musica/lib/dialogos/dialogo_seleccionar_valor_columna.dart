import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/bloc_dialogo_seleccionar_columnas.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/estado_dialogo_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/eventos_dialogo_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/dialogos/contenido_agregar_valor_columna.dart';
import 'package:biblioteca_musica/dialogos/contenido_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/dialogos/dialogo_generico.dart';
import 'package:biblioteca_musica/dialogos/item_sugerencia_valor_columna.dart';
import 'package:biblioteca_musica/painters/custom_painter_dialogo.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_icono.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_simple.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/form/txt_field.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../painters/custom_painter_dialogo_sel_valor_columna.dart';

Future<ValorColumnaData?> abrirDialogoSeleccionarValorColumna(
    BuildContext context, ColumnaData columna) async {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            alignment: Alignment.center,
            backgroundColor: Colors.transparent,
            child: BlocProvider(
                create: (context) => BlocDialogoSeleccionarValorColumna(
                    context.read<RepositorioColumnas>(), columna)
                  ..add(EvBuscarSugerencias("")),
                child: DialogoSeleccionarValorColumna(
                  columna: columna,
                )),
          ));
}

class DialogoSeleccionarValorColumna extends DialogoGenerico {
  final ColumnaData columna;

  DialogoSeleccionarValorColumna({
    required this.columna,
    super.key,
  }) : super(
            ancho: 250,
            altura: 400,
            espacioAltura: 30,
            customPainter: CustomPainterDialogoSelValorColumna());

  @override
  State<StatefulWidget> createState() =>
      _EstadoDialogoSeleccionarValorColumna();
}

class _EstadoDialogoSeleccionarValorColumna
    extends EstadoDialogoGenerico<DialogoSeleccionarValorColumna> {
  @override
  Widget constructorContenido(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          Expanded(
              child: ContenidoSeleccionarValorColumna(
            columna: widget.columna,
            onAgregarValorColumna: () {
              setState(() {
                ancho = 560;
              });
            },
          )),
          if (constraints.maxWidth > 400)
            Expanded(
                child: ContenidoAgregarValorColumna(
              btnVolver: BtnFlotanteIcono(
                  onPressed: () {
                    setState(() {
                      ancho = 250;
                    });
                  },
                  icono: Icons.arrow_back_rounded,
                  tam: 20,
                  tamIcono: 15),
              columna: widget.columna,
              onAgregarValorColumna: (nuevoValorColuma) {
                context
                    .read<BlocDialogoSeleccionarValorColumna>()
                    .add(EvSeleccionarValorColumna(nuevoValorColuma));

                setState(() {
                  ancho = 250;
                });
              },
            ))
        ],
      );
    });
  }
}
