import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitPanelSeleccionado extends Cubit<Panel> {
  CubitPanelSeleccionado() : super(Panel.listaRepBiblioteca);

  void cambiarPanel(Panel nuevoPanel) => emit(nuevoPanel);
}
