import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Config { ipServidor, ipAuto, mostrarLog }

class EstadoConfig extends Equatable {
  final String ipServidor;
  final bool ipAuto;
  final bool mostrarLog;

  const EstadoConfig(
      {required this.ipServidor,
      required this.ipAuto,
      required this.mostrarLog});

  EstadoConfig copiarCon({
    String? ipServidor_,
    bool? ipAuto_,
    bool? mostrarLog_,
  }) =>
      EstadoConfig(
        ipServidor: ipServidor_ ?? ipServidor,
        ipAuto: ipAuto_ ?? ipAuto,
        mostrarLog: mostrarLog_ ?? mostrarLog,
      );

  @override
  List<Object?> get props => [ipServidor, ipAuto, mostrarLog];
}

class CubitConf extends Cubit<EstadoConfig> {
  CubitConf()
      : super(
            const EstadoConfig(ipServidor: "", ipAuto: true, mostrarLog: true));

  Future<void> cargarConfig() async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      final ipServidor = sharedPref.getString(Config.ipServidor.name);
      final ipAuto = sharedPref.getBool(Config.ipAuto.name);
      final mostrarLog = sharedPref.getBool(Config.mostrarLog.name);

      emit(state.copiarCon(
          ipServidor_: ipServidor, ipAuto_: ipAuto, mostrarLog_: mostrarLog));
    } catch (e) {
      print(e);
    }
  }

  Future<void> actualizarConfig(EstadoConfig estadoConfig) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(Config.ipServidor.name, estadoConfig.ipServidor);
    await sharedPref.setBool(Config.ipAuto.name, estadoConfig.ipAuto);
    await sharedPref.setBool(Config.mostrarLog.name, estadoConfig.mostrarLog);

    emit(estadoConfig);
  }
}
