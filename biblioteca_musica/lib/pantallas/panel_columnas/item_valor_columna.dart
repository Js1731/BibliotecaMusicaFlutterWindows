import 'dart:io';

import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/bloc/sincronizador/sincronizacion.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas/auxiliar_panel_columnas.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';
import 'package:biblioteca_musica/widgets/plantilla_flotante.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/btn_flotante_icono.dart';

String obtDirImagen(int id) => rutaDoc("$id.jpg");

///Representa un ValorColumna dentro del [PanelCentralColumnas].
class ItemValorColumna extends StatelessWidget {
  final ValorColumnaData valorColumna;

  const ItemValorColumna({super.key, required this.valorColumna});

  @override
  Widget build(BuildContext context) {
    String? url = obtDirImagen(valorColumna.id);

    if (!File(url).existsSync()) {
      url = null;
    }

    return PlantillaFlotante(
      espacioAltura: 15,
      altura: 130,
      ancho: 100,
      constructorContenido: (hover) => SizedBox(
        width: 100,
        child: Stack(
          children: [
            Column(
              children: [
                ColorFiltered(
                  colorFilter: valorColumna.estado == estadoLocal ||
                          valorColumna.estado == estadoSync
                      ? const ColorFilter.mode(
                          Colors.transparent, BlendMode.srcATop)
                      : const ColorFilter.mode(
                          Colors.white54, BlendMode.srcATop),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 99,
                        height: 99,
                        decoration: BtnDecoration(hover, true, Colors.black,
                            blurRadious: 10, radio: 15),
                      ),
                      ImagenRectRounded(
                        sombra: false,
                        tam: 100,
                        url: url,
                        radio: 15,
                      )
                    ],
                  ),
                ),
                TextoPer(
                  texto: valorColumna.nombre,
                  tam: 15,
                  align: TextAlign.center,
                  filasTexto: 2,
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(4),
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
                      await context
                          .read<AuxiliarPanelColumnas>()
                          .editarValorColumna(context, valorColumna);
                    } else {
                      await context
                          .read<AuxiliarPanelColumnas>()
                          .eliminarValorColumna(context, valorColumna);
                    }
                  },
                  child: PlantillaFlotante(
                    ancho: 25,
                    altura: 25,
                    constructorContenido: (hover) => Container(
                      width: 25,
                      height: 25,
                      decoration:
                          BtnDecoration(hover, true, DecoColores.rosaOscuro),
                      child: const Icon(
                        Icons.settings,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
            if (valorColumna.estado != estadoSync)
              Align(
                alignment: Alignment.topLeft,

                //ESTADO
                child: Container(
                  width: 25,
                  height: 25,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: DecoColores.rosaOscuro,
                      borderRadius: BorderRadius.circular(35)),
                  child: Icon(
                      size: 20,
                      valorColumna.estado == estadoLocal
                          ? Icons.upload_rounded
                          : valorColumna.estado == estadoServidor
                              ? Icons.download_rounded
                              : null,
                      color: DecoColores.gris),
                ),
              )
          ],
        ),
      ),
    );
  }
}
