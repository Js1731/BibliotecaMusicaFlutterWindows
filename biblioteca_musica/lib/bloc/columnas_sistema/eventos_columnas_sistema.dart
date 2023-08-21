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
