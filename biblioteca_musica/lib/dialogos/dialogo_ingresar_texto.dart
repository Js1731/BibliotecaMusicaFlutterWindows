import 'package:biblioteca_musica/dialogos/dialogo_generico.dart';
import 'package:biblioteca_musica/painters/custom_painter_dialogo.dart';
import 'package:biblioteca_musica/widgets/form/btn_simple.dart';
import 'package:biblioteca_musica/widgets/form/txt_field.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

Future<String?> abrirDialogoIngresarTexto(
    BuildContext context, String titulo, String desc) {
  return showDialog<String?>(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: DialogoIngresarTexto(titulo: titulo, desc: desc),
          ));
}

class DialogoIngresarTexto extends DialogoGenerico {
  final String titulo;

  final String desc;

  DialogoIngresarTexto({required this.titulo, required this.desc, super.key})
      : super(
            ancho: 280,
            altura: 160,
            customPainter: CustomPainterDialogo(),
            espacioAltura: 30);

  @override
  State<StatefulWidget> createState() => _EstadoDialogoIngresarTexto();
}

class _EstadoDialogoIngresarTexto
    extends EstadoDialogoGenerico<DialogoIngresarTexto> {
  String textoIngresado = "";

  @override
  Widget constructorContenido(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextoPer(texto: widget.titulo, tam: 20, weight: FontWeight.bold),
              TextoPer(texto: widget.desc, tam: 14),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  decoration:
                      const CustomTxtFieldDecoration(hint: "Ej. Nueva Lista"),
                  onChanged: (nuevoTexto) {
                    textoIngresado = nuevoTexto;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BtnSimple(
                texto: "Agregar",
                onPressed: () {
                  Navigator.of(context).pop(textoIngresado);
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
