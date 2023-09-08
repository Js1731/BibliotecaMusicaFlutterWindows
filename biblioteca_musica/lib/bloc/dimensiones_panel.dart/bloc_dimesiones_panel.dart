import 'dart:async';

import 'package:biblioteca_musica/bloc/dimensiones_panel.dart/estado_dimensiones_panel.dart';
import 'package:biblioteca_musica/bloc/dimensiones_panel.dart/evento_dimensiones_panel.dart';
import 'package:bloc/bloc.dart';

class BlocDimensionesPanel
    extends Bloc<EventoDimensionesPanel, EstadoDimensionesPanel> {
  BlocDimensionesPanel(super.initialState) {
    on<EvCambiarAncho>(_onCambiarAncho);
    on<EvExpandirAncho>(_onExpandirAncho);
    on<EvContraerAncho>(_onContraerAncho);
  }

  FutureOr<void> _onCambiarAncho(
      EvCambiarAncho event, Emitter<EstadoDimensionesPanel> emit) {
    emit(state.copiarCon(an: event.nuevoAncho));
  }

  FutureOr<void> _onExpandirAncho(
      EvExpandirAncho event, Emitter<EstadoDimensionesPanel> emit) {
    emit(state.copiarCon(an: state.ancho + event.aumento));
  }

  FutureOr<void> _onContraerAncho(
      EvContraerAncho event, Emitter<EstadoDimensionesPanel> emit) {
    emit(state.copiarCon(an: state.ancho - event.reduccion));
  }
}
