import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EventoDialogoSeleccionarValorColumna extends Equatable {
  @override
  List<Object?> get props => [];
}

class EvBuscarSugerencias extends EventoDialogoSeleccionarValorColumna {
  final String criterio;

  EvBuscarSugerencias(this.criterio);
}

class EvSeleccionarValorColumna extends EventoDialogoSeleccionarValorColumna {
  final ValorColumnaData valorColSel;

  EvSeleccionarValorColumna(this.valorColSel);
}

class EvTogglePanelAgregarColumna extends EventoDialogoSeleccionarValorColumna {
  final bool mostrar;

  EvTogglePanelAgregarColumna(this.mostrar);
}
