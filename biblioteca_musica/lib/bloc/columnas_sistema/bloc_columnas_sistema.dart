import 'dart:async';

import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:bloc/bloc.dart';

import 'estado_columnas_sistema.dart';
import 'eventos_columnas_sistema.dart';

class BlocColumnasSistema
    extends Bloc<EventoColumnasSistema, EstadoColumnasSistema> {
  final RepositorioColumnas _repositorioColumnas;

  BlocColumnasSistema(this._repositorioColumnas)
      : super(const EstadoColumnasSistema([])) {
    on<EvEscucharColumnasSistema>(_onEscucharColumnasSistema);
    on<EvAgregarColumna>(_onAgregarColumna);
    on<EvAgregarValorColumna>(_onAgregarValorColumna);
  }

  void _onEscucharColumnasSistema(EvEscucharColumnasSistema event,
      Emitter<EstadoColumnasSistema> emit) async {
    await emit.forEach(_repositorioColumnas.crearStreamColumnas(),
        onData: (nuevasColumnas) => EstadoColumnasSistema(nuevasColumnas));
  }

  void _onAgregarColumna(
      EvAgregarColumna event, Emitter<EstadoColumnasSistema> emit) {
    _repositorioColumnas.agregarColumna(event.nombreNuevaColumna);
  }

  FutureOr<void> _onAgregarValorColumna(
      EvAgregarValorColumna event, Emitter<EstadoColumnasSistema> emit) {
    _repositorioColumnas.agregarValorColumna(
        event.nombreValorColumna, event.idColumna, event.urlImagen);
  }
}
