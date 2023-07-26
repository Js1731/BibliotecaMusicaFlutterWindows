import 'package:biblioteca_musica/misc/Proceso.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/dialogos/abrir_dialogo.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

Future<void> abrirDialogoProgreso(String titulo, Procedimiento proc) async {
  mostrarDialogoAlerta(
      title: Text(titulo),
      puedeCerrar: false,
      content: StatefulBuilder(
        builder: (context, setState) {
          proc.onCambioProgreso((prog) {
            if (prog == 1) {
              Navigator.of(context).pop();
            }

            setState(() {});
          });

          return SizedBox(
            width: 200,
            height: 20,
            child: SizedBox(
                height: 20,
                child: Stack(children: [
                  LinearProgressIndicator(
                    value: proc.progreso,
                    minHeight: 20,
                    color: Deco.cMorado1,
                    backgroundColor: Deco.cGray,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextoPer(
                          texto: proc.log,
                          tam: 14,
                          color: Colors.white,
                        ),
                      ))
                ])),
          );
        },
      ),
      actions: (_) => []);

  await proc.iniciar();
}
