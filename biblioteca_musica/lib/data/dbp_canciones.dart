import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';

class DBPCanciones {
  Stream<List<CancionColumnas>> crearStreamListaCancion(
      int idListaRep, List<ColumnaData> columnasLista) {
    String query =
        'SELECT can.id as "cancion.id", can.nombre as "cancion.nombre", can.duracion as "cancion.duracion", can.estado as "cancion.estado",   GROUP_CONCAT(vc.nombre) AS "cancion.valores_columna", GROUP_CONCAT(vc.id) AS "cancion.id_valores_columna", GROUP_CONCAT(col.nombre) AS "cancion.columnas", GROUP_CONCAT(col.id) AS "cancion.id_columnas" FROM cancion can LEFT JOIN cancion_valor_columna cvc ON can.id = cvc.idCancion LEFT JOIN valor_columna vc ON vc.id = cvc.idValorColumna LEFT JOIN columna col ON vc.idColumna = col.id INNER JOIN cancion_lista_reproduccion cl ON cl.idCancion= can.id WHERE cl.idListaRep = $idListaRep and col.id IN (SELECT lista_columnas.idListaRep FROM lista_columnas WHERE lista_columnas.idListaRep = $idListaRep ) GROUP BY can.id';

    final streamSinFormato = appDb.customSelect(query).watch();

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
    final streamSinFormato = appDb
        .customSelect(
            'SELECT can.id as "cancion.id", can.nombre as "cancion.nombre", can.duracion as "cancion.duracion", can.estado as "cancion.estado",   GROUP_CONCAT(vc.nombre) AS "cancion.valores_columna", GROUP_CONCAT(vc.id) AS "cancion.id_valores_columna", GROUP_CONCAT(col.nombre) AS "cancion.columnas", GROUP_CONCAT(col.id) AS "cancion.id_columnas" FROM cancion can LEFT JOIN cancion_valor_columna cvc ON can.id = cvc.idCancion LEFT JOIN valor_columna vc ON vc.id = cvc.idValorColumna LEFT JOIN columna col ON vc.idColumna = col.id INNER JOIN cancion_lista_reproduccion cl ON cl.idCancion= can.id GROUP BY can.id;')
        .watch();

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
}
