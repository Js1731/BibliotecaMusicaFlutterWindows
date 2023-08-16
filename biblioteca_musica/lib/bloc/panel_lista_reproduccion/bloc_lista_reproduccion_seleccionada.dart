import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/bloc/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/repositorios/repositorio_canciones.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:biblioteca_musica/repositorios/repositorio_listas_reproduccion.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class BlocListaReproduccionSeleccionada extends Bloc<
    EventoListaReproduccionSeleccionada, EstadoListaReproduccionSelecconada> {
  final RepositorioCanciones _repositorioCanciones;
  final RepositorioColumnas _repositorioColumna;
  final RepositorioListasReproduccion _repositorioListasReproduccion;

  BlocListaReproduccionSeleccionada(this._repositorioCanciones,
      this._repositorioColumna, this._repositorioListasReproduccion)
      : super(const EstadoListaReproduccionSelecconada()) {
    on<EvSeleccionarLista>(_onSeleccionarLista);
    on<EvEscucharCancionesListaRep>(_onEscucharCancionesListaRep);
    on<EvEscucharColumnasListaRep>(_onEscucharColumnasListaRep);
    on<EvToggleSeleccionarTodo>(_onToggleSeleccionarTodo);
    on<EvImportarCanciones>(_onImportarCanciones);
    on<EvRenombrarLista>(_onRenombrarLista);
    on<EvEliminarLista>(_onEliminarLista);
    on<EvAsignarCancionesALista>(_onAsignarCancionesLista);
    on<EvOrdenarListaPorColumna>(_onOrdenarPorColumna);
    on<EvToggleSelCancion>(_onToggleSelCancion);
    on<EvActColumnasLista>(_onActColumnaLista);
    on<EvActValorColumnaCanciones>(_onActValorColumnaCancion);
  }

  void ordernarListaCanciones(
      List<CancionColumnas> lista, int? idColumnaOrden, bool ordenAscendente) {
    if (idColumnaOrden == null) return;

    if (idColumnaOrden == -1) {
      lista.sort((cancionA, cancionB) =>
          cancionA.nombre.compareTo(cancionB.nombre) *
          (ordenAscendente ? 1 : -1));
    } else if (idColumnaOrden == -2) {
      lista.sort((cancionA, cancionB) =>
          cancionA.duracion.compareTo(cancionB.duracion) *
          (ordenAscendente ? 1 : -1));
    } else {
      lista.sort((cancionA, cancionB) {
        final columnaA =
            cancionA.mapaColumnas[idColumnaOrden]?["valor_columna"];
        final columnaB =
            cancionB.mapaColumnas[idColumnaOrden]?["valor_columna"];

        if (columnaA == null || columnaB == null) return 1;

        return columnaA.compareTo(columnaB) * (ordenAscendente ? 1 : -1);
      });
    }
  }

  ///Cambia la lista seleccionada
  ///Crea un stream para todas las canciones de esta lista
  ///Crea un stream para las columnas de esta lista
  ///Actualiza el mapa para las canciones
  void _onSeleccionarLista(EvSeleccionarLista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    emit(state.copiarCon(nuevaListaSel: evento.listaSeleccionada));
    add(EvEscucharCancionesListaRep(
        evento.listaSeleccionada, state.lstColumnas));
    add(EvEscucharColumnasListaRep(evento.listaSeleccionada));
  }

  void _onEscucharCancionesListaRep(EvEscucharCancionesListaRep evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    ///BIBLIOTECA
    if (evento.listaSeleccionada.id == listaRepBiblioteca.id) {
      await emit.forEach(_repositorioCanciones.crearStreamCancionesBiblioteca(),
          onData: (nuevaLista) {
        final nuevoMapa = {for (var cancion in nuevaLista) cancion.id: false};
        return state.copiarCon(
            nuevalistaCanciones: nuevaLista,
            nuevoMapaCancionesSeleccionadas: nuevoMapa);
      });

      ///CUALQUIER LISTA
    } else {
      await emit.forEach(
          _repositorioCanciones.crearStreamCancionesLista(
              evento.listaSeleccionada.id, evento.lstColumnas),
          onData: (nuevaLista) {
        ordernarListaCanciones(
            nuevaLista,
            state.listaReproduccionSeleccionada.idColumnaOrden,
            state.listaReproduccionSeleccionada.ordenAscendente);
        final nuevoMapa = {for (var cancion in nuevaLista) cancion.id: false};
        return state.copiarCon(
            nuevalistaCanciones: nuevaLista,
            nuevoMapaCancionesSeleccionadas: nuevoMapa);
      });
    }
  }

  void _onEscucharColumnasListaRep(EvEscucharColumnasListaRep evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    await emit.forEach(
        _repositorioColumna.crearStreamColumnasListaSel(
            evento.listaSeleccionada.id), onData: (nuevaLista) {
      add(EvEscucharCancionesListaRep(
          state.listaReproduccionSeleccionada, nuevaLista));
      return state.copiarCon(nuevaListaColumnas: nuevaLista);
    });
  }

  void _onOrdenarPorColumna(EvOrdenarListaPorColumna evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    _repositorioListasReproduccion.actOrdenColumna(
        evento.idColumnaOrden, state.listaReproduccionSeleccionada.id);
    emit(state.copiarCon(
        nuevaListaSel: ListaReproduccionData(
            id: state.listaReproduccionSeleccionada.id,
            nombre: state.listaReproduccionSeleccionada.nombre,
            ordenAscendente: evento.idColumnaOrden ==
                    state.listaReproduccionSeleccionada.idColumnaOrden
                ? !state.listaReproduccionSeleccionada.ordenAscendente
                : state.listaReproduccionSeleccionada.ordenAscendente,
            idColumnaOrden: evento.idColumnaOrden,
            idColumnaPrincipal:
                state.listaReproduccionSeleccionada.idColumnaPrincipal)));
    add(EvEscucharCancionesListaRep(
        state.listaReproduccionSeleccionada, state.lstColumnas));
  }

  void _onToggleSelCancion(EvToggleSelCancion evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    final mapa = state.mapaCancionesSeleccionadas;

    final nuevoMapa = Map<int, bool>.from(mapa);
    nuevoMapa[evento.idCancion] = !nuevoMapa[evento.idCancion]!;

    emit(state.copiarCon(nuevoMapaCancionesSeleccionadas: nuevoMapa));
  }

  void _onToggleSeleccionarTodo(EvToggleSeleccionarTodo evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    final nuevoMapa = Map<int, bool>.from(state.mapaCancionesSeleccionadas);
    final cantCanSel = state.obtCancionesSeleccionadas().length;
    final cantCanTotal = state.obtCantidadCancionesTotal();

    if (cantCanSel == 0) {
      nuevoMapa.updateAll((key, value) => true);
    } else if (cantCanSel == cantCanTotal) {
      nuevoMapa.updateAll((key, value) => false);
    } else if (cantCanSel != 0) {
      nuevoMapa.updateAll((key, value) => true);
    }

    emit(state.copiarCon(nuevoMapaCancionesSeleccionadas: nuevoMapa));
  }

  void _onImportarCanciones(EvImportarCanciones evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    _repositorioCanciones.importarCancionesLista(
        evento.lstCanciones, state.listaReproduccionSeleccionada.id);
  }

  void _onRenombrarLista(EvRenombrarLista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {}

  void _onEliminarLista(EvEliminarLista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {}

  void _onAsignarCancionesLista(EvAsignarCancionesALista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    await _repositorioCanciones.asignarCancionesListaRep(
        state.obtCancionesSeleccionadas(), evento.idListaRep);
  }

  void _onActColumnaLista(EvActColumnasLista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    await _repositorioListasReproduccion.actColumnasListaRep(
        evento.idColumnas, state.listaReproduccionSeleccionada.id);
  }

  void _onActValorColumnaCancion(EvActValorColumnaCanciones evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    await _repositorioCanciones.actValorColumnaCanciones(evento.idColumna,
        evento.idValorColumna, state.obtCancionesSeleccionadas());
  }
}
