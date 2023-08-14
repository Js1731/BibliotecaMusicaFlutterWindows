import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/data/dbp_columnas.dart';

class RepositorioColumnas {
  final DBPColumnas _dbpColumnas;

  RepositorioColumnas(this._dbpColumnas);

  Stream<List<ColumnaData>> crearStreamColumnasListaSel(int idListaSel) {
    return _dbpColumnas.crearStreamColumnasListaSel(idListaSel);
  }
}
