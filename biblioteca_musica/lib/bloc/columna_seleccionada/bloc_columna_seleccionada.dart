import 'dart:async';

import 'package:biblioteca_musica/bloc/columna_seleccionada/estado_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/eventos_columna_seleccionada.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocColumnaSeleccionada
    extends Bloc<EventoColumnaSeleccionada, EstadoColumnaSeleccionada> {
  final RepositorioColumnas _repositorioColumnas;

  BlocColumnaSeleccionada(this._repositorioColumnas)
      : super(const EstadoColumnaSeleccionada(null, [])) {
    on<EvSeleccionarColumna>(_onSeleccionarColumna);
    on<EvEscucharValoresColumna>(_onEscucharValoresColumna,
        transformer: restartable());
    on<EvEliminarColumna>(_onEliminarColumna);
    on<EvRenombrarColumna>(_onRenombrarColumna);
    on<EvEliminarValorColumna>(_onEliminarValorColumna);
  }

  FutureOr<void> _onSeleccionarColumna(
      EvSeleccionarColumna event, Emitter<EstadoColumnaSeleccionada> emit) {
    emit(state.copiarCon(nuevaColumna: event.nuevaColumna));
    add(EvEscucharValoresColumna(event.nuevaColumna));
  }

  FutureOr<void> _onEscucharValoresColumna(EvEscucharValoresColumna event,
      Emitter<EstadoColumnaSeleccionada> emit) async {
    await emit.forEach(
        _repositorioColumnas.crearStreamValoresColumna(event.columna),
        onData: (nuevaLista) =>
            state.copiarCon(nuevaListaValoresColumna: nuevaLista));
  }

  FutureOr<void> _onEliminarColumna(
      EvEliminarColumna event, Emitter<EstadoColumnaSeleccionada> emit) {}

  FutureOr<void> _onRenombrarColumna(
      EvRenombrarColumna event, Emitter<EstadoColumnaSeleccionada> emit) {}

  FutureOr<void> _onEliminarValorColumna(
      EvEliminarValorColumna event, Emitter<EstadoColumnaSeleccionada> emit) {
    _repositorioColumnas.eliminarValorColumna(event.valorColumna);
  }
}
