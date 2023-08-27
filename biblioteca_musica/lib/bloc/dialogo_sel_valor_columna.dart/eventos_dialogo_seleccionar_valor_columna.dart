import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/valor_columna.dart';
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
