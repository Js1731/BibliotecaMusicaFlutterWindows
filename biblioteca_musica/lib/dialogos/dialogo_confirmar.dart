import 'package:biblioteca_musica/dialogos/dialogo_generico.dart';
import 'package:biblioteca_musica/painters/custom_painter_dialogo_confirmar.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_simple.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';

import '../widgets/texto_per.dart';

///Abre un dialogo para que el usuario escoja entre Si o No
///
///Regresa true o NULL.
Future<bool?> abrirDialogoConfirmar(
    BuildContext context, String titulo, String desc,
    {int espera = 1}) async {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            elevation: 0,
            shadowColor: null,
            backgroundColor: Colors.transparent,
            child: DialogoConfirmar(titulo: titulo, desc: desc, espera: espera),
          ));
}

class DialogoConfirmar extends DialogoGenerico {
  final String titulo;
  final String desc;
  final IconData icono;
  final int espera;

  DialogoConfirmar(
      {required this.titulo,
      required this.desc,
      required this.espera,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ///CONTENIDO
          Expanded(
            child: Column(
              children: [
                ///ICONO
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: DecoColores.rosaClaro),
                  child: Icon(widget.icono, color: Colors.white, size: 55),
                ),

                ///TITULO
                TextoPer(
                    texto: widget.titulo, tam: 20, weight: FontWeight.bold),

                ///DESCRIPCION
                TextoPer(texto: widget.desc, tam: 14, filasTexto: 3),
              ],
            ),
          ),

          ///BOTON PARA ACEPTAR
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                    future:
                        Future.delayed(Duration(seconds: widget.espera), () {
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
      ),
    );
  }
}
