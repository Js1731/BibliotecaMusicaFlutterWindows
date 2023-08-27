import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EstadoDialogoGestorColumnasCancion extends Equatable {
  final Map<ColumnaData, ValorColumnaData?> mapaColumnas;
  final ColumnaData? columnaSel;
  final bool mostrarSelectorValorColumna;
  final bool mostrarAgregarColumna;

  const EstadoDialogoGestorColumnasCancion(
      {required this.mapaColumnas,
      required this.columnaSel,
      required this.mostrarSelectorValorColumna,
      required this.mostrarAgregarColumna});

  @override
  List<Object?> get props => [
        mapaColumnas,
        columnaSel,
        mostrarSelectorValorColumna,
        mostrarAgregarColumna
      ];

  EstadoDialogoGestorColumnasCancion copiarCon(
          {Map<ColumnaData, ValorColumnaData?>? nuevoMapaColumna,
          ColumnaData? nuevaColumnaSel,
          bool? mostrarSelValCol,
          bool? mostrarAgCol}) =>
      EstadoDialogoGestorColumnasCancion(
          mapaColumnas: nuevoMapaColumna ?? mapaColumnas,
          columnaSel: nuevaColumnaSel ?? columnaSel,
          mostrarSelectorValorColumna:
              mostrarSelValCol ?? mostrarSelectorValorColumna,
          mostrarAgregarColumna: mostrarAgCol ?? mostrarAgregarColumna);
}
