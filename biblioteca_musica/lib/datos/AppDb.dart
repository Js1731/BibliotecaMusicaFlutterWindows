import 'dart:io';

import 'package:biblioteca_musica/datos/cancion.dart';
import 'package:biblioteca_musica/datos/cancion_lista_reproduccion.dart';
import 'package:biblioteca_musica/datos/cancion_valor_columnas.dart';
import 'package:biblioteca_musica/datos/lista_reproduccion.dart';
import 'package:biblioteca_musica/datos/columna.dart';
import 'package:biblioteca_musica/datos/valor_columna.dart';
import 'package:biblioteca_musica/datos/columnas_lista.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:drift/native.dart';

part 'AppDb.g.dart';

const String archivoDB = "bm.sqlite3";

LazyDatabase _abrirConexion() => LazyDatabase(() async {
      final dirDoc = await getApplicationDocumentsDirectory();
      final pathDb = File(join(dirDoc.path, archivoDB));
      return NativeDatabase(pathDb);
    });

@DriftDatabase(tables: [
  ListaReproduccion,
  CancionListaReproduccion,
  Cancion,
  Columna,
  ValorColumna,
  CancionValorColumna,
  ListaColumnas
])
class AppDb extends _$AppDb {
  AppDb() : super(_abrirConexion());

  @override
  int get schemaVersion => 1;
}

final appDb = AppDb();
