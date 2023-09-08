import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitAgregarJuegoRutaSel extends Cubit<String?> {
  CubitAgregarJuegoRutaSel(super.initialState);

  Future<void> buscarRuta() async {
    FilePickerResult? resultado = await FilePicker.platform.pickFiles();

    if (resultado == null) return;

    final String ruta = resultado.paths.first!;
    emit(ruta);
  }
}
