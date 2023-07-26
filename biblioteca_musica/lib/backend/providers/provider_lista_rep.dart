import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:flutter/material.dart';

class ProviderListaReproduccion extends ChangeNotifier {
  int totalCanciones = 0;
  int cantCancionesSel = 0;
  Map<int, bool> mapaSel = {};

  List<int> obtCancionesSeleccionadas() {
    Map<int, bool> copiaMapa = Map.from(mapaSel);

    (copiaMapa.removeWhere((key, value) => value == false));
    return copiaMapa.keys.toList();
  }

  void actualizarMapaCancionesSel() {
    mapaSel.clear();
    for (CancionData can in provGeneral.lstCancionesListaRepSel) {
      mapaSel.addAll({can.id: false});
    }

    totalCanciones = mapaSel.length;
    cantCancionesSel = 0;

    notifyListeners();
  }

  void toggleModo() {
    provGeneral.toggleModoSel();

    if (provGeneral.modoSeleccionar) actualizarMapaCancionesSel();

    notifyListeners();
  }

  void toggleSelCancion(int idCancion) {
    final mpsel = Map<int, bool>.from(mapaSel);
    mpsel[idCancion] = mpsel[idCancion]! == true ? false : true;

    if (mpsel[idCancion] == false) {
      cantCancionesSel--;
    } else {
      cantCancionesSel++;
    }

    mapaSel = mpsel;

    notifyListeners();
  }

  void toggleSelTodo() {
    if (totalCanciones != cantCancionesSel) {
      cantCancionesSel = totalCanciones;
    } else {
      cantCancionesSel = 0;
    }

    final tempMapaSel = Map<int, bool>.from(mapaSel);

    tempMapaSel.forEach((key, value) {
      tempMapaSel[key] = cantCancionesSel == totalCanciones;
    });

    mapaSel = tempMapaSel;

    notifyListeners();
  }

  void reiniciar() {
    cantCancionesSel = 0;
    totalCanciones = 1;
    mapaSel.clear();

    notifyListeners();
  }
}
