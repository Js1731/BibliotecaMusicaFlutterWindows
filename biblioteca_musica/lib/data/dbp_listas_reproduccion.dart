import 'package:biblioteca_musica/backend/datos/AppDb.dart';

class DBPListasReproduccion {
  Stream<List<ListaReproduccionData>> crearStreanListasReproduccion() {
    return appDb.select(appDb.listaReproduccion).watch();
  }

  Future<void> agregarListaReproduccion(String nombreNuevaLista) async {
    await appDb
        .into(appDb.listaReproduccion)
        .insert(ListaReproduccionCompanion.insert(nombre: nombreNuevaLista));
  }
}
