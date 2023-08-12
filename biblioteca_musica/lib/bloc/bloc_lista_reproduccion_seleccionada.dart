import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/bloc_reproductor.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//-------------------EVENTOS--------------------------------------------------

class EventoListaReproduccionSeleccionada extends Equatable {
  @override
  List<Object?> get props => [];
}

class EvListaRepSelSeleccionarLista
    extends EventoListaReproduccionSeleccionada {
  final ListaReproduccionData listaSeleccionada;

  EvListaRepSelSeleccionarLista(this.listaSeleccionada);
}

class EvToogleSeleccionarTodo extends EventoListaReproduccionSeleccionada {
  final bool todoSel;

  EvToogleSeleccionarTodo(this.todoSel);
}

class EvImportarCanciones extends EventoListaReproduccionSeleccionada {}

class EvRenombrarLista extends EventoListaReproduccionSeleccionada {}

class EvEliminarLista extends EventoListaReproduccionSeleccionada {}

class EvAsignarCancionesALista extends EventoListaReproduccionSeleccionada {}

//-------------------ESTADO----------------------------------------------------
class EstadoListaReproduccionSelecconada extends Equatable {
  final ListaReproduccionData listaReproduccionSeleccionada;
  final List<CancionData> listaCanciones;
  final Map<int, bool> mapaCancionesSeleccionadas;
  final List<ColumnaData> lstColumnas;

  const EstadoListaReproduccionSelecconada(
      {this.listaCanciones = const [],
      this.listaReproduccionSeleccionada = listaRepBiblioteca,
      this.mapaCancionesSeleccionadas = const {},
      this.lstColumnas = const []});

  EstadoListaReproduccionSelecconada copiarCon(
      {ListaReproduccionData? nuevaListaSel}) {
    final nuevoEstado = EstadoListaReproduccionSelecconada(
      listaReproduccionSeleccionada:
          nuevaListaSel ?? listaReproduccionSeleccionada,
    );
    return nuevoEstado;
  }

  List<int> obtCancionesSeleccionadas() => [];

  int obtCantidadCancionesSeleccionadas() => obtCancionesSeleccionadas().length;
  int obtCantidadCancionesTotal() => listaCanciones.length;

  @override
  List<Object?> get props => [listaReproduccionSeleccionada];
}

//--------------------BLOC---------------------------------------------------
class BlocListaReproduccionSeleccionada extends Bloc<
    EventoListaReproduccionSeleccionada, EstadoListaReproduccionSelecconada> {
  BlocListaReproduccionSeleccionada()
      : super(const EstadoListaReproduccionSelecconada()) {
    on<EvListaRepSelSeleccionarLista>(_onSeleccionarLista);
    on<EvToogleSeleccionarTodo>(_onToogleSeleccionarTodo);
    on<EvImportarCanciones>(_onImportarCanciones);
    on<EvRenombrarLista>(_onRenombrarLista);
    on<EvEliminarLista>(_onEliminarLista);
    on<EvAsignarCancionesALista>(_onAsignarCancionesLista);
  }

  void _onSeleccionarLista(EvListaRepSelSeleccionarLista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    emit(state.copiarCon(nuevaListaSel: evento.listaSeleccionada));
  }

  void _onToogleSeleccionarTodo(EvToogleSeleccionarTodo evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {}

  void _onImportarCanciones(EvImportarCanciones evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {}

  void _onRenombrarLista(EvRenombrarLista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {}

  void _onEliminarLista(EvEliminarLista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {}

  void _onAsignarCancionesLista(EvAsignarCancionesALista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {}
}
