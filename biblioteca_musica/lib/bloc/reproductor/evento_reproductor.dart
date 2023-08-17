import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

const ListaReproduccionData listaRepBiblioteca =
    ListaReproduccionData(id: 0, nombre: "Biblioteca", ordenAscendente: true);

class EventoReproductor extends Equatable {
  @override
  List<Object?> get props => [];
}

class EvReproducirOrden extends EventoReproductor {
  final ListaReproduccionData lista;

  EvReproducirOrden(this.lista);
}

class EvReproducirAzar extends EventoReproductor {
  final ListaReproduccionData lista;

  EvReproducirAzar(this.lista);
}

class EvReproducirCancion extends EventoReproductor {
  final CancionData cancion;
  final ListaReproduccionData listaRep;

  EvReproducirCancion(this.cancion, this.listaRep);
}

class EvEscucharReproductor extends EventoReproductor {}
