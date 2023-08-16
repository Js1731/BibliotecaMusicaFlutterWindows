import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:drift/drift.dart';

class DBPListasReproduccion {
  Stream<List<ListaReproduccionData>> crearStreanListasReproduccion() {
    return appDb.select(appDb.listaReproduccion).watch();
  }

  Future<void> agregarListaReproduccion(String nombreNuevaLista) async {
    await appDb
        .into(appDb.listaReproduccion)
        .insert(ListaReproduccionCompanion.insert(nombre: nombreNuevaLista));
  }

  void actOrdenColumna(int idColumnaOrden, int idListaRep) {
    appDb.update(appDb.listaReproduccion)
      ..where((tbl) => tbl.id.equals(idListaRep))
      ..write(
          ListaReproduccionCompanion(idColumnaOrden: Value(idColumnaOrden)));
  }

  Future<void> actColumnasListaReproduccion(
      List<int> lstColumnas, int idListaRep) async {
    await (appDb.delete(appDb.listaColumnas)
          ..where((tbl) => tbl.idListaRep.equals(idListaRep)))
        .go();

    await appDb.batch((batch) => batch.insertAll(
        appDb.listaColumnas,
        lstColumnas
            .map((idColumna) => ListaColumnasCompanion.insert(
                idListaRep: idListaRep,
                idColumna: idColumna,
                posicion: lstColumnas.indexOf(idColumna)))
            .toList()));
  }
}
