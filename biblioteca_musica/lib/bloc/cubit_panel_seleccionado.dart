import 'package:flutter_bloc/flutter_bloc.dart';

enum Panel {
  listasRep,
  ajustes,
  columnas,
}

class CubitPanelSeleccionado extends Cubit<Panel> {
  CubitPanelSeleccionado() : super(Panel.listasRep);

  void cambiarPanel(Panel nuevoPanel) => emit(nuevoPanel);
}
