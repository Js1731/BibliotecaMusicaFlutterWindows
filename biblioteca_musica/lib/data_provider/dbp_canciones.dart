import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:drift/drift.dart';

class DBPCanciones {
  void ordenarListaColumna(
      List<CancionColumnas> lista, int? idColumnaOrden, bool ascendente) {
    if (idColumnaOrden != null) {
      if (idColumnaOrden == -1) {
        lista.sort(
            (a, b) => a.nombre.compareTo(b.nombre) * (ascendente ? 1 : -1));
      } else if (idColumnaOrden == -2) {
        lista.sort(
            (a, b) => a.duracion.compareTo(b.duracion) * (ascendente ? 1 : -1));
      } else {
        lista.sort((cancionA, cancionB) {
          String? columnaA =
              cancionA.mapaColumnas[idColumnaOrden]?["valor_columna_nombre"];
          final columnaB =
              cancionB.mapaColumnas[idColumnaOrden]?["valor_columna_nombre"];

          if (columnaA == null || columnaB == null) {
            return (ascendente ? 1 : -1);
          }

          return columnaA.compareTo(columnaB) * (ascendente ? 1 : -1);
        });
      }
    }
  }

  Stream<List<CancionColumnas>> crearStreamListaCancion(
      ListaReproduccionData listaRep, List<ColumnaData> columnasLista) {
    final streamSinFormato = appDb.customSelect(
        'SELECT can.id as "cancion.id", can.nombre as "cancion.nombre", can.duracion as "cancion.duracion", can.estado as "cancion.estado"  FROM cancion can LEFT JOIN cancion_lista_reproduccion cl ON cl.idCancion= can.id WHERE cl.idListaRep = ${listaRep.id};',
        readsFrom: {
          appDb.cancion,
          appDb.cancionValorColumna,
          appDb.columna,
          appDb.cancionListaReproduccion
        }).watch();

    Stream<List<CancionColumnas>> streamFinal =
        streamSinFormato.asyncMap((listaDatos) async {
      final tarea = () async {
        final List<CancionColumnas?> nuevaLista =
            List.filled(listaDatos.length, null);
        for (int i = 0; i < nuevaLista.length; i++) {
          final dato = listaDatos[i];

          final int idCancion = dato.data["cancion.id"];
          final nombre = dato.data["cancion.nombre"];
          final duracion = dato.data["cancion.duracion"];
          final estado = dato.data["cancion.estado"];

          final consultaValorColumnaCancion = appDb
              .select(appDb.cancionValorColumna)
              .join([
            leftOuterJoin(
                appDb.valorColumna,
                appDb.valorColumna.id
                    .equalsExp(appDb.cancionValorColumna.idValorPropiedad)),
            leftOuterJoin(appDb.columna,
                appDb.columna.id.equalsExp(appDb.valorColumna.idColumna)),
          ])
            ..where(appDb.cancionValorColumna.idCancion.equals(idCancion) &
                appDb.columna.id.isIn(columnasLista.map((e) => e.id)));

          final resultados = await consultaValorColumnaCancion.get();

          //CREAR MAPA DE VALOR COLUMNA PARA CADA CANCION
          Map<int, Map<String, String>?> mapaValoresColumnaCancion = {
            for (var columna in columnasLista) columna.id: null
          };

          //LLENAR MAPA CON LOS VALOR QUE TIENE LA CANCION
          for (var datos in resultados) {
            final mapaDatos = datos.rawData.data;
            final idColumna = mapaDatos["valor_columna.idColumna"];
            mapaValoresColumnaCancion[idColumna] = {
              "valor_columna_id": "${mapaDatos["valor_columna.id"]}",
              "columna_nombre": "${mapaDatos["columna.nombre"]}",
              "valor_columna_nombre": mapaDatos["valor_columna.nombre"]
            };
          }

          nuevaLista[i] = CancionColumnas(
              id: idCancion,
              nombre: nombre,
              duracion: duracion,
              estado: estado,
              mapaColumnas: mapaValoresColumnaCancion);
        }
        final listaNoNull = nuevaLista.map<CancionColumnas>((e) => e!).toList();
        ordenarListaColumna(
            listaNoNull, listaRep.idColumnaOrden, listaRep.ordenAscendente);

        return listaNoNull;
      }();

      return tarea;
    });

    return streamFinal;
  }

  Stream<List<CancionColumnas>> crearStramCancionesBiblioteca() {
    final streamSinFormato = appDb.customSelect(
        'SELECT can.id as "cancion.id", can.nombre as "cancion.nombre", can.duracion as "cancion.duracion", can.estado as "cancion.estado",   GROUP_CONCAT(vc.nombre) AS "cancion.valores_columna", GROUP_CONCAT(vc.id) AS "cancion.id_valores_columna", GROUP_CONCAT(col.nombre) AS "cancion.columnas", GROUP_CONCAT(col.id) AS "cancion.id_columnas" FROM cancion can LEFT JOIN cancion_valor_columna cvc ON can.id = cvc.idCancion LEFT JOIN valor_columna vc ON vc.id = cvc.idValorColumna LEFT JOIN columna col ON vc.idColumna = col.id  GROUP BY can.id;',
        readsFrom: {
          appDb.cancion,
        }).watch();

    Stream<List<CancionColumnas>> streamFinal =
        streamSinFormato.asyncMap((listaDatos) async {
      final tarea = () async {
        final List<CancionColumnas?> nuevaLista =
            List.filled(listaDatos.length, null);
        for (int i = 0; i < nuevaLista.length; i++) {
          final dato = listaDatos[i];

          final id = dato.data["cancion.id"];
          final nombre = dato.data["cancion.nombre"];
          final duracion = dato.data["cancion.duracion"];
          final estado = dato.data["cancion.estado"];

          nuevaLista[i] = CancionColumnas(
              id: id,
              nombre: nombre,
              duracion: duracion,
              estado: estado,
              mapaColumnas: {});
        }
        final orden =
            await obtOrdenBiblioteca() == OrdenBiblioteca.porNombre ? -1 : -2;
        final asc = await obtAcendOrdenBiblioteca();
        final lista = nuevaLista.map<CancionColumnas>((e) => e!).toList();
        ordenarListaColumna(lista, orden, asc);

        return lista;
      }();

      return tarea;
    });
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

  ///Asigna los Valores Columna a las Canciones indicadas
  ///
  ///Se eliminan las asociaciones con otros valores de columna de la columna indicada,
  ///y asocia las canciones a el valor columna ingresado.
  Future<void> actValorColumnaCanciones(int idColumna, int idValorColumna,
      List<int> lstCancionesSeleccionadas) async {
    //
    final consultaCanValColEliminar = (appDb
        .selectOnly(appDb.cancionValorColumna)
        .join([
      leftOuterJoin(
          appDb.valorColumna,
          appDb.valorColumna.id
              .equalsExp(appDb.cancionValorColumna.idValorPropiedad)),
      leftOuterJoin(appDb.columna,
          appDb.columna.id.equalsExp(appDb.valorColumna.idColumna))
    ])
      ..where(appDb.columna.id.equals(idColumna) &
          appDb.cancionValorColumna.idCancion.isIn(lstCancionesSeleccionadas)))
      ..addColumns([appDb.cancionValorColumna.id]);

    final resultados = await consultaCanValColEliminar.get();
    List<int> lstIdsCanValColEliminar = resultados
        .map<int>((e) => e.rawData.data["cancion_valor_columna.id"])
        .toList();

    await (appDb.delete(appDb.cancionValorColumna)
          ..where((tbl) => tbl.id.isIn(lstIdsCanValColEliminar)))
        .go();

    List<Insertable> inserts = [];

    for (var idCan in lstCancionesSeleccionadas) {
      inserts.add(CancionValorColumnaCompanion.insert(
          idCancion: idCan, idValorPropiedad: idValorColumna));
    }

    await appDb
        .batch((batch) => batch.insertAll(appDb.cancionValorColumna, inserts));
  }

  Future<void> recortarNombresCanciones(
      String filtro, List<CancionColumnas> cancionesSeleccionadas) async {
    for (CancionColumnas cancion in cancionesSeleccionadas) {
      String nuevoNombre = cancion.nombre;

      nuevoNombre = nuevoNombre.replaceAll(filtro, "");
      nuevoNombre = removerEspaciosDobles(nuevoNombre);
      nuevoNombre = removerDigitos(nuevoNombre);
      nuevoNombre = nuevoNombre.trim();

      (appDb.update(appDb.cancion)
        ..where((tbl) => tbl.id.equals(cancion.id))
        ..write(CancionCompanion(nombre: Value(nuevoNombre))));
    }
  }

  void eliminarCancionesLista(int idLista, List<int> cancionesSeleccionadas) {
    appDb.batch((batch) => batch.deleteWhere(
        appDb.cancionListaReproduccion,
        (tbl) =>
            tbl.idCancion.isIn(cancionesSeleccionadas) &
            tbl.idListaRep.equals(idLista)));
  }

  void eliminarCancionesTotalemnte(List<int> cancionesSeleccionadas) {
    appDb.batch((batch) => batch.deleteWhere(appDb.cancionListaReproduccion,
        (tbl) => tbl.idCancion.isIn(cancionesSeleccionadas)));
    appDb.batch((batch) => batch.deleteWhere(
        appDb.cancion, (tbl) => tbl.id.isIn(cancionesSeleccionadas)));
  }

  Future<void> renombrarCancion(int idCancion, String nuevoNombre) async {
    await (appDb.update(appDb.cancion)
          ..where((tbl) => tbl.id.equals(idCancion)))
        .write(CancionCompanion(nombre: Value(nuevoNombre)));
  }

  void actValorColumnasCancionUnica(
      int idCancion, List<ValorColumnaData> lstValorColumna) async {
    await (appDb.delete(appDb.cancionValorColumna)
          ..where((tbl) =>
              tbl.idValorPropiedad.isIn(lstValorColumna.map((e) => e.id)) &
              tbl.idCancion.equals(idCancion)))
        .go();

    await appDb.batch((batch) => batch.insertAll(
        appDb.cancionValorColumna,
        lstValorColumna.map<CancionValorColumnaCompanion>((e) =>
            CancionValorColumnaCompanion.insert(
                idCancion: idCancion, idValorPropiedad: e.id))));
  }
}
