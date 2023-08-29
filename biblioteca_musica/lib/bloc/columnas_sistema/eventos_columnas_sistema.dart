import 'package:equatable/equatable.dart';

class EventoColumnasSistema extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class EvEscucharColumnasSistema extends EventoColumnasSistema {}

class EvAgregarColumna extends EventoColumnasSistema {
  final String nombreNuevaColumna;

  EvAgregarColumna(this.nombreNuevaColumna);
}

class EvAgregarValorColumna extends EventoColumnasSistema {
  final String nombreValorColumna;
  final int idColumna;
  final String? urlImagen;

  EvAgregarValorColumna(
      this.nombreValorColumna, this.idColumna, this.urlImagen);
}
