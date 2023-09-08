enum EstadoProcedimiento { espera, corriendo, finalizado }

class Procedimiento {
  void Function(double prog)? _callBackCambioProgreso;
  void Function(String log)? _callBackCambioLog;
  List<Future<dynamic> Function(Procedimiento, dynamic)> _colaProcesos = [];
  double progreso = 0.0;
  String log = '';
  dynamic _datosIniciales;
  EstadoProcedimiento estado = EstadoProcedimiento.espera;

  Procedimiento(
      Future<dynamic> Function(Procedimiento proc, dynamic datosIni) proceso,
      dynamic datosIni) {
    encolarProceso(proceso);
    _datosIniciales = datosIni;
  }

  Future<void> iniciar() async {
    dynamic resultado = _datosIniciales;
    estado = EstadoProcedimiento.corriendo;
    for (var proceso in _colaProcesos) {
      resultado = await proceso(this, resultado);
    }
    estado = EstadoProcedimiento.finalizado;
  }

  void encolarProceso(
      Future<dynamic> Function(Procedimiento proc, dynamic datosIni) proceso) {
    if (estado == EstadoProcedimiento.corriendo) {
      throw Exception(
          "No se puede encolar un proceso cuando el procedimiento se esta ejecutando.");
    }

    _colaProcesos.add(proceso);
  }

  void onCambioProgreso(void Function(double prog) callbackCamProg) {
    _callBackCambioProgreso = callbackCamProg;
  }

  void actProgreso(double nuevoProgreso) {
    progreso = nuevoProgreso;
    if (_callBackCambioProgreso != null) _callBackCambioProgreso!(progreso);
  }

  void actLog(String log_) {
    log = log_;
    if (_callBackCambioLog != null) _callBackCambioLog!(log);
  }
}
