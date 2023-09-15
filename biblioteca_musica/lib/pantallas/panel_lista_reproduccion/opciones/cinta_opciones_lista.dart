import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import '../../../bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'opciones_biblioteca.dart';
import 'opciones_lista_cualquiera.dart';

class CintaOpcionesLista extends StatelessWidget {
  final ModoResponsive modo;
  const CintaOpcionesLista({required this.modo, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlocListaReproduccionSeleccionada,
            EstadoListaReproduccionSelecconada, ListaReproduccionData>(
        selector: (state) => state.listaReproduccionSeleccionada,
        builder: (_, listaSel) {
          return listaSel.id == listaRepBiblioteca.id
              ? OpcionesListaBiblioteca(
                  key: const ValueKey(0),
                  modo: modo,
                )
              : OpcionesListaCualquiera(
                  key: const ValueKey(0),
                  modo: modo,
                );
        });
  }
}
