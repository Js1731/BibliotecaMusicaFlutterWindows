import 'package:biblioteca_musica/bloc/panel_lateral/estado_listas_reproduccion.dart';
import 'package:biblioteca_musica/bloc/panel_lateral/evento_listas_reproduccion.dart';
import 'package:biblioteca_musica/repositorios/repositorio_listas_reproduccion.dart';
import 'package:bloc/bloc.dart';

class BlocListasReproduccion
    extends Bloc<EventoListasReproduccion, EstadoListasReproduccion> {
  final RepositorioListasReproduccion _repositorioListasReproduccion;

  BlocListasReproduccion(this._repositorioListasReproduccion)
      : super(const EstadoListasReproduccion()) {
    on<PanelLateralEscucharStreamListasReproduccion>(
        _escucharStreamListasReproduccion);
    on<PanelLateralAgregarLista>(_onEscucharStreamListasReproduccion);
  }

  Future<void> _escucharStreamListasReproduccion(
      EventoListasReproduccion evento,
      Emitter<EstadoListasReproduccion> emit) async {
    emit(state.copiarCon());

    await emit.forEach(
      _repositorioListasReproduccion.crearStreamListaReproduccion(),
      onData: (nuevaLista) {
        return EstadoListasReproduccion(listasReproduccion: nuevaLista);
      },
    );
  }

  Future<void> _onEscucharStreamListasReproduccion(
      PanelLateralAgregarLista evento,
      Emitter<EstadoListasReproduccion> emit) async {
    await _repositorioListasReproduccion
        .agregarListaReproduccion(evento.nombreLista);
  }
}
