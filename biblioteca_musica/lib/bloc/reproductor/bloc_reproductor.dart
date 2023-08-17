import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/repositorios/repositorio_reproductor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      EvReproducirCancion evento, Emitter<EstadoReproductor> emit) {
    _repositorioReproductor.reproducirCancion(evento.cancion, evento.listaRep);
  }
}
