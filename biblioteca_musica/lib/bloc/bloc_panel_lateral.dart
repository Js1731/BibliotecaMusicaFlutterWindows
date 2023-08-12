import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/repositorios/repositorio_listas_reproduccion.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

///--------------------------------EVENTOS--------------------------------------
class EventoPanelLateral extends Equatable {
  @override
  List<Object?> get props => [];
}

class PanelLateralEscucharStreamListasReproduccion extends EventoPanelLateral {}

class PanelLateralAgregarLista extends EventoPanelLateral {
  final String nombreLista;

  PanelLateralAgregarLista(this.nombreLista);
}

///-----------------------------ESTADO------------------------------------------
class EstadoPanelLateral extends Equatable {
  final List<ListaReproduccionData> listasReproduccion;

  const EstadoPanelLateral({this.listasReproduccion = const []});

  @override
  List<Object?> get props => [listasReproduccion];

  EstadoPanelLateral copiarCon({List<ListaReproduccionData>? listaRep}) =>
      EstadoPanelLateral(listasReproduccion: listaRep ?? listasReproduccion);
}

///----------------------------BLOC
class BlocPanelLateral extends Bloc<EventoPanelLateral, EstadoPanelLateral> {
  final RepositorioListasReproduccion _repositorioListasReproduccion;

  BlocPanelLateral(this._repositorioListasReproduccion)
      : super(const EstadoPanelLateral()) {
    on<PanelLateralEscucharStreamListasReproduccion>(
        _escucharStreamListasReproduccion);
    on<PanelLateralAgregarLista>(_onEscucharStreamListasReproduccion);
  }

  Future<void> _escucharStreamListasReproduccion(
      EventoPanelLateral evento, Emitter<EstadoPanelLateral> emit) async {
    emit(state.copiarCon());

    await emit.forEach(
      _repositorioListasReproduccion.crearStreamListaReproduccion(),
      onData: (nuevaLista) {
        return EstadoPanelLateral(listasReproduccion: nuevaLista);
      },
    );
  }

  Future<void> _onEscucharStreamListasReproduccion(
      PanelLateralAgregarLista evento, Emitter<EstadoPanelLateral> emit) async {
    await _repositorioListasReproduccion
        .agregarListaReproduccion(evento.nombreLista);
  }
}
