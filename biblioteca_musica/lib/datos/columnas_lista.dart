import 'package:biblioteca_musica/datos/lista_reproduccion.dart';
import 'package:biblioteca_musica/datos/columna.dart';
import 'package:drift/drift.dart';

class ListaColumnas extends Table {
  IntColumn get idListaRep =>
      integer().references(ListaReproduccion, #id).named("idListaRep")();
  IntColumn get idColumna =>
      integer().references(Columna, #id).named("idColumna")();
  IntColumn get posicion => integer().named("posicion")();
}
