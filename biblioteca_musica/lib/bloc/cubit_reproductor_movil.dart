import 'package:flutter_bloc/flutter_bloc.dart';

class CubitReproductorMovil extends Cubit<bool> {
  CubitReproductorMovil() : super(false);

  void toggleModo() {
    emit(!state);
  }

  void cambiarModo(bool expadido) {
    emit(expadido);
  }
}
