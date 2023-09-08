import 'package:biblioteca_musica/sincronizador/sincronizacion.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../datos/AppDb.dart';
import '../misc/utiles.dart';

Future<void> cambiarEstadoCancion(List<int> lstCanciones, int estado) async {
  appDb.update(appDb.cancion)
    ..where((tbl) => tbl.id.isIn(lstCanciones))
    ..write(CancionCompanion(estado: Value(estado)));
}

Future<void> cambiarEstadoImagen(List<int> lstImagenes, int estado) async {
  appDb.update(appDb.valorColumna)
    ..where((tbl) => tbl.id.isIn(lstImagenes))
    ..write(ValorColumnaCompanion(estado: Value(estado)));
}

Future<void> cancelarDescargaSubida() async {
  appDb.update(appDb.cancion)
    ..where((tbl) => tbl.estado.equals(estadoDescargando))
    ..write(const CancionCompanion(estado: Value(estadoServidor)));

  appDb.update(appDb.cancion)
    ..where((tbl) => tbl.estado.equals(estadoSubiendo))
    ..write(const CancionCompanion(estado: Value(estadoLocal)));

  appDb.update(appDb.valorColumna)
    ..where((tbl) => tbl.estado.equals(estadoDescargando))
    ..write(const ValorColumnaCompanion(estado: Value(estadoServidor)));

  appDb.update(appDb.valorColumna)
    ..where((tbl) => tbl.estado.equals(estadoSubiendo))
    ..write(const ValorColumnaCompanion(estado: Value(estadoLocal)));
}
