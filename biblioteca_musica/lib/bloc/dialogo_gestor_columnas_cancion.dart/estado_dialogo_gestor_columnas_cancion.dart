import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EstadoDialogoGestorColumnasCancion extends Equatable {
  final Map<ColumnaData, ValorColumnaData?> mapaColumnas;
  final ColumnaData? columnaSel;
  final bool mostrarSelectorValorColumna;

  const EstadoDialogoGestorColumnasCancion(
      {required this.mapaColumnas,
      required this.columnaSel,
      required this.mostrarSelectorValorColumna});

  @override
  List<Object?> get props =>
      [mapaColumnas, columnaSel, mostrarSelectorValorColumna];

  EstadoDialogoGestorColumnasCancion copiarCon(
          {Map<ColumnaData, ValorColumnaData?>? nuevoMapaColumna,
          ColumnaData? nuevaColumnaSel,
          bool? mostrarSelValCol}) =>
      EstadoDialogoGestorColumnasCancion(
          mapaColumnas: nuevoMapaColumna ?? mapaColumnas,
          columnaSel: nuevaColumnaSel ?? columnaSel,
          mostrarSelectorValorColumna:
              mostrarSelValCol ?? mostrarSelectorValorColumna);
}
