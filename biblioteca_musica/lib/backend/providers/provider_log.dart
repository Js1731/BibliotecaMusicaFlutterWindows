import 'package:flutter/material.dart';

const String errorConexion = "Error de Conexión";
const String infoTitulo = "Info";

const EntradaLog entErrorConexion =
    EntradaLog(errorConexion, "Error durante sincronización");

ProviderLog provBarraLog = ProviderLog();

class ProviderLog extends ChangeNotifier {
  List<EntradaLog> lstLog = <EntradaLog>[];

  bool sincronizado = false;
  bool logExtendido = false;

  void texto(String titulo, String desc) {
    entrada(EntradaLog(titulo, desc));

    notifyListeners();
  }

  void entrada(EntradaLog ent) {
    lstLog.insert(0, ent);

    if (lstLog.length > 100) {
      lstLog.removeLast();
    }

    notifyListeners();
  }

  EntradaLog? obtLogAct() {
    if (lstLog.isEmpty) return null;
    return lstLog.first;
  }

  EntradaLog? obtLog(int i) {
    if (lstLog.isEmpty) return null;
    return lstLog[i];
  }

  void cambiarEstadoSinc(bool nuevoEstado) {
    sincronizado = nuevoEstado;

    notifyListeners();
  }

  void togglerLogExtendido(bool extendido) {
    logExtendido = extendido;
    notifyListeners();
  }
}

class EntradaLog {
  final String titulo;
  final String desc;

  const EntradaLog(this.titulo, this.desc);
}
