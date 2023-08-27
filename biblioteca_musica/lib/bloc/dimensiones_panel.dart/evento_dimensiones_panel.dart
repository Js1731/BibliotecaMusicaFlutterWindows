import 'package:equatable/equatable.dart';

class EventoDimensionesPanel extends Equatable {
  @override
  List<Object?> get props => [];
}

class EvCambiarAncho extends EventoDimensionesPanel {
  final double nuevoAncho;

  EvCambiarAncho(this.nuevoAncho);
}

class EvExpandirAncho extends EventoDimensionesPanel {
  final double aumento;

  EvExpandirAncho(this.aumento);
}

class EvContraerAncho extends EventoDimensionesPanel {
  final double reduccion;

  EvContraerAncho(this.reduccion);
}
