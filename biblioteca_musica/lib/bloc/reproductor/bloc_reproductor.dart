import 'dart:async';

import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/repositorios/repositorio_reproductor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//---------------------------BLOC----------------------------------------------
class BlocReproductor extends Bloc<EventoReproductor, EstadoReproductor> {
  final RepositorioReproductor _repositorioReproductor;

  BlocReproductor(this._repositorioReproductor)
      : super(const EstadoReproductor()) {
    on<EvEscucharCancionReproducida>(_onEscucharCancionReproducida);
    on<EvEscucharListaReproducida>(_onEscucharListaReproducida);
    on<EvEscucharProgresoReproduccion>(_onEscucharProgresoReproduccion);
    on<EvEscucharEnOrden>(_onEscucharEnOrden);
    on<EvEscucharReproductor>(_onEscucharReproductor);
    on<EvEscucharReproduciendo>(_onEscucharReproduciendo);
    on<EvCambiarProgreso>(_onCambiarProgreso);
    on<EvEscucharVolumen>(_onEvEscucharVolumen);
    on<EvCambiarVolumen>(_onEvCambiarVolumen);
    on<EvRegresarCancion>(_onEvRegresarCancion);
    on<EvRegresar10s>(_onRegresar10s);
    on<EvTogglePausa>(_onTogglePausa);
    on<EvAvanzar10s>(_onAvanzar10s);
    on<EvAvanzarCancion>(_onAvanzarCancion);
    on<EvReproducirListaOrden>(_onReproducirListaOrden);
    on<EvReproducirListaAzar>(_onReproducirListaAzar);
    on<EvReproducirCancion>(_onReproducirCancion);
  }

  void _onEscucharReproductor(
      EvEscucharReproductor evento, Emitter<EstadoReproductor> emit) {
    add(EvEscucharCancionReproducida());
    add(EvEscucharListaReproducida());
    add(EvEscucharProgresoReproduccion());
    add(EvEscucharEnOrden());
    add(EvEscucharVolumen());
    add(EvEscucharReproduciendo());
  }

  void _onEscucharCancionReproducida(EvEscucharCancionReproducida evento,
      Emitter<EstadoReproductor> emit) async {
    ///ESCUCHAR CAMBIOS EN LA CANCION REPRODUCIDA
    await emit.forEach(_repositorioReproductor.escucharCancionReproducida(),
        onData: (nuevaCancion) =>
            state.copiarCon(nuevaCancionReproducida: nuevaCancion));
  }

  void _onEscucharListaReproducida(
      EvEscucharListaReproducida event, Emitter<EstadoReproductor> emit) async {
    await emit.forEach(_repositorioReproductor.escucharListaReproducida(),
        onData: (nuevaLista) =>
            state.copiarCon(nuevaListaRepReproducida: nuevaLista));
  }

  void _onEscucharProgresoReproduccion(EvEscucharProgresoReproduccion event,
      Emitter<EstadoReproductor> emit) async {
    await emit.forEach(_repositorioReproductor.escucharProgresoReproduccion(),
        onData: (progreso) => state.copiarCon(progRep: progreso));
  }

  void _onEscucharEnOrden(
      EvEscucharEnOrden event, Emitter<EstadoReproductor> emit) async {
    await emit.forEach(_repositorioReproductor.escucharEnOrden(),
        onData: (enOrden) => state.copiarCon(enOrd: enOrden));
  }

  void _onEscucharReproduciendo(
      EvEscucharReproduciendo evento, Emitter<EstadoReproductor> emit) async {
    await emit.forEach(_repositorioReproductor.escucharReproduciendo(),
        onData: (reproduciendo) => state.copiarCon(rep: reproduciendo));
  }

  void _onCambiarProgreso(
      EvCambiarProgreso event, Emitter<EstadoReproductor> emit) {
    _repositorioReproductor.cambiarProgreso(event.nuevoProgreso);
  }

  void _onEvEscucharVolumen(
      EvEscucharVolumen event, Emitter<EstadoReproductor> emit) async {
    await emit.forEach(_repositorioReproductor.escucharVolumen(),
        onData: (nuevoVolumen) => state.copiarCon(vol: nuevoVolumen));
  }

  void _onEvCambiarVolumen(
      EvCambiarVolumen event, Emitter<EstadoReproductor> emit) {
    _repositorioReproductor.cambiarVolumen(event.nuevoVolumen);
  }

  void _onEvRegresarCancion(
      EvRegresarCancion event, Emitter<EstadoReproductor> emit) {
    if (state.cancionReproducida != null) {
      _repositorioReproductor.regresarCancion();
    }
  }

  void _onRegresar10s(EvRegresar10s event, Emitter<EstadoReproductor> emit) {
    if (state.cancionReproducida != null) {
      _repositorioReproductor.regresar10s();
    }
  }

  void _onTogglePausa(EvTogglePausa event, Emitter<EstadoReproductor> emit) {
    if (state.cancionReproducida != null) {
      _repositorioReproductor.togglePausar();
    }
  }

  void _onAvanzar10s(EvAvanzar10s event, Emitter<EstadoReproductor> emit) {
    if (state.cancionReproducida != null) {
      _repositorioReproductor.avanzar10s();
    }
  }

  void _onAvanzarCancion(
      EvAvanzarCancion event, Emitter<EstadoReproductor> emit) {
    if (state.cancionReproducida != null) {
      _repositorioReproductor.avanzarCancion();
    }
  }

  FutureOr<void> _onReproducirListaOrden(
      EvReproducirListaOrden event, Emitter<EstadoReproductor> emit) {
    _repositorioReproductor.reproducirListaOrden(
        event.lista, event.listaCancionesActuales);
  }

  FutureOr<void> _onReproducirListaAzar(
      EvReproducirListaAzar event, Emitter<EstadoReproductor> emit) {
    _repositorioReproductor.reproducirListaAzar(
        event.lista, event.listaCancionesActuales);
  }

  FutureOr<void> _onReproducirCancion(
      EvReproducirCancion event, Emitter<EstadoReproductor> emit) {
    _repositorioReproductor.reproducirCancion(
        event.cancion, event.lista, event.listaCancionesActuales);
  }
}
