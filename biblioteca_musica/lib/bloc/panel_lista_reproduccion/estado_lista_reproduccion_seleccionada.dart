import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:equatable/equatable.dart';

class EstadoListaReproduccionSelecconada extends Equatable {
  final ListaReproduccionData listaReproduccionSeleccionada;
  final List<CancionColumnas> listaCanciones;
  final Map<int, bool> mapaCancionesSeleccionadas;
  final Map<int, Map<String, String>?> mapValorColumnaCancion;
  final List<ColumnaData> lstColumnas;
  final int cancionesSeleccionadas = 0;

  const EstadoListaReproduccionSelecconada(
      {this.listaCanciones = const [],
      this.listaReproduccionSeleccionada = listaRepBiblioteca,
      this.mapaCancionesSeleccionadas = const {},
      this.mapValorColumnaCancion = const {},
      this.lstColumnas = const []});

  EstadoListaReproduccionSelecconada copiarCon(
      {ListaReproduccionData? nuevaListaSel,
      List<CancionColumnas>? nuevalistaCanciones,
      Map<int, bool>? nuevoMapaCancionesSeleccionadas,
      Map<int, Map<String, String>?>? nuevoMapaValoresColumnaCancion,
      List<ColumnaData>? nuevaListaColumnas}) {
    final nuevoEstado = EstadoListaReproduccionSelecconada(
        listaReproduccionSeleccionada:
            nuevaListaSel ?? listaReproduccionSeleccionada,
        listaCanciones: nuevalistaCanciones ?? listaCanciones,
        mapValorColumnaCancion:
            nuevoMapaValoresColumnaCancion ?? mapValorColumnaCancion,
        mapaCancionesSeleccionadas:
            nuevoMapaCancionesSeleccionadas ?? mapaCancionesSeleccionadas,
        lstColumnas: nuevaListaColumnas ?? lstColumnas);
    return nuevoEstado;
  }

  List<int> obtCancionesSeleccionadas() =>
      (Map<int, bool>.from(mapaCancionesSeleccionadas)
            ..removeWhere((key, value) => value == false))
          .keys
          .toList();

  List<CancionColumnas> obtCancionesSelecionadasCompleta() {
    final listaCancionesSel = obtCancionesSeleccionadas();
    final cancionesSeleccionadas = listaCanciones
        .where((element) => listaCancionesSel.contains(element.id))
        .toList();
    return cancionesSeleccionadas;
  }

  int obtCantidadCancionesSeleccionadas() => obtCancionesSeleccionadas().length;
  int obtCantidadCancionesTotal() => listaCanciones.length;

  @override
  List<Object?> get props => [
        listaReproduccionSeleccionada,
        listaCanciones,
        mapaCancionesSeleccionadas,
        mapValorColumnaCancion,
        lstColumnas
      ];
}
