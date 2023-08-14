import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/repositorios/repositorio_reproductor.dart';
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

class EvEscucharReproductor extends EventoReproductor {}

//------------------------ESTADO-----------------------------------------------
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

//---------------------------BLOC----------------------------------------------
class BlocReproductor extends Bloc<EventoReproductor, EstadoReproductor> {
  final RepositorioReproductor _repositorioReproductor;

  BlocReproductor(this._repositorioReproductor)
      : super(const EstadoReproductor()) {
    on<EvReproducirOrden>(_onReproducirOrden);
    on<EvReproducirAzar>(_onReproducirAzar);
    on<EvReproducirCancion>(_onReproducirCancion);
    on<EvEscucharReproductor>(_onEscucharReproductor);
  }

  void _onEscucharReproductor(
      EvEscucharReproductor evento, Emitter<EstadoReproductor> emit) async {
    final (streamCancionRep, streamListaRep) =
        _repositorioReproductor.escucharReproductor();

    ///ESCUCHAR CAMBIOS EN LA CANCION REPRODUCIDA
    await emit.forEach(streamCancionRep,
        onData: (nuevaCancion) =>
            state.copiarCon(nuevaCancionReproducida: nuevaCancion));

    ///ESCUCHAR CAMBIOS EN LA LISTA REPRODUCIDA
    emit.forEach(streamListaRep,
        onData: (nuevaLista) =>
            state.copiarCon(nuevaListaRepReproducida: nuevaLista));
  }

  void _onReproducirOrden(
      EvReproducirOrden evento, Emitter<EstadoReproductor> emit) async {
    await _repositorioReproductor.reproducirListaOrden(evento.lista);
  }

  Future<void> _onReproducirAzar(
      EvReproducirAzar evento, Emitter<EstadoReproductor> emit) async {
    await _repositorioReproductor.reproducirListaAzar(evento.lista);
  }

  void _onReproducirCancion(
      EvReproducirCancion evento, Emitter<EstadoReproductor> emit) {}
}
