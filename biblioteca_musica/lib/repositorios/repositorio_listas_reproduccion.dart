import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/data_provider/dbp_listas_reproduccion.dart';

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

  void renombrarLista(int idLista, String nuevoNombre) {
    _dbpListasReproduccion.renombarLista(idLista, nuevoNombre);
  }

  Future<void> eliminarLista(int idListaRep) async {
    await _dbpListasReproduccion.eliminarListaRep(idListaRep);
  }

  void actColumnaPrincipal(int? idColumna, int idListaRep) {
    _dbpListasReproduccion.actColumnaPrincipal(idColumna, idListaRep);
  }

  Future<ListaReproduccionData> obtListaReproduccionInicial(
      int idListaInicial) async {
    return await _dbpListasReproduccion
        .obtListaReproduccionInicial(idListaInicial);
  }
}
