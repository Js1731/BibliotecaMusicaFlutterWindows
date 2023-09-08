import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
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

  Future<ColumnaData> agregarColumna(String nombreNuevaColumna) async {
    return await _dbpColumnas.agregarColumna(nombreNuevaColumna);
  }

  Stream<List<ValorColumnaData>> crearStreamValoresColumnaSugerencias(
      ColumnaData columna, String criterio, int? idColumnaSel) {
    return _dbpColumnas.crearStreamValoresColumnaSugerencias(
        columna, criterio, idColumnaSel);
  }

  Future<ValorColumnaData> agregarValorColumna(
      String nombreValorColumna, int idColumna, String? urlSel) async {
    int idValorColumna =
        await _dbpColumnas.agregarValorColumna(nombreValorColumna, idColumna);

    if (urlSel != null) {
      await copiarArchivo(urlSel, "$idValorColumna.jpg");
    }

    return await _dbpColumnas.obtValorColumna(idValorColumna);
  }

  Stream<Map<ColumnaData, ValorColumnaData?>> crearStreamValoresColumnaCancion(
      int idCancion) {
    return _dbpColumnas.crearStreamMapaValoresColumnaCancion(idCancion);
  }

  Future<void> eliminarValorColumna(ValorColumnaData valorColumna) async {
    _dbpColumnas.eliminarValorColumna(valorColumna);

    final rutaIm = rutaImagen(valorColumna.id);
    if (rutaIm == null) return;
    await eliminarArchivo(rutaIm);
  }

  Future<ValorColumnaData> editarValorColumna(
      int id, String text, String? urlSel) async {
    final valorCol = _dbpColumnas.editarValorColumna(id, text);

    final imAnterior = rutaImagen(id);

    if (imAnterior != urlSel) {
      await eliminarArchivo("$id.jpg");
      await copiarArchivo(urlSel!, "$id.jpg");
    }

    return valorCol;
  }
}
