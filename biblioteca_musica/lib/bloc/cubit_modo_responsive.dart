import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:bloc/bloc.dart';

class CubitModoResponsive extends Cubit<ModoResponsive> {
  CubitModoResponsive(super.initialState);

  void actModoResponsive(ModoResponsive nuevoModo) {
    emit(nuevoModo);
  }
}
