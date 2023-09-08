import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:drift/drift.dart';

class CancionColumnaPrincipal extends Table {
  int id;
  String nombre;
  int duracion;
  int estado;
  ValorColumnaData? valorColumnaPrincipal;

  CancionColumnaPrincipal(
      {required this.id,
      required this.nombre,
      required this.duracion,
      required this.estado,
      required this.valorColumnaPrincipal});

  // CancionColumnaPrincipal.deCancionData(CancionData cancionData):id = cancionData.id,
  //     nombre = cancionData.nombre,
  //     duracion = cancionData.duracion,
  //     estado = cancionData.estado,
  //     valorColumnaPrincipal};
}
