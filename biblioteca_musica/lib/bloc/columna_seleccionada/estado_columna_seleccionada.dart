import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EstadoColumnaSeleccionada extends Equatable {
  final ColumnaData? columnaSeleccionada;
  final List<ValorColumnaData> listaValoresColumna;

  const EstadoColumnaSeleccionada(
      this.columnaSeleccionada, this.listaValoresColumna);

  EstadoColumnaSeleccionada copiarCon(
          {ColumnaData? nuevaColumna,
          List<ValorColumnaData>? nuevaListaValoresColumna}) =>
      EstadoColumnaSeleccionada(nuevaColumna ?? columnaSeleccionada,
          nuevaListaValoresColumna ?? listaValoresColumna);

  @override
  List<Object?> get props => [columnaSeleccionada, listaValoresColumna];
}
