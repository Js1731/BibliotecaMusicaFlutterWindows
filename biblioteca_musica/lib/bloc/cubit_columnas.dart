import 'dart:async';

import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class EventoColumnasSistema extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class EvEscucharColumnasSistema extends EventoColumnasSistema {}

class EstadoColumnasSistema extends Equatable {
  final List<ColumnaData> columnas;

  const EstadoColumnasSistema(this.columnas);

  @override
  List<Object?> get props => [columnas];
}

class BlocColumnasSistema
    extends Bloc<EventoColumnasSistema, EstadoColumnasSistema> {
  final RepositorioColumnas _repositorioColumnas;

  BlocColumnasSistema(this._repositorioColumnas)
      : super(const EstadoColumnasSistema([])) {
    on<EvEscucharColumnasSistema>(_onEscucharColumnasSistema);
  }

  FutureOr<void> _onEscucharColumnasSistema(EvEscucharColumnasSistema event,
      Emitter<EstadoColumnasSistema> emit) async {
    await emit.forEach(_repositorioColumnas.crearStreamColumnas(),
        onData: (nuevasColumnas) => EstadoColumnasSistema(nuevasColumnas));
  }
}
