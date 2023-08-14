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

  crearStreamMapaValoresColumnaCancion() {}
}
