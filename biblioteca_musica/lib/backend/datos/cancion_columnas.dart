import 'package:biblioteca_musica/backend/datos/AppDb.dart';
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
      required String strValoresColumna,
      required String strIdColumnas,
      required String strIdValoresColumna,
      required List<ColumnaData> columnasLista}) {
    cargarColumnas(
        strValoresColumna: strValoresColumna,
        strIdColumnas: strIdColumnas,
        strIdValoresColumna: strIdValoresColumna,
        columnasLista: columnasLista);
  }

  void cargarColumnas(
      {required String strValoresColumna,
      required String strIdColumnas,
      required String strIdValoresColumna,
      required List<ColumnaData> columnasLista}) {
    final List<String> idcolumnas = strIdColumnas.split(",");
    final List<String> valorescolumna = strValoresColumna.split(",");
    final List<String> idValoresColumna = strIdValoresColumna.split(",");

    Map<int, Map<String, String>?> mpColumnas = {
      for (ColumnaData columna in columnasLista) columna.id: null
    };

    for (ColumnaData columna in columnasLista) {
      final posIdColumna =
          idcolumnas.indexWhere((element) => element == "${columna.id}");

      if (posIdColumna != -1) {
        mpColumnas[columna.id] = {
          "nombre_columna": columna.nombre,
          "id_valor_columna": idValoresColumna[posIdColumna],
          "valor_columna": valorescolumna[posIdColumna],
        };
      }
    }

    mapaColumnas = mpColumnas;
  }
}
