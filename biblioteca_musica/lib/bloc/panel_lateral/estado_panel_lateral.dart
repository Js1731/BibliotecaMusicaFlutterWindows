import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:equatable/equatable.dart';

class EstadoPanelLateral extends Equatable {
  final List<ListaReproduccionData> listasReproduccion;

  const EstadoPanelLateral({this.listasReproduccion = const []});

  @override
  List<Object?> get props => [listasReproduccion];

  EstadoPanelLateral copiarCon({List<ListaReproduccionData>? listaRep}) =>
      EstadoPanelLateral(listasReproduccion: listaRep ?? listasReproduccion);

  List<ListaReproduccionData> obtListasRepExcepto(int idListaExcep) =>
      List<ListaReproduccionData>.from(listasReproduccion)
        ..removeWhere((lista) => lista.id == idListaExcep);
}
