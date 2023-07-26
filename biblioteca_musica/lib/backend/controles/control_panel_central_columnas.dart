import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/pantallas/pant_principal.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_valor_columna.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_texto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

Future<ValorColumnaData?> agregarValorColumna(ColumnaData columna) async {
  final datosColumnaNueva = await abrirDialogoAgregarValorColumna(columna);

  if (datosColumnaNueva == null) return null;

  final nuevoId = UniqueKey().hashCode;
  final String nombre = datosColumnaNueva["nombre"]!;
  final String? url = datosColumnaNueva["url"];

  if (url != null) {
    await copiarArchivo(url, "$nuevoId.jpg");
  }

  //INSERTAR VALOR EN LA BASE DE DATOS
  int id = await appDb.into(appDb.valorColumna).insert(
      ValorColumnaCompanion.insert(
          id: Value(nuevoId),
          nombre: nombre,
          idColumna: columna.id,
          estado: estadoLocal));

  await actualizarDatosLocales();

  return await (appDb.select(appDb.valorColumna)
        ..where((tbl) => tbl.id.equals(id)))
      .getSingle();
}

class ControlPanelCentralPropiedades {
  Future<void> renombrarColumna(int idColumna) async {
    String? nuevoNombre = await mostrarDialogoTexto(
        keyPantPrincipal.currentContext!, "Nuevo Nombre");

    if (nuevoNombre == null) return;

    await (appDb.update(appDb.columna)
          ..where((tbl) => tbl.id.equals(idColumna)))
        .write(ColumnaCompanion(nombre: Value(nuevoNombre)));

    await actualizarDatosLocales();
  }

  Future<void> editarValorColumna(ValorColumnaData valorColumna) async {
    final valorColumnaActualizado = await abrirDialogoEditarValorColumna(
        await (appDb.select(appDb.columna)
              ..where((tbl) => tbl.id.equals(valorColumna.idColumna)))
            .getSingle(),
        valorColumna);

    if (valorColumnaActualizado == null) return;

    final String nombre = valorColumnaActualizado["nombre"]!;
    final String? url = valorColumnaActualizado["url"];

    if (url != null) {
      copiarArchivo(url, "${valorColumna.id}.jpg");
    }

    (appDb.update(appDb.valorColumna)
          ..where((tbl) => tbl.id.equals(valorColumna.id)))
        .write(ValorColumnaCompanion(nombre: Value(nombre)));

    await actualizarDatosLocales();
  }

  ///Elimina el ValorColumna y todas las asociaciones con Canciones.
  Future<void> eliminarValorColumna(int idValorColumna) async {
    await (appDb.delete(appDb.valorColumna)
          ..where((tbl) => tbl.id.equals(idValorColumna)))
        .go();

    await (appDb.delete(appDb.cancionValorColumna)
          ..where((tbl) => tbl.idValorPropiedad.equals(idValorColumna)))
        .go();

    await provGeneral.actualizarValoresColumnaCancion();
    await actualizarDatosLocales();
  }

  ///Elimna una Columna, Todos los valores de la Columna y todas las asociaciones con canciones y Listas.
  Future<void> eliminarColumna(int idColumna) async {
    final consultaValorColumnasAEliminar =
        (appDb.selectOnly(appDb.cancionValorColumna).join([
      leftOuterJoin(
          appDb.valorColumna,
          appDb.valorColumna.id
              .equalsExp(appDb.cancionValorColumna.idValorPropiedad)),
      leftOuterJoin(appDb.columna,
          appDb.columna.id.equalsExp(appDb.valorColumna.idColumna))
    ])
          ..where(appDb.columna.id.equals(idColumna)))
          ..addColumns([appDb.cancionValorColumna.id]);

    final resultados = await consultaValorColumnasAEliminar.get();
    List<int> lstIdCanValColEliminar = resultados
        .map<int>((e) => e.rawData.data["cancion_valor_columna.id"])
        .toList();

    //Eliminar Asociaciones con Canciones
    await (appDb.delete(appDb.cancionValorColumna)
          ..where((tbl) => tbl.idValorPropiedad.isIn(lstIdCanValColEliminar)))
        .go();

    //Eliminar Valores Columna
    await (appDb.delete(appDb.valorColumna)
          ..where((tbl) => tbl.idColumna.equals(idColumna)))
        .go();

    //Eliminar Asociaciones con Listas
    await (appDb.delete(appDb.listaColumnas)
          ..where((tbl) => tbl.idColumna.equals(idColumna)))
        .go();

    //Eliminar referencia si es la columna principal de alguna lista
    await (appDb.update(appDb.listaReproduccion)
          ..where((tbl) => tbl.idColumnaPrincipal.equals(idColumna)))
        .write(
            const ListaReproduccionCompanion(idColumnaPrincipal: Value(null)));

    //Eliminar la Columna
    await (appDb.delete(appDb.columna)
          ..where((tbl) => tbl.id.equals(idColumna)))
        .go();

    await provGeneral.actualizarColumnasListaRepSel();
    await provGeneral.actualizarValoresColumnaCancion();
    await actualizarDatosLocales();
  }
}
