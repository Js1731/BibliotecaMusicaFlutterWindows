import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EventoColumnaSeleccionada extends Equatable {
  @override
  List<Object?> get props => [];
}

class EvSeleccionarColumna extends EventoColumnaSeleccionada {
  final ColumnaData nuevaColumna;

  EvSeleccionarColumna(this.nuevaColumna);
}

class EvEscucharValoresColumna extends EventoColumnaSeleccionada {
  final ColumnaData columna;

  EvEscucharValoresColumna(this.columna);
}

class EvEliminarColumna extends EventoColumnaSeleccionada {}

class EvAgregarValorColumna extends EventoColumnaSeleccionada {
  final String nuevaColumna;

  EvAgregarValorColumna(this.nuevaColumna);
}

class EvRenombrarColumna extends EventoColumnaSeleccionada {
  final String nuevoNombre;

  EvRenombrarColumna(this.nuevoNombre);
}
