import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EstadoBlocDialogoSeleccionarValorColumna extends Equatable {
  final ValorColumnaData? valorColumnaSeleccionado;
  final List<ValorColumnaData> sugerenciasValorColumna;
  final String criterio;

  const EstadoBlocDialogoSeleccionarValorColumna(
      {required this.valorColumnaSeleccionado,
      required this.sugerenciasValorColumna,
      required this.criterio});

  EstadoBlocDialogoSeleccionarValorColumna copiarCon(
          {ValorColumnaData? valorColSel,
          List<ValorColumnaData>? sugValorCol,
          String? crit}) =>
      EstadoBlocDialogoSeleccionarValorColumna(
          valorColumnaSeleccionado: valorColSel ?? valorColumnaSeleccionado,
          sugerenciasValorColumna: sugValorCol ?? sugerenciasValorColumna,
          criterio: crit ?? criterio);

  @override
  List<Object?> get props =>
      [valorColumnaSeleccionado, sugerenciasValorColumna, criterio];
}
