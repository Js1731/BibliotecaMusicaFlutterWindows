import 'dart:async';

import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/repositorios/repositorio_canciones.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:biblioteca_musica/repositorios/repositorio_listas_reproduccion.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocListaReproduccionSeleccionada extends Bloc<
    EventoListaReproduccionSeleccionada, EstadoListaReproduccionSelecconada> {
  final RepositorioCanciones _repositorioCanciones;
  final RepositorioColumnas _repositorioColumna;
  final RepositorioListasReproduccion _repositorioListasReproduccion;

  BlocListaReproduccionSeleccionada(this._repositorioCanciones,
      this._repositorioColumna, this._repositorioListasReproduccion)
      : super(const EstadoListaReproduccionSelecconada()) {
    on<EvIniciar>(_onIniciar);
    on<EvSeleccionarLista>(_onSeleccionarLista);
    on<EvEscucharCancionesListaRep>(_onEscucharCancionesListaRep,
        transformer: restartable());
    on<EvEscucharColumnasListaRep>(_onEscucharColumnasListaRep,
        transformer: restartable());
    on<EvToggleSeleccionarTodo>(_onToggleSeleccionarTodo);
    on<EvImportarCanciones>(_onImportarCanciones);
    on<EvRenombrarLista>(_onRenombrarLista);
    on<EvEliminarLista>(_onEliminarLista);
    on<EvAsignarCancionesALista>(_onAsignarCancionesLista);
    on<EvOrdenarListaPorColumna>(_onOrdenarPorColumna);
    on<EvToggleSelCancion>(_onToggleSelCancion);
    on<EvActColumnasLista>(_onActColumnaLista, transformer: restartable());
    on<EvActValorColumnaCanciones>(_onActValorColumnaCancion);
    on<EvRecortarNombresCancionesSeleccionadas>(
        _onRecortarNombresCancionesSeleccionadas);
    on<EvEliminarCancionesLista>(_eliminarCancionesLista);
    on<EvEliminarCancionesTotalmente>(_eliminarCancionesTotalmente);
    on<EvRenombrarCancion>(_renombrarCancion);
    on<EvActValoresColumnaCancionUnica>(_onActValoresColumnaCancionUnica);
    on<EvActColumnaPrincipal>(_onActColumnaPrincipal);
  }

  ///Cambia la lista seleccionada
  ///Crea un stream para todas las canciones de esta lista
  ///Crea un stream para las columnas de esta lista
  ///Actualiza el mapa para las canciones
  void _onSeleccionarLista(EvSeleccionarLista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    emit(state.copiarCon(nuevaListaSel: evento.listaSeleccionada));
    add(EvEscucharCancionesListaRep(state.lstColumnas));
    add(EvEscucharColumnasListaRep(evento.listaSeleccionada));
  }

  void _onEscucharCancionesListaRep(EvEscucharCancionesListaRep evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    ///BIBLIOTECA
    if (state.listaReproduccionSeleccionada.id == listaRepBiblioteca.id) {
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
              state.listaReproduccionSeleccionada, evento.lstColumnas),
          onData: (nuevaLista) {
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
      add(EvEscucharCancionesListaRep(nuevaLista));
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
    add(EvEscucharCancionesListaRep(state.lstColumnas));
  }

  void _onToggleSelCancion(EvToggleSelCancion evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    final mapa = state.mapaCancionesSeleccionadas;

    final nuevoMapa = Map<int, bool>.from(mapa);
    nuevoMapa[evento.idCancion] = !nuevoMapa[evento.idCancion]!;
    final seleccionandoCanciones =
        nuevoMapa.values.where((element) => element == true).isNotEmpty;

    emit(state.copiarCon(
        nuevoMapaCancionesSeleccionadas: nuevoMapa,
        selCanciones: seleccionandoCanciones));
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

    final seleccionandoCanciones =
        nuevoMapa.values.where((element) => element == true).isNotEmpty;

    emit(state.copiarCon(
        nuevoMapaCancionesSeleccionadas: nuevoMapa,
        selCanciones: seleccionandoCanciones));
  }

  void _onImportarCanciones(EvImportarCanciones evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    _repositorioCanciones.importarCancionesLista(
        evento.lstCanciones, state.listaReproduccionSeleccionada.id);
  }

  void _onRenombrarLista(EvRenombrarLista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    _repositorioListasReproduccion.renombrarLista(
        state.listaReproduccionSeleccionada.id, evento.nuevoNombre);

    final lista = state.listaReproduccionSeleccionada;
    final nuevaLista = ListaReproduccionData(
        id: lista.id,
        nombre: evento.nuevoNombre,
        ordenAscendente: lista.ordenAscendente,
        idColumnaOrden: lista.idColumnaOrden,
        idColumnaPrincipal: lista.idColumnaPrincipal);

    emit(state.copiarCon(nuevaListaSel: nuevaLista));
  }

  Future<void> _onEliminarLista(EvEliminarLista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    await _repositorioListasReproduccion
        .eliminarLista(state.listaReproduccionSeleccionada.id);

    add(EvSeleccionarLista(listaRepBiblioteca));
  }

  void _onAsignarCancionesLista(EvAsignarCancionesALista evento,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    _repositorioCanciones.asignarCancionesListaRep(
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

  void _onRecortarNombresCancionesSeleccionadas(
      EvRecortarNombresCancionesSeleccionadas event,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    _repositorioCanciones.recortarNombresCanciones(
        event.filtro, state.obtCancionesSelecionadasCompleta());
  }

  void _eliminarCancionesLista(EvEliminarCancionesLista event,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    _repositorioCanciones.eliminarCancionesLista(
        state.listaReproduccionSeleccionada.id, event.canciones);
  }

  void _eliminarCancionesTotalmente(EvEliminarCancionesTotalmente event,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    _repositorioCanciones.eliminarCancionesTotalmente(event.canciones);
  }

  void _renombrarCancion(EvRenombrarCancion event,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    await _repositorioCanciones.renombrarCancion(
        event.idCancion, event.nuevoNombre);
  }

  void _onActValoresColumnaCancionUnica(EvActValoresColumnaCancionUnica event,
      Emitter<EstadoListaReproduccionSelecconada> emit) {
    _repositorioCanciones.actValoresColumnaCancionUnica(
        event.idCancion, event.lstValorColumna);
  }

  void _onActColumnaPrincipal(EvActColumnaPrincipal event,
      Emitter<EstadoListaReproduccionSelecconada> emit) async {
    _repositorioListasReproduccion.actColumnaPrincipal(
        event.idColumna, state.listaReproduccionSeleccionada.id);

    emit(state.copiarCon(
        nuevaListaSel: ListaReproduccionData(
            id: state.listaReproduccionSeleccionada.id,
            nombre: state.listaReproduccionSeleccionada.nombre,
            ordenAscendente:
                state.listaReproduccionSeleccionada.ordenAscendente,
            idColumnaOrden: state.listaReproduccionSeleccionada.idColumnaOrden,
            idColumnaPrincipal: event.idColumna)));
  }

  FutureOr<void> _onIniciar(
      EvIniciar event, Emitter<EstadoListaReproduccionSelecconada> emit) async {
    final listaRepInicial = await _repositorioListasReproduccion
        .obtListaReproduccionInicial(await obtUltimaListaRep() ?? 0);

    add(EvSeleccionarLista(listaRepInicial));
  }
}
