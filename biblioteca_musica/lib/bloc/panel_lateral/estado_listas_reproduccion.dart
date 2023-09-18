import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EstadoListasReproduccion extends Equatable {
  final List<ListaReproduccionData> listasReproduccion;

  const EstadoListasReproduccion({this.listasReproduccion = const []});

  @override
  List<Object?> get props => [listasReproduccion];

  EstadoListasReproduccion copiarCon({List<ListaReproduccionData>? listaRep}) =>
      EstadoListasReproduccion(
          listasReproduccion: listaRep ?? listasReproduccion);

  List<ListaReproduccionData> obtListasRepExcepto(int idListaExcep) =>
      List<ListaReproduccionData>.from(listasReproduccion)
        ..removeWhere((lista) => lista.id == idListaExcep);
}
