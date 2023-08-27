import 'dart:async';

import 'package:biblioteca_musica/bloc/dialogo_gestor_columnas_cancion.dart/estado_dialogo_gestor_columnas_cancion.dart';
import 'package:biblioteca_musica/bloc/dialogo_gestor_columnas_cancion.dart/evento_dialogo_gestor_columnas_cancion.dart';
import 'package:biblioteca_musica/repositorios/repositorio_canciones.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:bloc/bloc.dart';

class BlocDialogoGestorColumnasCancion extends Bloc<
    EventoDialogoGestorColumnasCancion, EstadoDialogoGestorColumnasCancion> {
  final RepositorioColumnas _repositorioColumnas;
  final RepositorioCanciones _repositorioCanciones;

  BlocDialogoGestorColumnasCancion(
      this._repositorioColumnas, this._repositorioCanciones)
      : super(const EstadoDialogoGestorColumnasCancion(
            mostrarSelectorValorColumna: false,
            mostrarAgregarColumna: false,
            columnaSel: null,
            mapaColumnas: {})) {
    on<EvEscucharColumnasCancion>(_onEscucharColumnasCancion);
    on<EvSeleccionarColumna>(_onSeleccionarColumna);
    on<EvToggleMostrarSelectorColumna>(_onToggleMostrarSelectorColumna);
    on<EvAsignarValorColumna>(_onAsignarValorColumna);
    on<EvToggleMostrarAgregarColumna>(_onToggleAgregarColumna);
  }

  FutureOr<void> _onEscucharColumnasCancion(EvEscucharColumnasCancion event,
      Emitter<EstadoDialogoGestorColumnasCancion> emit) async {
    await emit.forEach(
        _repositorioColumnas.crearStreamValoresColumnaCancion(event.idCancion),
        onData: (nuevoMapa) => state.copiarCon(nuevoMapaColumna: nuevoMapa));
  }

  FutureOr<void> _onSeleccionarColumna(EvSeleccionarColumna event,
      Emitter<EstadoDialogoGestorColumnasCancion> emit) {
    emit(state.copiarCon(nuevaColumnaSel: event.columnaDataSel));
  }

  FutureOr<void> _onToggleMostrarSelectorColumna(
      EvToggleMostrarSelectorColumna event,
      Emitter<EstadoDialogoGestorColumnasCancion> emit) {
    emit(state.copiarCon(mostrarSelValCol: event.mostrar));
  }

  FutureOr<void> _onAsignarValorColumna(EvAsignarValorColumna event,
      Emitter<EstadoDialogoGestorColumnasCancion> emit) {
    _repositorioCanciones.actValorColumnaCanciones(
        event.idColumna, event.idValorColumna, [event.idCancion]);
  }

  FutureOr<void> _onToggleAgregarColumna(EvToggleMostrarAgregarColumna event,
      Emitter<EstadoDialogoGestorColumnasCancion> emit) {
    emit(state.copiarCon(mostrarAgCol: event.mostrar));
  }
}
