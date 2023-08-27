import 'package:equatable/equatable.dart';

class EstadoDimensionesPanel extends Equatable {
  final double ancho;
  final double altura;

  const EstadoDimensionesPanel({required this.ancho, required this.altura});

  EstadoDimensionesPanel copiarCon({double? an, double? alt}) =>
      EstadoDimensionesPanel(ancho: an ?? ancho, altura: alt ?? altura);

  @override
  List<Object?> get props => [ancho, altura];
}
