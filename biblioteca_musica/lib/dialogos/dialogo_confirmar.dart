import 'package:biblioteca_musica/dialogos/dialogo_generico.dart';
import 'package:biblioteca_musica/painters/custom_painter_dialogo_confirmar.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_simple.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_generico.dart';
import 'package:flutter/material.dart';

import '../widgets/texto_per.dart';

Future<bool?> abrirDialogoConfirmar(
    BuildContext context, String titulo, String desc) async {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            elevation: 0,
            shadowColor: null,
            backgroundColor: Colors.transparent,
            child: DialogoConfirmar(titulo: titulo, desc: desc),
          ));
}

class DialogoConfirmar extends DialogoGenerico {
  final String titulo;
  final String desc;
  final IconData icono;

  DialogoConfirmar(
      {required this.titulo,
      required this.desc,
      this.icono = Icons.error_outline_rounded,
      super.key})
      : super(
            altura: 200,
            ancho: 280,
            customPainter: CustomPainterDialogoConfirmar(),
            espacioAltura: 30);

  @override
  State<StatefulWidget> createState() => _EstadoDialogoConfirmar();
}

class _EstadoDialogoConfirmar extends EstadoDialogoGenerico<DialogoConfirmar> {
  bool activarBoton = false;

  @override
  Widget constructorContenido(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: DecoColores.rosaClaro),
                child: Icon(widget.icono, color: Colors.white, size: 55),
              ),
              TextoPer(texto: widget.titulo, tam: 20, weight: FontWeight.bold),
              TextoPer(texto: widget.desc, tam: 14),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future:
                      Future.delayed(const Duration(milliseconds: 2000), () {
                    setState(() {
                      activarBoton = true;
                    });
                  }),
                  builder: (context, snapshot) {
                    return BtnFlotanteSimple(
                      enabled: activarBoton,
                      texto: "Eliminar",
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    );
                  })
            ],
          ),
        )
      ],
    );
  }
}
