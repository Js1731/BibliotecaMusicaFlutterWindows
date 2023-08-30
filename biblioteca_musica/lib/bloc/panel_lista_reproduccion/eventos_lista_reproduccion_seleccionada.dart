import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

class EventoListaReproduccionSeleccionada extends Equatable {
  @override
  List<Object?> get props => [];
}

class EvSeleccionarLista extends EventoListaReproduccionSeleccionada {
  final ListaReproduccionData listaSeleccionada;

  EvSeleccionarLista(this.listaSeleccionada);
}

class EvToggleSeleccionarTodo extends EventoListaReproduccionSeleccionada {}

class EvEscucharCancionesListaRep extends EventoListaReproduccionSeleccionada {
  final List<ColumnaData> lstColumnas;

  EvEscucharCancionesListaRep(this.lstColumnas);
}

class EvEscucharColumnasListaRep extends EventoListaReproduccionSeleccionada {
  final ListaReproduccionData listaSeleccionada;

  EvEscucharColumnasListaRep(this.listaSeleccionada);
}

class EvOrdenarListaPorColumna extends EventoListaReproduccionSeleccionada {
  final bool ordenAscendente = false;
  final int idColumnaOrden;

  EvOrdenarListaPorColumna(this.idColumnaOrden);
}

class EvImportarCanciones extends EventoListaReproduccionSeleccionada {
  final FilePickerResult lstCanciones;

  EvImportarCanciones(this.lstCanciones);
}

class EvToggleSelCancion extends EventoListaReproduccionSeleccionada {
  final int idCancion;

  EvToggleSelCancion(this.idCancion);
}

class EvRenombrarLista extends EventoListaReproduccionSeleccionada {
  final String nuevoNombre;

  EvRenombrarLista(this.nuevoNombre);
}

class EvEliminarLista extends EventoListaReproduccionSeleccionada {}

class EvAsignarCancionesALista extends EventoListaReproduccionSeleccionada {
  final int idListaRep;

  EvAsignarCancionesALista(this.idListaRep);
}

class EvActColumnasLista extends EventoListaReproduccionSeleccionada {
  final List<int> idColumnas;

  EvActColumnasLista(this.idColumnas);
}

class EvActValorColumnaCanciones extends EventoListaReproduccionSeleccionada {
  final int idValorColumna;
  final int idColumna;

  EvActValorColumnaCanciones(this.idValorColumna, this.idColumna);
}

class EvRecortarNombresCancionesSeleccionadas
    extends EventoListaReproduccionSeleccionada {
  final String filtro;
  final List<int> canciones;

  EvRecortarNombresCancionesSeleccionadas(this.filtro, this.canciones);
}

class EvEliminarCancionesLista extends EventoListaReproduccionSeleccionada {
  final List<int> canciones;

  EvEliminarCancionesLista(this.canciones);
}

class EvEliminarCancionesTotalmente
    extends EventoListaReproduccionSeleccionada {
  final List<int> canciones;

  EvEliminarCancionesTotalmente(this.canciones);
}

class EvRenombrarCancion extends EventoListaReproduccionSeleccionada {
  final int idCancion;
  final String nuevoNombre;

  EvRenombrarCancion(this.idCancion, this.nuevoNombre);
}

class EvActValoresColumnaCancionUnica
    extends EventoListaReproduccionSeleccionada {
  final List<ValorColumnaData> lstValorColumna;
  final int idCancion;

  EvActValoresColumnaCancionUnica(this.lstValorColumna, this.idCancion);
}

class EvActColumnaPrincipal extends EventoListaReproduccionSeleccionada {
  final int? idColumna;

  EvActColumnaPrincipal(this.idColumna);
}
