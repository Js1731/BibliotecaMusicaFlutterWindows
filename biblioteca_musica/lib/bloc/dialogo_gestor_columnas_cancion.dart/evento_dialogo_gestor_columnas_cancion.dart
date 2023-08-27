import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EventoDialogoGestorColumnasCancion extends Equatable {
  @override
  List<Object?> get props => [];
}

class EvEscucharColumnasCancion extends EventoDialogoGestorColumnasCancion {
  final int idCancion;

  EvEscucharColumnasCancion(this.idCancion);
}

class EvSeleccionarColumna extends EventoDialogoGestorColumnasCancion {
  final ColumnaData columnaDataSel;

  EvSeleccionarColumna(this.columnaDataSel);
}

class EvToggleMostrarSelectorColumna
    extends EventoDialogoGestorColumnasCancion {
  final bool mostrar;

  EvToggleMostrarSelectorColumna(this.mostrar);
}
