import 'package:biblioteca_musica/dialogos/dialogo_generico.dart';
import 'package:biblioteca_musica/painters/custom_painter_dialogo.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_simple.dart';
import 'package:biblioteca_musica/widgets/form/txt_field.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

///Abre un dialogo para ingresar texto
///
///Retorna el texto ingresado
Future<String?> abrirDialogoIngresarTexto(
    BuildContext context, String titulo, String desc,
    {double altura = 160, String hint = "", String? txtIni}) {
  return showDialog<String?>(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: DialogoIngresarTexto(
              hint: hint,
              altura: altura,
              titulo: titulo,
              desc: desc,
              txtIni: txtIni,
            ),
          ));
}

class DialogoIngresarTexto extends DialogoGenerico {
  final String titulo;

  final String desc;
  final String hint;
  final String? txtIni;

  DialogoIngresarTexto(
      {required this.titulo,
      required this.desc,
      required this.hint,
      this.txtIni,
      super.altura = 160,
      super.key})
      : super(
            ancho: 280,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///CONTENIDO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TITULO
                TextoPer(
                    texto: widget.titulo, tam: 20, weight: FontWeight.bold),

                //DESCRIPCION
                TextoPer(texto: widget.desc, tam: 14, filasTexto: 3),

                //TEXTFIELD
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    initialValue: widget.txtIni,
                    decoration: CustomTxtFieldDecoration(hint: widget.hint),
                    onChanged: (nuevoTexto) {
                      textoIngresado = nuevoTexto;
                    },
                  ),
                ),
              ],
            ),
          ),

          //BOTON ACEPTAR
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BtnFlotanteSimple(
                  texto: "Ok",
                  onPressed: () {
                    Navigator.of(context).pop(textoIngresado);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
