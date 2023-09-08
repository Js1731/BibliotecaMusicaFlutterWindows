import 'package:bloc/bloc.dart';

class CubitGestorColumnas extends Cubit<bool> {
  CubitGestorColumnas() : super(false);

  mostrarGestorColumnas() {
    emit(true);
  }

  esconderGestorColumnas() {
    emit(false);
  }
}
