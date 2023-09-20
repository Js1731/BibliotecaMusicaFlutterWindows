import 'dart:async';

import 'package:biblioteca_musica/bloc/logs/log.dart';
import 'package:biblioteca_musica/bloc/logs/estado_log.dart';
import 'package:biblioteca_musica/bloc/logs/evento_bloc_log.dart';
import 'package:bloc/bloc.dart';

class BlocLog extends Bloc<EventoLog, EstadoLog> {
  BlocLog() : super(const EstadoLog([])) {
    on<EvAgregarLog>(_onAgregarLog);
  }

  FutureOr<void> _onAgregarLog(EvAgregarLog event, Emitter<EstadoLog> emit) {
    List<Log> nuevoBackLog = List.from(state.backlog);
    nuevoBackLog.insert(0, event.log);

    nuevoBackLog = nuevoBackLog.sublist(0, 100.clamp(0, nuevoBackLog.length));

    emit(EstadoLog(nuevoBackLog));
  }
}
