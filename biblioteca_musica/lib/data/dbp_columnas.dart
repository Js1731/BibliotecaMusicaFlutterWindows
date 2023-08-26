import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
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

  Stream<Map<ColumnaData, ValorColumnaData?>>
      crearStreamMapaValoresColumnaCancion(int idCancion) {
    return crearStreamColumnas().asyncMap((listaColumnas) async {
      Map<ColumnaData, ValorColumnaData?> mapa = {};
      for (ColumnaData columna in listaColumnas) {
        final resultados = await (appDb.select(appDb.cancionValorColumna).join([
          leftOuterJoin(
              appDb.valorColumna,
              appDb.cancionValorColumna.idValorPropiedad
                  .equalsExp(appDb.valorColumna.id))
        ])
              ..where(appDb.cancionValorColumna.idCancion.equals(idCancion) &
                  appDb.valorColumna.idColumna.equals(columna.id)))
            .getSingleOrNull();

        if (resultados != null) {
          final data = resultados.rawData.data;
          final valorColumna = ValorColumnaData(
              id: data["valor_columna.id"],
              nombre: data["valor_columna.nombre"],
              idColumna: data["valor_columna.idColumna"],
              estado: data["valor_columna.estado"]);
          mapa[columna] = valorColumna;
        } else {
          mapa[columna] = null;
        }
      }

      return mapa;
    });
  }

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

  Stream<List<ValorColumnaData>> crearStreamValoresColumnaSugerencias(
      ColumnaData columna, String criterio, int? idColumnaSel) {
    return (appDb.select(appDb.valorColumna)
          ..where((tbl) => idColumnaSel == null
              ? (tbl.idColumna.equals(columna.id) &
                  tbl.nombre.like("%$criterio%"))
              : (tbl.idColumna.equals(columna.id) &
                      tbl.nombre.like("%$criterio%")) |
                  tbl.id.equals(idColumnaSel)))
        .watch();
  }

  Future<int> agregarValorColumna(
      String nombreValorColumna, int idColumna) async {
    return await appDb.into(appDb.valorColumna).insert(
        ValorColumnaCompanion.insert(
            nombre: nombreValorColumna,
            idColumna: idColumna,
            estado: estadoLocal));
  }

  Future<ValorColumnaData> obtValorColumna(int idValorColumna) async {
    return await (appDb.select(appDb.valorColumna)
          ..where((tbl) => tbl.id.equals(idValorColumna)))
        .getSingle();
  }
}
