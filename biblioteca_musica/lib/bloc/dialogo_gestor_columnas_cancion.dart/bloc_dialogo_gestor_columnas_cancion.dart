import 'dart:async';

import 'package:biblioteca_musica/bloc/dialogo_gestor_columnas_cancion.dart/estado_dialogo_gestor_columnas_cancion.dart';
import 'package:biblioteca_musica/bloc/dialogo_gestor_columnas_cancion.dart/evento_dialogo_gestor_columnas_cancion.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:bloc/bloc.dart';

class BlocDialogoGestorColumnasCancion extends Bloc<
    EventoDialogoGestorColumnasCancion, EstadoDialogoGestorColumnasCancion> {
  final RepositorioColumnas _repositorioColumnas;

  BlocDialogoGestorColumnasCancion(this._repositorioColumnas)
      : super(const EstadoDialogoGestorColumnasCancion({})) {
    on<EvEscucharColumnasCancion>(_onEscucharColumnasCancion);
  }

  FutureOr<void> _onEscucharColumnasCancion(EvEscucharColumnasCancion event,
      Emitter<EstadoDialogoGestorColumnasCancion> emit) async {
    await emit.forEach(
        _repositorioColumnas.crearStreamValoresColumnaCancion(event.idCancion),
        onData: (nuevaData) => EstadoDialogoGestorColumnasCancion(nuevaData));
  }
}
