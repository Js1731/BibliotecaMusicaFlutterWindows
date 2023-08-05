import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/utiles.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';

enum Panel { listasRep, listaRepTodo, propiedades, ajustes }

ListaReproduccionData listaRepTodo = const ListaReproduccionData(
    id: 0, nombre: "Biblioteca", ordenAscendente: true);

ProviderGeneral provGeneral = ProviderGeneral();

class ProviderGeneral extends ChangeNotifier {
  ///Lista con todas las listas de reproduccion en el sistema.
  List<ListaReproduccionData> listas = [];

  ///Lista seleccionada actualmente.
  ListaReproduccionData listaSel = listaRepTodo;

  ///Lista con todas las canciones de la lista de reproduccion seleccionada actualmente.
  List<CancionData> lstCancionesListaRepSel = [];

  ///Mapa para asociar las canciones de la lista con sus propiedades asociadas.
  Map<int, Map<String, String?>> mapaCancionesPropiedades = {};

  Panel? panelSel;

  bool modoSeleccionar = false;

  List<ColumnaData> columnasListaRepSel = [];

  Future<List<ColumnaData>> obtTodasColumnas() async {
    return appDb.select(appDb.columna).get();
  }

  //Actualiza las columnas de la lista de reproduccion seleccionada.
  Future<void> actualizarColumnasListaRepSel() async {
    if (listaSel.id != listaRepTodo.id) {
      final consultaColumnasListaRep =
          appDb.selectOnly(appDb.listaColumnas).join([
        leftOuterJoin(appDb.columna,
            appDb.columna.id.equalsExp(appDb.listaColumnas.idColumna))
      ])
            ..where(appDb.listaColumnas.idListaRep.equals(listaSel.id))
            ..addColumns([
              appDb.listaColumnas.idColumna,
              appDb.columna.nombre,
              appDb.listaColumnas.posicion
            ]);

      final resultado = await consultaColumnasListaRep.get();

      resultado.sort((a, b) => a.rawData.data["lista_columnas.posicion"]
          .compareTo(b.rawData.data["lista_columnas.posicion"]));

      columnasListaRepSel = resultado
          .map((fila) => ColumnaData(
              id: fila.rawData.data["lista_columnas.idColumna"],
              nombre: fila.rawData.data["columna.nombre"]))
          .toList();
    } else {
      columnasListaRepSel = await appDb.select(appDb.columna).get();
    }

    notifyListeners();
  }

  Future<void> recortarNombreCancionesTodo(String filtro) async {
    List<CancionData> nuevaLista = List.from(lstCancionesListaRepSel);

    for (CancionData cancion in nuevaLista) {
      String nuevoNombre = cancion.nombre;

      nuevoNombre = nuevoNombre.replaceAll(filtro, "");
      nuevoNombre = removerEspaciosDobles(nuevoNombre);
      nuevoNombre = removerDigitos(nuevoNombre);
      nuevoNombre = nuevoNombre.trim();

      (appDb.update(appDb.cancion)
        ..where((tbl) => tbl.id.equals(cancion.id))
        ..write(CancionCompanion(nombre: Value(nuevoNombre))));
    }

    await actualizarListaCanciones();
    notifyListeners();
  }

  //Actualiza la lista de Listas de Reproduccion.
  Future<void> actualizarListaListasRep() async {
    listas = await appDb.select(appDb.listaReproduccion).get();
    notifyListeners();
  }

  //Actualiza la lista de canciones de la lista de reproduccion seleccionada.
  Future<void> actualizarListaCanciones() async {
    //CARGAR TODAS LAS CANCIONES
    if (listaSel == listaRepTodo) {
      lstCancionesListaRepSel = await appDb.select(appDb.cancion).get();
    }
    //CANCIONES DE LA LISTA DE REPRODUCCION
    else {
      final consulta = appDb.selectOnly(appDb.cancionListaReproduccion).join([
        leftOuterJoin(
            appDb.cancion,
            appDb.cancion.id
                .equalsExp(appDb.cancionListaReproduccion.idCancion))
      ])
        ..where(appDb.cancionListaReproduccion.idListaRep.equals(listaSel.id))
        ..addColumns([
          appDb.cancion.id,
          appDb.cancion.nombre,
          appDb.cancion.duracion,
          appDb.cancion.estado
        ]);

      final resultados = await consulta.get();

      lstCancionesListaRepSel = resultados
          .map((fila) => CancionData(
              id: fila.rawData.data["cancion.id"],
              nombre: fila.rawData.data["cancion.nombre"],
              duracion: fila.rawData.data["cancion.duracion"],
              estado: fila.rawData.data["cancion.estado"]))
          .toList();

      final infoListaRep = await (appDb.select(appDb.listaReproduccion)
            ..where((tbl) => tbl.id.equals(listaSel.id)))
          .getSingle();
      final idColumnaOrden = infoListaRep.idColumnaOrden;

      if (idColumnaOrden != null) {
        if (idColumnaOrden == -1) {
          lstCancionesListaRepSel.sort((a, b) => a.nombre.compareTo(b.nombre));
        } else if (idColumnaOrden == -2) {
          lstCancionesListaRepSel
              .sort((a, b) => a.duracion.compareTo(b.duracion));
        } else {
          final nombreColumnaOrden = (await (appDb.select(appDb.columna)
                    ..where(
                        (tbl) => tbl.id.equals(infoListaRep.idColumnaOrden!)))
                  .getSingle())
              .nombre;
          lstCancionesListaRepSel.sort((a, b) {
            final columnaA =
                mapaCancionesPropiedades[a.id]![nombreColumnaOrden];
            final columnaB =
                mapaCancionesPropiedades[b.id]![nombreColumnaOrden];

            if (columnaA == null || columnaB == null) return 1;

            return columnaA.compareTo(columnaB);
          });
        }
      }
    }

    notifyListeners();
  }

  Future<void> actualizarValoresColumnaCancion() async {
    mapaCancionesPropiedades = {};

    for (CancionData cancion in lstCancionesListaRepSel) {
      final consultaValorColumnaCancion = (appDb
              .selectOnly(appDb.cancionValorColumna)
            ..where(appDb.cancionValorColumna.idCancion.equals(cancion.id) &
                appDb.valorColumna.idColumna
                    .isIn(columnasListaRepSel.map((e) => e.id))))
          .join([
        leftOuterJoin(
            appDb.valorColumna,
            appDb.valorColumna.id
                .equalsExp(appDb.cancionValorColumna.idValorPropiedad)),
        leftOuterJoin(appDb.columna,
            appDb.columna.id.equalsExp(appDb.valorColumna.idColumna))
      ])
        ..addColumns([
          appDb.columna.nombre,
          appDb.valorColumna.nombre,
          appDb.valorColumna.idColumna
        ]);

      final resultados = await consultaValorColumnaCancion.get();

      //CREAR MAPA DE VALOR COLUMNA PARA CADA CANCION
      Map<String, String?> mapaValoresColumnaCancion = {
        for (var columna in columnasListaRepSel) columna.nombre: null
      };

      //LLENAR MAPA CON LOS VALOR QUE TIENE LA CANCION
      for (var datos in resultados) {
        String columna = datos.rawData.data["columna.nombre"];
        String? valorColumna = datos.rawData.data["valor_columna.nombre"];
        mapaValoresColumnaCancion[columna] = valorColumna;
      }

      mapaCancionesPropiedades[cancion.id] = mapaValoresColumnaCancion;
    }

    notifyListeners();
  }

  void toggleModoSel() {
    modoSeleccionar = modoSeleccionar ? false : true;
    notifyListeners();
  }

  void seleccionarLista(int idLst) async {
    listaSel = idLst == 0
        ? listaRepTodo
        : await (appDb.select(appDb.listaReproduccion)
              ..where((tbl) => tbl.id.equals(idLst)))
            .getSingle();

    modoSeleccionar = false;

    await actualizarListaCanciones();
    await actualizarColumnasListaRepSel();
    await actualizarValoresColumnaCancion();

    cambiarPanelCentral(
        listaSel == listaRepTodo ? Panel.listaRepTodo : Panel.listasRep);

    notifyListeners();
  }

  void agregarListaNueva(ListaReproduccionData lst) {
    listas = List<ListaReproduccionData>.from(listas)..add(lst);
    notifyListeners();
  }

  void cambiarPanelCentral(Panel panel) {
    panelSel = panel;
    notifyListeners();
  }
}
