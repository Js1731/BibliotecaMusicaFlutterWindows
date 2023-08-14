import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/data/dbp_canciones.dart';

class RepositorioCanciones {
  final DBPCanciones _dbpCanciones;

  RepositorioCanciones(this._dbpCanciones);

  Stream<List<CancionColumnas>> crearStreamCancionesLista(
      int idListaRep, List<ColumnaData> columnasLista) {
    return _dbpCanciones.crearStreamListaCancion(idListaRep, columnasLista);
  }

  Stream<List<CancionColumnas>> crearStreamCancionesBiblioteca() {
    return _dbpCanciones.crearStramCancionesBiblioteca();
  }
}
