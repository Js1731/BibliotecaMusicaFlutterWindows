import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/data/dbp_columnas.dart';

class RepositorioColumnas {
  final DBPColumnas _dbpColumnas;

  RepositorioColumnas(this._dbpColumnas);

  Future<List<ColumnaData>> obtColumnasSistema() async {
    return await _dbpColumnas.obtColumnasSistema();
  }

  Stream<List<ColumnaData>> crearStreamColumnasListaSel(int idListaSel) {
    return _dbpColumnas.crearStreamColumnasListaSel(idListaSel);
  }

  Stream<List<ColumnaData>> crearStreamColumnas() {
    return _dbpColumnas.crearStreamColumnas();
  }

  Stream<List<ValorColumnaData>> crearStreamValoresColumna(
      ColumnaData columna) {
    return _dbpColumnas.crearStreamValorColumna(columna);
  }

  void agregarColumna(String nombreNuevaColumna) {
    _dbpColumnas.agregarColumna(nombreNuevaColumna);
  }
}
