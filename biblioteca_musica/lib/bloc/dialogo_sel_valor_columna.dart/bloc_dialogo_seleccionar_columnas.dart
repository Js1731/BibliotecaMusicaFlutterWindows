import 'dart:async';

import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/estado_dialogo_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/eventos_dialogo_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocDialogoSeleccionarValorColumna extends Bloc<
    EventoDialogoSeleccionarValorColumna,
    EstadoBlocDialogoSeleccionarValorColumna> {
  final RepositorioColumnas _repositorioColumnas;
  final ColumnaData _columna;

  BlocDialogoSeleccionarValorColumna(this._repositorioColumnas, this._columna)
      : super(const EstadoBlocDialogoSeleccionarValorColumna(
            mostrarPanelAgregarColumna: false,
            criterio: "",
            sugerenciasValorColumna: [],
            valorColumnaSeleccionado: null)) {
    on<EvBuscarSugerencias>(_onBuscarSugerencias, transformer: restartable());
    on<EvSeleccionarValorColumna>(_onSeleccionarValorColumna);
    on<EvTogglePanelAgregarColumna>(_onTogglePanelAgregarColumna);
  }

  FutureOr<void> _onBuscarSugerencias(EvBuscarSugerencias event,
      Emitter<EstadoBlocDialogoSeleccionarValorColumna> emit) async {
    emit(state.copiarCon(crit: event.criterio));
    await emit.forEach(
        _repositorioColumnas.crearStreamValoresColumnaSugerencias(
            _columna, event.criterio, state.valorColumnaSeleccionado?.id),
        onData: (nuevasSugerencias) {
      if (state.valorColumnaSeleccionado?.id != null) {
        nuevasSugerencias.removeWhere(
            (element) => element.id == state.valorColumnaSeleccionado!.id);
        nuevasSugerencias.insert(0, state.valorColumnaSeleccionado!);
      }

      return state.copiarCon(sugValorCol: nuevasSugerencias);
    });
  }

  FutureOr<void> _onSeleccionarValorColumna(EvSeleccionarValorColumna event,
      Emitter<EstadoBlocDialogoSeleccionarValorColumna> emit) {
    emit(state.copiarCon(valorColSel: event.valorColSel));
    add(EvBuscarSugerencias(state.criterio));
  }

  FutureOr<void> _onTogglePanelAgregarColumna(EvTogglePanelAgregarColumna event,
      Emitter<EstadoBlocDialogoSeleccionarValorColumna> emit) {
    emit(state.copiarCon(mostrarAgCol: event.mostrar));
  }
}
