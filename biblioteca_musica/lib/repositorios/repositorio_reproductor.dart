import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/data/reproductor.dart';

class RepositorioReproductor {
  final Reproductor _reproductor;

  RepositorioReproductor(this._reproductor);

  (Stream<CancionData?>, Stream<ListaReproduccionData?>) escucharReproductor() {
    return _reproductor.escucharReproductor();
  }

  Future<void> reproducirListaOrden(ListaReproduccionData lista) async {
    await _reproductor.reproducirLista(lista, true);
  }

  Future<void> reproducirListaAzar(ListaReproduccionData lista) async {
    await _reproductor.reproducirLista(lista, false);
  }
}
