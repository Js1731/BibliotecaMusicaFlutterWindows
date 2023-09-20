import 'dart:async';

import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/sincronizador/cubit_sincronizacion.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Config { ipServidor, ipAuto, mostrarLog, sincAuto }

class EstadoConfig extends Equatable {
  final String ipServidor;
  final bool ipAuto;
  final bool mostrarLog;
  final bool sincAuto;

  const EstadoConfig(
      {required this.ipServidor,
      required this.ipAuto,
      required this.mostrarLog,
      required this.sincAuto});

  EstadoConfig copiarCon(
          {String? ipServidor_,
          bool? ipAuto_,
          bool? mostrarLog_,
          bool? sincAuto_}) =>
      EstadoConfig(
          ipServidor: ipServidor_ ?? ipServidor,
          ipAuto: ipAuto_ ?? ipAuto,
          mostrarLog: mostrarLog_ ?? mostrarLog,
          sincAuto: sincAuto_ ?? sincAuto);

  @override
  List<Object?> get props => [ipServidor, ipAuto, mostrarLog, sincAuto];
}

class CubitConf extends Cubit<EstadoConfig> {
  Timer? timerSinc;

  CubitConf()
      : super(const EstadoConfig(
            ipServidor: "", ipAuto: true, mostrarLog: true, sincAuto: true));

  Future<void> cargarConfig() async {
    final sharedPref = await SharedPreferences.getInstance();
    final ipServidor = sharedPref.getString(Config.ipServidor.name);
    final ipAuto = sharedPref.getBool(Config.ipAuto.name);
    final mostrarLog = sharedPref.getBool(Config.mostrarLog.name);
    final sincAuto = sharedPref.getBool(Config.sincAuto.name);

    emit(state.copiarCon(
        ipServidor_: ipServidor,
        ipAuto_: ipAuto,
        mostrarLog_: mostrarLog,
        sincAuto_: sincAuto));
  }

  Future<void> actualizarConfig(EstadoConfig estadoConfig) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(Config.ipServidor.name, estadoConfig.ipServidor);
    await sharedPref.setBool(Config.ipAuto.name, estadoConfig.ipAuto);
    await sharedPref.setBool(Config.mostrarLog.name, estadoConfig.mostrarLog);
    await sharedPref.setBool(Config.sincAuto.name, estadoConfig.sincAuto);

    emit(estadoConfig);
  }

  Future<void> activarSincAuto(
      BlocLog blocLog, CubitSincronizacion cubitSinc) async {
    if (timerSinc != null) timerSinc!.cancel();

    timerSinc = Timer.periodic(const Duration(minutes: 1), (timer) async {
      cubitSinc.sincronizar(blocLog, this);
    });
  }

  void detenerSincAuto() {
    if (timerSinc != null) timerSinc!.cancel();
  }
}
