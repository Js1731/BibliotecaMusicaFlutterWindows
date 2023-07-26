import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:flutter/cupertino.dart';

class ProviderPanelColumnas extends ChangeNotifier {
  late Stream<ColumnaData> streamColumnaSel;
  late Stream<List<ValorColumnaData>> streamValoresColumna;
  ColumnaData? tipoPropiedadSel;

  void seleccionarColumna(ColumnaData propiedad) {
    tipoPropiedadSel = propiedad;

    streamColumnaSel = (appDb.select(appDb.columna)
          ..where((tbl) => tbl.id.equals(propiedad.id)))
        .watchSingle();

    streamValoresColumna = (appDb.select(appDb.valorColumna)
          ..where((tbl) => tbl.idColumna.equals(propiedad.id)))
        .watch();

    notifyListeners();
  }
}
