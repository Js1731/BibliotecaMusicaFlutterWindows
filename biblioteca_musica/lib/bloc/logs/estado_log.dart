import 'package:biblioteca_musica/bloc/logs/Log.dart';
import 'package:equatable/equatable.dart';

class EstadoLog extends Equatable {
  final List<Log> backlog;

  const EstadoLog(this.backlog);

  Log? ultimo() => backlog.isNotEmpty ? backlog.first : null;

  @override
  List<Object?> get props => [backlog];
}
