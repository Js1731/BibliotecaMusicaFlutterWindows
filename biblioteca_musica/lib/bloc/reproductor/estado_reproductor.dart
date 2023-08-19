import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columna_principal.dart';
import 'package:equatable/equatable.dart';

import 'evento_reproductor.dart';

class EstadoReproductor extends Equatable {
  final ListaReproduccionData listaReproduccionReproducida;
  final CancionColumnaPrincipal? cancionReproducida;
  final int progresoReproduccion;
  final double volumen;
  final bool reproduciendo;
  final bool enOrden;

  const EstadoReproductor(
      {this.volumen = 1,
      this.progresoReproduccion = 0,
      this.listaReproduccionReproducida = listaRepBiblioteca,
      this.cancionReproducida,
      this.reproduciendo = false,
      this.enOrden = false});

  @override
  List<Object?> get props => [
        listaReproduccionReproducida,
        cancionReproducida,
        volumen,
        progresoReproduccion,
        reproduciendo,
        enOrden
      ];

  EstadoReproductor copiarCon(
          {ListaReproduccionData? nuevaListaRepReproducida,
          CancionColumnaPrincipal? nuevaCancionReproducida,
          int? progRep,
          double? vol,
          bool? rep,
          bool? enOrd}) =>
      EstadoReproductor(
          progresoReproduccion: progRep ?? progresoReproduccion,
          cancionReproducida: nuevaCancionReproducida ?? cancionReproducida,
          listaReproduccionReproducida:
              nuevaListaRepReproducida ?? listaReproduccionReproducida,
          volumen: vol ?? volumen,
          reproduciendo: rep ?? reproduciendo,
          enOrden: enOrd ?? enOrden);
}
