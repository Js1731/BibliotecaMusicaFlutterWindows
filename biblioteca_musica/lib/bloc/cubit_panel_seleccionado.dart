import 'package:flutter_bloc/flutter_bloc.dart';

enum Panel { listasRep, listasMovil, ajustes, columnas }

class CubitPanelSeleccionado extends Cubit<Panel> {
  CubitPanelSeleccionado() : super(Panel.listasRep);

  void cambiarPanel(Panel nuevoPanel) => emit(nuevoPanel);
}
