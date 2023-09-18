import 'package:biblioteca_musica/bloc/cubit_configuracion.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sincronizacion.dart';

enum EstadoSinc {
  initSinc,
  sincronizado,
  sincronizando,
  desinc,
  nuevoLocal,
  nuevoRemoto
}

class CubitSincronizacion extends Cubit<EstadoSinc> {
  final Sincronizador sincronizador;
  CubitSincronizacion(this.sincronizador) : super(EstadoSinc.initSinc);

  Future<void> sincronizar(BlocLog blocLog, CubitConf cubitConf) async {
    if (state == EstadoSinc.sincronizando) return;

    final estadoInit = state;

    emit(EstadoSinc.sincronizando);

    final sincronizado = await sincronizador.sincronizar(blocLog, cubitConf);

    if (sincronizado) {
      emit(EstadoSinc.sincronizado);
    } else {
      emit(estadoInit);
    }
  }

  Future<void> cambiarEstado(EstadoSinc estadoNuevo) async {
    await actNumeroVersionLocal(await obtNumeroVersionLocal() + 1);
    if ((state == EstadoSinc.nuevoLocal &&
            estadoNuevo == EstadoSinc.nuevoRemoto) ||
        (state == EstadoSinc.nuevoRemoto &&
            estadoNuevo == EstadoSinc.nuevoLocal)) {
      emit(EstadoSinc.desinc);
    } else {
      emit(estadoNuevo);
    }
  }
}
