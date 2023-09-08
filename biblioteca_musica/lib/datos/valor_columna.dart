import 'package:biblioteca_musica/datos/columna.dart';
import 'package:drift/drift.dart';

class ValorColumna extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().named("nombre")();
  IntColumn get idColumna =>
      integer().named("idColumna").references(Columna, #id)();
  IntColumn get estado => integer()();
}
