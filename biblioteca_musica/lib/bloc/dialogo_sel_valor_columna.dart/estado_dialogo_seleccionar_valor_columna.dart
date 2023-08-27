import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EstadoBlocDialogoSeleccionarValorColumna extends Equatable {
  final ValorColumnaData? valorColumnaSeleccionado;
  final List<ValorColumnaData> sugerenciasValorColumna;
  final String criterio;
  final bool mostrarPanelAgregarColumna;

  const EstadoBlocDialogoSeleccionarValorColumna(
      {required this.mostrarPanelAgregarColumna,
      required this.valorColumnaSeleccionado,
      required this.sugerenciasValorColumna,
      required this.criterio});

  EstadoBlocDialogoSeleccionarValorColumna copiarCon(
          {ValorColumnaData? valorColSel,
          List<ValorColumnaData>? sugValorCol,
          String? crit,
          bool? mostrarAgCol}) =>
      EstadoBlocDialogoSeleccionarValorColumna(
          mostrarPanelAgregarColumna:
              mostrarAgCol ?? mostrarPanelAgregarColumna,
          valorColumnaSeleccionado: valorColSel ?? valorColumnaSeleccionado,
          sugerenciasValorColumna: sugValorCol ?? sugerenciasValorColumna,
          criterio: crit ?? criterio);

  @override
  List<Object?> get props => [
        valorColumnaSeleccionado,
        sugerenciasValorColumna,
        criterio,
        mostrarPanelAgregarColumna
      ];
}
