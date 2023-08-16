import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/data/dbp_listas_reproduccion.dart';

class RepositorioListasReproduccion {
  final DBPListasReproduccion _dbpListasReproduccion;

  RepositorioListasReproduccion(this._dbpListasReproduccion);

  Stream<List<ListaReproduccionData>> crearStreamListaReproduccion() =>
      _dbpListasReproduccion.crearStreanListasReproduccion();

  Future<void> agregarListaReproduccion(String nombreListaNueva) async {
    await _dbpListasReproduccion.agregarListaReproduccion(nombreListaNueva);
  }

  void actOrdenColumna(int idColumnaOrden, int idListaRep) {
    _dbpListasReproduccion.actOrdenColumna(idColumnaOrden, idListaRep);
  }

  Future<void> actColumnasListaRep(
      List<int> lstColumnas, int idListaRep) async {
    await _dbpListasReproduccion.actColumnasListaReproduccion(
        lstColumnas, idListaRep);
  }
}
