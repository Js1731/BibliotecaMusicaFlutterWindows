import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auxiliar_lista_reproduccion.dart';

class BtnImportarCanciones extends BotonCintaOpciones {
  BtnImportarCanciones({required ModoResponsive modoResponsive, super.key})
      : super(
            icono: Icons.folder_copy,
            texto: "Importar Canciones",
            modoResponsive: modoResponsive,
            onPressed: (context) async {
              await context
                  .read<AuxiliarListaReproduccion>()
                  .importarCanciones(context);
            });
}
