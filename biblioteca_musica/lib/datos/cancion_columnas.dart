import 'package:drift/drift.dart';

class CancionColumnas extends Table {
  int id;
  String nombre;
  int duracion;
  int estado;
  late Map<int, Map<String, String>?> mapaColumnas;

  CancionColumnas(
      {required this.id,
      required this.nombre,
      required this.duracion,
      required this.estado,
      required this.mapaColumnas});
}
