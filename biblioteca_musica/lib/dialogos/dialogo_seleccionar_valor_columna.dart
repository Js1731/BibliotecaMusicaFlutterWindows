import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/bloc_dialogo_seleccionar_columnas.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/eventos_dialogo_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/dialogos/contenido_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/dialogos/dialogo_generico.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../painters/custom_painter_dialogo_sel_valor_columna.dart';

///Abre un dialogo para seleccionar un valor columna
///
///Retorna el valor columna seleccionado
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
    return ContenidoSeleccionarValorColumna(
      onSeleccionarValorColumna: (valorColumna) {
        Navigator.of(context).pop(valorColumna);
      },
      columna: widget.columna,
      onAgregarValorColumna: () {},
    );
  }
}
