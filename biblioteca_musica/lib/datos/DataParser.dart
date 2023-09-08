import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/datos/cancion_lista_reproduccion.dart';
import 'package:biblioteca_musica/datos/cancion_valor_columnas.dart';
import 'package:biblioteca_musica/datos/columna.dart';
import 'package:biblioteca_musica/datos/columnas_lista.dart';
import 'package:biblioteca_musica/datos/lista_reproduccion.dart';
import 'package:biblioteca_musica/datos/valor_columna.dart';

void parseDatos(dynamic datos) {}

Map<String, dynamic> parseCancionDataMapa(CancionData cancionData) {
  return {
    'id': cancionData.id,
    'nombre': cancionData.nombre,
    'duracion': cancionData.duracion
  };
}

Map<String, dynamic> parseCancionListaReproduccionMapa(
    CancionListaReproduccion cancionListaReproduccion) {
  return {
    'idCancion': cancionListaReproduccion.idCancion,
    'idListaRep': cancionListaReproduccion.idListaRep,
  };
}

Map<String, dynamic> parseCancionValorColumnaMapa(
    CancionValorColumna cancionValorColumna) {
  return {
    'id': cancionValorColumna.id,
    'idCancion': cancionValorColumna.idCancion,
    'idValorPropiedad': cancionValorColumna.idValorPropiedad,
  };
}

Map<String, dynamic> parseColumnaMapa(Columna columna) {
  return {
    'id': columna.id,
    'nombre': columna.nombre,
  };
}

Map<String, dynamic> parseListaColumnasMapa(ListaColumnas listaColumnas) {
  return {
    'idListaRep': listaColumnas.idListaRep,
    'idColumna': listaColumnas.idColumna,
    'posicion': listaColumnas.posicion,
  };
}

Map<String, dynamic> parseListaReproduccionMapa(
    ListaReproduccion listaReproduccion) {
  return {
    'id': listaReproduccion.id,
    'nombre': listaReproduccion.nombre,
    'idColumnaPrincipal': listaReproduccion.idColumnaPrincipal,
    'idColumnaOrden': listaReproduccion.idColumnaOrden,
    'ordenAscendente': listaReproduccion.ordenAscendente,
  };
}

Map<String, dynamic> parseValorColumnaMapa(ValorColumna valorColumna) {
  return {
    'id': valorColumna.id,
    'nombre': valorColumna.nombre,
    'idColumna': valorColumna.idColumna,
  };
}
