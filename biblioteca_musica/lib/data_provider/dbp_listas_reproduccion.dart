import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
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

  Future<void> actOrdenColumna(int idColumnaOrden, int idListaRep) async {
    appDb.update(appDb.listaReproduccion)
      ..where((tbl) => tbl.id.equals(idListaRep))
      ..write(
          ListaReproduccionCompanion(idColumnaOrden: Value(idColumnaOrden)));

    if (idListaRep == listaRepBiblioteca.id) {
      actOrdenBiblioteca(idColumnaOrden == -1
          ? OrdenBiblioteca.porNombre
          : OrdenBiblioteca.porDuracion);
    }
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

  void renombarLista(int idLista, String nuevoNombre) {
    appDb.update(appDb.listaReproduccion)
      ..where((tbl) => tbl.id.equals(idLista))
      ..write(ListaReproduccionCompanion(nombre: Value(nuevoNombre)));
  }

  Future<void> eliminarListaRep(int idListaRep) async {
    await (appDb.delete(appDb.cancionListaReproduccion)
          ..where((tbl) => tbl.idListaRep.equals(idListaRep)))
        .go();
    await (appDb.delete(appDb.listaColumnas)
          ..where((tbl) => tbl.idListaRep.equals(idListaRep)))
        .go();
    await (appDb.delete(appDb.listaReproduccion)
          ..where((tbl) => tbl.id.equals(idListaRep)))
        .go();
  }

  void actColumnaPrincipal(int? idColumna, int idListaRep) async {
    appDb.update(appDb.listaReproduccion)
      ..where((tbl) => tbl.id.equals(idListaRep))
      ..write(ListaReproduccionCompanion(idColumnaPrincipal: Value(idColumna)));
  }

  Future<ListaReproduccionData> obtListaReproduccionInicial(
      int idListaInicial) async {
    return await (appDb.select(appDb.listaReproduccion)
          ..where((tbl) => tbl.id.equals(idListaInicial)))
        .getSingle();
  }
}
