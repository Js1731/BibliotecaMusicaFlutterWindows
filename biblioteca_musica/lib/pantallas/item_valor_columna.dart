import 'dart:io';

import 'package:biblioteca_musica/controles/control_panel_central_columnas.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/misc/sincronizacion.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

String obtDirImagen(int id) => rutaDoc("$id.jpg");

///Representa un ValorColumna dentro del [PanelCentralColumnas].
class ItemValorColumna extends StatelessWidget {
  final ValorColumnaData valorColumna;
  final ControlPanelCentralPropiedades controlador;

  const ItemValorColumna(
      {super.key, required this.controlador, required this.valorColumna});

  @override
  Widget build(BuildContext context) {
    String? url = obtDirImagen(valorColumna.id);

    if (!File(url).existsSync()) {
      url = null;
    }

    return SizedBox(
      width: 100,
      child: Stack(
        children: [
          Column(
            children: [
              ImagenRectRounded(
                tam: 100,
                url: url,
              ),
              TextoPer(
                texto: valorColumna.nombre,
                tam: 15,
                align: TextAlign.center,
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,

            //OPCIONES DEL VALOR COLUMNA
            child: PopupMenuButton(
              tooltip: "",
              itemBuilder: (context) => [
                const PopupMenuItem(value: 0, child: Text("Editar")),
                const PopupMenuItem(value: 1, child: Text("Eliminar")),
              ],
              onSelected: (value) async {
                if (value == 0) {
                  await controlador.editarValorColumna(valorColumna);
                } else {
                  bool? confirmar = await mostrarDialogoConfirmar(
                      context,
                      "Quieres eliminar ${valorColumna.nombre}?",
                      "${valorColumna.nombre} y todas sus referencias seran eliminadas. Estas seguro?");
                  if (confirmar == null) return;
                  await controlador.eliminarValorColumna(valorColumna.id);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(35)),
                child: const Icon(
                  Icons.settings,
                  color: Color.fromARGB(255, 160, 160, 160),
                ),
              ),
            ),
          ),
          if (valorColumna.estado != estadoSync)
            Align(
              alignment: Alignment.topLeft,

              //ESTADO
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(35)),
                child: Icon(
                    valorColumna.estado == estadoLocal
                        ? Icons.upload_rounded
                        : valorColumna.estado == estadoServidor
                            ? Icons.download_rounded
                            : null,
                    color: Color.fromARGB(255, 120, 120, 120)),
              ),
            )
        ],
      ),
    );
  }
}
