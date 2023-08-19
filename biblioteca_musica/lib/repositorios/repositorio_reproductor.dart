import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/data/reproductor.dart';

class RepositorioReproductor {
  final Reproductor _reproductor;

  RepositorioReproductor(this._reproductor);

  Stream<CancionColumnaPrincipal?> escucharCancionReproducida() =>
      _reproductor.streamContCancionReproducida.obtStream();
  Stream<ListaReproduccionData?> escucharListaReproducida() =>
      _reproductor.streamContListaReproducida.obtStream();
  Stream<int?> escucharProgresoReproduccion() =>
      _reproductor.streamContProgresoReproduccion.obtStream();
  Stream<bool?> escucharEnOrden() => _reproductor.streamContEnOrden.obtStream();
  Stream<double?> escucharVolumen() =>
      _reproductor.streamContVolumen.obtStream();

  Stream<bool?> escucharReproduciendo() =>
      _reproductor.streamContReproduciendo.obtStream();

  Future<void> reproducirListaOrden(
      ListaReproduccionData lista,
      List<CancionColumnas> listaCanciones,
      Stream<List<CancionColumnas>> stream) async {
    await _reproductor.reproducirLista(lista, true, listaCanciones, stream);
  }

  Future<void> reproducirListaAzar(
      ListaReproduccionData lista,
      List<CancionColumnas> listaCanciones,
      Stream<List<CancionColumnas>> stream) async {
    await _reproductor.reproducirLista(lista, false, listaCanciones, stream);
  }

  Future<void> reproducirCancion(
      CancionData cancion,
      ListaReproduccionData listaRep,
      List<CancionColumnas> listaCanciones,
      Stream<List<CancionColumnas>> stream) async {
    await _reproductor.reproducirCancion(
        cancion, listaRep, listaCanciones, stream);
  }

  void cambiarProgreso(int nuevoProgreso) {
    _reproductor.moverA(Duration(seconds: nuevoProgreso));
  }

  void cambiarVolumen(double nuevoVolumen) {
    _reproductor.cambiarVolumen(nuevoVolumen);
  }

  void regresarCancion() {
    _reproductor.reproducirAnterior();
  }

  void regresar10s() {
    _reproductor.regresar10s();
  }

  void togglePausar() {
    _reproductor.pausarReanudar();
  }

  void avanzar10s() {
    _reproductor.adelantar10s();
  }

  void avanzarCancion() {
    _reproductor.reproducirSiguiente();
  }
}
