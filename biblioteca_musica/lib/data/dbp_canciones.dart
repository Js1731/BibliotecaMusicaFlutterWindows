import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';
import 'package:drift/drift.dart';

class DBPCanciones {
  Stream<List<CancionColumnas>> crearStreamListaCancion(
      int idListaRep, List<ColumnaData> columnasLista) {
    String query;

    if (columnasLista.isNotEmpty) {
      query =
          'SELECT can.id as "cancion.id", can.nombre as "cancion.nombre", can.duracion as "cancion.duracion", can.estado as "cancion.estado",   GROUP_CONCAT(vc.nombre) AS "cancion.valores_columna", GROUP_CONCAT(vc.id) AS "cancion.id_valores_columna", GROUP_CONCAT(col.nombre) AS "cancion.columnas", GROUP_CONCAT(col.id) AS "cancion.id_columnas" FROM cancion can LEFT JOIN cancion_valor_columna cvc ON can.id = cvc.idCancion LEFT JOIN valor_columna vc ON vc.id = cvc.idValorColumna LEFT JOIN columna col ON vc.idColumna = col.id INNER JOIN cancion_lista_reproduccion cl ON cl.idCancion= can.id WHERE cl.idListaRep = $idListaRep and col.id IN (SELECT lista_columnas.idListaRep FROM lista_columnas WHERE lista_columnas.idListaRep = $idListaRep ) GROUP BY can.id';
    } else {
      query =
          'SELECT can.id as "cancion.id", can.nombre as "cancion.nombre", can.duracion as "cancion.duracion", can.estado as "cancion.estado" FROM cancion can  LEFT JOIN cancion_lista_reproduccion cl ON cl.idCancion= can.id WHERE cl.idListaRep = $idListaRep ;';
    }

    final streamSinFormato = appDb.customSelect(query, readsFrom: {
      appDb.cancion,
      appDb.valorColumna,
      appDb.cancionValorColumna,
      appDb.columna,
      appDb.cancionListaReproduccion
    }).watch();

    Stream<List<CancionColumnas>> streamFinal = streamSinFormato.map((lista) =>
        lista
            .map((dato) => CancionColumnas(
                id: dato.data["cancion.id"],
                nombre: dato.data["cancion.nombre"],
                duracion: dato.data["cancion.duracion"],
                estado: dato.data["cancion.estado"],
                columnasLista: columnasLista,
                strIdColumnas: dato.data["cancion.id_columnas"],
                strIdValoresColumna: dato.data["cancion.id_valores_columna"],
                strValoresColumna: dato.data["cancion.valores_columna"]))
            .toList());

    return streamFinal;
  }

  Stream<List<CancionColumnas>> crearStramCancionesBiblioteca() {
    final streamSinFormato = appDb.customSelect(
        'SELECT can.id as "cancion.id", can.nombre as "cancion.nombre", can.duracion as "cancion.duracion", can.estado as "cancion.estado",   GROUP_CONCAT(vc.nombre) AS "cancion.valores_columna", GROUP_CONCAT(vc.id) AS "cancion.id_valores_columna", GROUP_CONCAT(col.nombre) AS "cancion.columnas", GROUP_CONCAT(col.id) AS "cancion.id_columnas" FROM cancion can LEFT JOIN cancion_valor_columna cvc ON can.id = cvc.idCancion LEFT JOIN valor_columna vc ON vc.id = cvc.idValorColumna LEFT JOIN columna col ON vc.idColumna = col.id  GROUP BY can.id;',
        readsFrom: {
          appDb.cancion,
        }).watch();

    Stream<List<CancionColumnas>> streamFinal = streamSinFormato.map((lista) =>
        lista
            .map((dato) => CancionColumnas(
                id: dato.data["cancion.id"],
                nombre: dato.data["cancion.nombre"],
                duracion: dato.data["cancion.duracion"],
                estado: dato.data["cancion.estado"],
                columnasLista: [],
                strIdColumnas: dato.data["cancion.id_columnas"],
                strIdValoresColumna: dato.data["cancion.id_valores_columna"],
                strValoresColumna: dato.data["cancion.valores_columna"]))
            .toList());

    return streamFinal;
  }

  Future<void> insertarCanciones(List<CancionData> lstCanciones) async {
    //INSERTAR TODAS LAS CANCIONES EN LA BASE DE DATOS
    await appDb.batch((batch) => batch.insertAll(
        appDb.cancion,
        lstCanciones.map((cancion) => CancionCompanion.insert(
            id: Value(cancion.id),
            nombre: cancion.nombre,
            duracion: cancion.duracion,
            estado: cancion.estado))));
  }

  Future<void> asignarCancionesListaReproduccion(
      List<int> lstIdCanciones, int idListaRep) async {
    final Set<int> setIdsCancionesListaDestino =
        (await (appDb.select(appDb.cancionListaReproduccion)
                  ..where((tbl) => tbl.idListaRep.equals(idListaRep)))
                .get())
            .map((e) => e.idCancion)
            .toSet();

    final Set<int> lstIdsCancionesNoDuplicados =
        lstIdCanciones.toSet().difference(setIdsCancionesListaDestino);

    appDb.batch((batch) => batch.insertAll(
        appDb.cancionListaReproduccion,
        lstIdsCancionesNoDuplicados.map((idCan) =>
            CancionListaReproduccionCompanion.insert(
                idCancion: idCan, idListaRep: idListaRep))));
  }
}
