import 'package:drift/drift.dart';

class Columna extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().named("nombre")();
}
