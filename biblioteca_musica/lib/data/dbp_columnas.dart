import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:drift/drift.dart';

class DBPColumnas {
  Stream<List<ColumnaData>> crearStreamColumnasListaSel(int idListaRep) {
    final streamSinFormato = (appDb.select(appDb.listaColumnas).join([
      leftOuterJoin(appDb.columna,
          appDb.columna.id.equalsExp(appDb.listaColumnas.idColumna))
    ])
          ..where(appDb.listaColumnas.idListaRep.equals(idListaRep))
          ..addColumns([
            appDb.columna.id,
            appDb.columna.nombre,
          ]))
        .watch();

    final streamFinal = streamSinFormato.map((lista) => lista
        .map((columna) => ColumnaData(
              id: columna.rawData.data["columna.id"],
              nombre: columna.rawData.data["columna.nombre"],
            ))
        .toList());

    return streamFinal;
  }

  Stream<List<ColumnaData>> crearStreamColumnas() {
    return appDb.select(appDb.columna).watch();
  }

  crearStreamMapaValoresColumnaCancion() {}

  Future<List<ColumnaData>> obtColumnasSistema() async {
    return await (appDb.select(appDb.columna)).get();
  }

  Stream<List<ValorColumnaData>> crearStreamValorColumna(ColumnaData columna) {
    return (appDb.select(appDb.valorColumna)
          ..where((tbl) => tbl.idColumna.equals(columna.id)))
        .watch();
  }

  void agregarColumna(String nombreNuevaColumna) {
    appDb
        .into(appDb.columna)
        .insert(ColumnaCompanion.insert(nombre: nombreNuevaColumna));
  }
}
