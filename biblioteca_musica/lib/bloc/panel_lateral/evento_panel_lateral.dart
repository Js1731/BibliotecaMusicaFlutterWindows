import 'package:equatable/equatable.dart';

class EventoPanelLateral extends Equatable {
  @override
  List<Object?> get props => [];
}

class PanelLateralEscucharStreamListasReproduccion extends EventoPanelLateral {}

class PanelLateralAgregarLista extends EventoPanelLateral {
  final String nombreLista;

  PanelLateralAgregarLista(this.nombreLista);
}
