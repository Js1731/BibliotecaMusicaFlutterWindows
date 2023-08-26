import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EstadoDialogoGestorColumnasCancion extends Equatable {
  final Map<ColumnaData, ValorColumnaData?> mapaColumnas;

  const EstadoDialogoGestorColumnasCancion(this.mapaColumnas);

  @override
  List<Object?> get props => [mapaColumnas];
}
