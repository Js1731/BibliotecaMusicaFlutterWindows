import 'package:biblioteca_musica/backend/datos/columna.dart';
import 'package:drift/drift.dart';

class ListaReproduccion extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  IntColumn get idColumnaPrincipal => integer()
      .named("idColumnaPrincipal")
      .references(Columna, #id)
      .nullable()();
  IntColumn get idColumnaOrden =>
      integer().named("idColumnaOrden").nullable()();
  BoolColumn get ordenAscendente =>
      boolean().named("ordenAscendente").withDefault(const Constant(true))();
}
