import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//------------------------EVENTO-----------------------------------------------
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
  final ListaReproduccionData lista;

  EvReproducirCancion(this.lista);
}

//------------------------ESTADO-----------------------------------------------
class EstadoReproductor extends Equatable {
  final ListaReproduccionData listaReproduccionReproducida;
  final CancionData? cancionReproducida;

  const EstadoReproductor(
      {this.listaReproduccionReproducida = listaRepBiblioteca,
      this.cancionReproducida});

  @override
  List<Object?> get props => [];
}

//---------------------------BLOC----------------------------------------------
class BlocReproductor extends Bloc<EventoReproductor, EstadoReproductor> {
  BlocReproductor() : super(const EstadoReproductor()) {
    on<EvReproducirOrden>(_onReproducirOrden);
    on<EvReproducirAzar>(_onReproducirAzar);
    on<EvReproducirCancion>(_onReproducirCancion);
  }

  void _onReproducirOrden(
      EvReproducirOrden evento, Emitter<EstadoReproductor> emit) {}

  void _onReproducirAzar(
      EvReproducirAzar evento, Emitter<EstadoReproductor> emit) {}

  void _onReproducirCancion(
      EvReproducirCancion evento, Emitter<EstadoReproductor> emit) {}
}
