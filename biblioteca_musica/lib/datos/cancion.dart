import 'package:drift/drift.dart';

class Cancion extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().named("nombre")();
  IntColumn get duracion => integer().named("duracion")();
  IntColumn get estado => integer().named("estado")();
}
