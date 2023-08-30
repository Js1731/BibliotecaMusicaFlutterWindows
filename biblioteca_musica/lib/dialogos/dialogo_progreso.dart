import 'package:biblioteca_musica/backend/misc/Proceso.dart';
import 'package:biblioteca_musica/dialogos/dialogo_generico.dart';
import 'package:biblioteca_musica/painters/custom_painter_dialogo.dart';
import 'package:biblioteca_musica/painters/custom_painter_dialogo_confirmar.dart';
import 'package:flutter/material.dart';

import '../widgets/decoracion_.dart';
import '../widgets/texto_per.dart';

void abrirDialogoProgreso(BuildContext context, String titulo, String desc,
    Procedimiento procedimiento,
    {IconData? icono}) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Dialog(
        alignment: Alignment.center,
        backgroundColor: Colors.transparent,
        child: DialogoProgreso(procedimiento, titulo, desc, icono: icono),
      );
    },
  );
}

class DialogoProgreso extends DialogoGenerico {
  final Procedimiento procedimiento;

  final String titulo;

  final String desc;

  final IconData? icono;

  DialogoProgreso(this.procedimiento, this.titulo, this.desc,
      {this.icono, super.key})
      : super(
          altura: 200,
          ancho: 200,
          espacioAltura: 30,
          customPainter: CustomPainterDialogoConfirmar(),
        );

  @override
  State<DialogoProgreso> createState() => _EstadoDialogoProgreso();
}

class _EstadoDialogoProgreso extends EstadoDialogoGenerico<DialogoProgreso> {
  @override
  void initState() {
    super.initState();

    widget.procedimiento.onCambioProgreso((prog) {
      setState(() {});

      if (prog == 1) {
        Navigator.of(context).pop();
      }
    });
  }

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

                const SizedBox(height: 10),

                Stack(
                  children: [
                    LinearProgressIndicator(
                      minHeight: 20,
                      color: DecoColores.rosaClaro,
                      backgroundColor: DecoColores.gris,
                      value: widget.procedimiento.progreso,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextoPer(
                          texto: widget.procedimiento.log,
                          tam: 15,
                          color: Colors.white,
                        ))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
