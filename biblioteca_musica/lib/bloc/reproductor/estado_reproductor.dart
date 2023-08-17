import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

import 'evento_reproductor.dart';

class EstadoReproductor extends Equatable {
  final ListaReproduccionData listaReproduccionReproducida;
  final CancionData? cancionReproducida;

  const EstadoReproductor(
      {this.listaReproduccionReproducida = listaRepBiblioteca,
      this.cancionReproducida});

  @override
  List<Object?> get props => [listaReproduccionReproducida, cancionReproducida];

  EstadoReproductor copiarCon(
          {ListaReproduccionData? nuevaListaRepReproducida,
          CancionData? nuevaCancionReproducida}) =>
      EstadoReproductor(
          cancionReproducida: nuevaCancionReproducida ?? cancionReproducida,
          listaReproduccionReproducida:
              nuevaListaRepReproducida ?? listaReproduccionReproducida);
}
