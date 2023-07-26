import 'package:biblioteca_musica/backend/datos/cancion.dart';
import 'package:biblioteca_musica/backend/datos/lista_reproduccion.dart';
import 'package:drift/drift.dart';

class CancionListaReproduccion extends Table {
  IntColumn get idCancion =>
      integer().named("idCancion").references(Cancion, #id)();
  IntColumn get idListaRep =>
      integer().named("idListaRep").references(ListaReproduccion, #id)();
}
