import 'package:equatable/equatable.dart';

import '../../datos/AppDb.dart';

class EstadoColumnasSistema extends Equatable {
  final List<ColumnaData> columnas;

  const EstadoColumnasSistema(this.columnas);

  @override
  List<Object?> get props => [columnas];
}
