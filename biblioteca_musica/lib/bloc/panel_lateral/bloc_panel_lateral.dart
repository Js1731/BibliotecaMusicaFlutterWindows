import 'package:biblioteca_musica/bloc/panel_lateral/estado_panel_lateral.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/evento_panel_lateral.dart';
import 'package:biblioteca_musica/repositorios/repositorio_listas_reproduccion.dart';
import 'package:bloc/bloc.dart';

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
