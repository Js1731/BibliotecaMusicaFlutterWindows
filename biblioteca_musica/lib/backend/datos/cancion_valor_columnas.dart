import 'package:biblioteca_musica/backend/datos/cancion.dart';
import 'package:biblioteca_musica/backend/datos/valor_columna.dart';
import 'package:drift/drift.dart';

class CancionValorColumna extends Table {
  IntColumn get id => integer().autoIncrement().named("id")();
  IntColumn get idCancion =>
      integer().references(Cancion, #id).named("idCancion")();
  IntColumn get idValorPropiedad =>
      integer().references(ValorColumna, #id).named("idValorColumna")();
}
