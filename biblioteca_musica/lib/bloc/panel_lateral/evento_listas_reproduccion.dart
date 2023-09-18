import 'package:equatable/equatable.dart';

class EventoListasReproduccion extends Equatable {
  @override
  List<Object?> get props => [];
}

class PanelLateralEscucharStreamListasReproduccion
    extends EventoListasReproduccion {}

class PanelLateralAgregarLista extends EventoListasReproduccion {
  final String nombreLista;

  PanelLateralAgregarLista(this.nombreLista);
}
