import 'package:biblioteca_musica/bloc/logs/log.dart';
import 'package:equatable/equatable.dart';

class EventoLog extends Equatable {
  @override
  List<Object?> get props => [];
}

class EvAgregarLog extends EventoLog {
  final Log log;

  EvAgregarLog(this.log);
}
