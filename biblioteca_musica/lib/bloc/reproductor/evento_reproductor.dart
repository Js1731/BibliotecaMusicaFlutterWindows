import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

const ListaReproduccionData listaRepBiblioteca =
    ListaReproduccionData(id: 0, nombre: "Biblioteca", ordenAscendente: true);

class EventoReproductor extends Equatable {
  @override
  List<Object?> get props => [];
}

class EvEscucharReproductor extends EventoReproductor {}

class EvEscucharCancionReproducida extends EventoReproductor {}

class EvEscucharListaReproducida extends EventoReproductor {}

class EvEscucharProgresoReproduccion extends EventoReproductor {}

class EvEscucharReproduciendo extends EventoReproductor {}

class EvEscucharEnOrden extends EventoReproductor {}

class EvEscucharVolumen extends EventoReproductor {}

class EvCambiarProgreso extends EventoReproductor {
  final int nuevoProgreso;

  EvCambiarProgreso(this.nuevoProgreso);
}

class EvCambiarVolumen extends EventoReproductor {
  final double nuevoVolumen;

  EvCambiarVolumen(this.nuevoVolumen);
}

class EvRegresarCancion extends EventoReproductor {}

class EvRegresar10s extends EventoReproductor {}

class EvTogglePausa extends EventoReproductor {}

class EvAvanzar10s extends EventoReproductor {}

class EvAvanzarCancion extends EventoReproductor {}
