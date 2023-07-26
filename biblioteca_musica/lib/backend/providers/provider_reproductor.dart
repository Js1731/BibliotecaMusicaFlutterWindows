import 'dart:async';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/main.dart';
import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';

import 'package:audioplayers/audioplayers.dart';

class ProviderReproductor extends ChangeNotifier {
  final ProviderGeneral providerGeneral;

  List<CancionData> pilaCanciones = [];

  CancionData? cancionRep;
  int? idListaRep;
  int? idColumnaPrinc;
  ValorColumnaData? valorColumnaPrincipal;

  bool activo = false;
  bool reproduciendo = false;
  bool enOrden = true;

  int indexCancionAct = 0;

  int posActual = 0;
  int durActual = 0;

  double volumen = 1;

  AudioPlayer player = AudioPlayer();

  ProviderReproductor({required this.providerGeneral});

  Future<int?> buscarIdColumnaPrincipal(int idLista) async {
    if (idLista == 0) return null;

    final listaRep = await (appDb.select(appDb.listaReproduccion)
          ..where((tbl) => tbl.id.equals(idLista)))
        .getSingle();

    if (listaRep.idColumnaPrincipal == null) return null;

    final columna = await (appDb.select(appDb.columna)
          ..where((tbl) => tbl.id.equals(listaRep.idColumnaPrincipal!)))
        .getSingle();

    return columna.id;
  }

  Future<ValorColumnaData?> buscarCancionValorColumnaPrincipal(
      int idLista, int idCancion) async {
    final idColumnaPrincipalLista = await buscarIdColumnaPrincipal(idLista);

    if (idColumnaPrincipalLista == null) return null;

    final valorColumnaPrincipaldata = await (appDb
            .selectOnly(appDb.cancionValorColumna)
          ..addColumns([
            appDb.valorColumna.id,
            appDb.valorColumna.idColumna,
            appDb.valorColumna.nombre,
            appDb.valorColumna.estado,
          ])
          ..join([
            leftOuterJoin(
                appDb.valorColumna,
                appDb.valorColumna.id
                    .equalsExp(appDb.cancionValorColumna.idValorPropiedad)),
            leftOuterJoin(appDb.columna,
                appDb.columna.id.equalsExp(appDb.valorColumna.id))
          ])
          ..where(appDb.valorColumna.idColumna.equals(idColumnaPrincipalLista) &
              appDb.cancionValorColumna.idCancion.equals(idCancion)))
        .getSingleOrNull();

    if (valorColumnaPrincipaldata == null) return null;

    final ValorColumnaData valorColumnaPrincipal = ValorColumnaData(
        id: valorColumnaPrincipaldata.rawData.data["valor_columna.id"],
        nombre: valorColumnaPrincipaldata.rawData.data["valor_columna.nombre"],
        idColumna:
            valorColumnaPrincipaldata.rawData.data["valor_columna.idColumna"],
        estado: valorColumnaPrincipaldata.rawData.data["valor_columna.estado"]);

    // final nombreValorColumna =
    //     valorColumnaPrincipalCancion?.rawData.data["valor_columna.nombre"] ??
    //         null

    return valorColumnaPrincipal;
  }

  Future<void> actualizarDatos(int? idCancion) async {
    if (idCancion == null) return;

    valorColumnaPrincipal =
        await buscarCancionValorColumnaPrincipal(idListaRep!, cancionRep!.id);

    notifyListeners();
  }

  Future<void> actualizarListaCanciones() async {
    if (idListaRep == null) return;

    List<TypedResult> lstActualizada;
    List<CancionData> nuevaListaMapeada;

    if (idListaRep == listaRepTodo.id) {
      nuevaListaMapeada = await (appDb.select(appDb.cancion)).get();
    } else {
      lstActualizada = await (appDb.select(appDb.cancion).join([
        leftOuterJoin(
            appDb.cancionListaReproduccion,
            appDb.cancionListaReproduccion.idCancion
                .equalsExp(appDb.cancion.id))
      ])
            ..where(
                appDb.cancionListaReproduccion.idListaRep.equals(idListaRep!)))
          .get();

      nuevaListaMapeada = lstActualizada
          .map<CancionData>((data) => CancionData(
              id: data.rawData.data["cancion.id"],
              nombre: data.rawData.data["cancion.nombre"],
              duracion: data.rawData.data["cancion.duracion"],
              estado: data.rawData.data["cancion.estado"]))
          .toList();
      pilaCanciones = nuevaListaMapeada;

      final infoListaRep = await (appDb.select(appDb.listaReproduccion)
            ..where((tbl) => tbl.id.equals(idListaRep!)))
          .getSingle();
      final idColumnaOrden = infoListaRep.idColumnaOrden;

      if (idColumnaOrden != null) {
        if (idColumnaOrden == -1) {
          pilaCanciones.sort((a, b) => a.nombre.compareTo(b.nombre));
        } else if (idColumnaOrden == -2) {
          pilaCanciones.sort((a, b) => a.duracion.compareTo(b.duracion));
        } else {
          final nombreColumnaOrden = (await (appDb.select(appDb.columna)
                    ..where(
                        (tbl) => tbl.id.equals(infoListaRep.idColumnaOrden!)))
                  .getSingle())
              .nombre;
          pilaCanciones.sort((a, b) {
            final columnaA =
                provGeneral.mapaCancionesPropiedades[a.id]![nombreColumnaOrden];
            final columnaB = providerGeneral
                .mapaCancionesPropiedades[b.id]![nombreColumnaOrden];

            if (columnaA == null || columnaB == null) return 1;

            return columnaA.compareTo(columnaB);
          });
        }
      }
    }

    if (enOrden) {
      if (cancionRep != null) {
        final indexPrevio = indexCancionAct;
        indexCancionAct =
            pilaCanciones.indexWhere((element) => element.id == cancionRep!.id);

        //SI LA CANCION YA NO ESTA EN LA LISTA
        if (indexCancionAct == -1) {
          indexCancionAct = indexPrevio.clamp(0, pilaCanciones.length - 1);
        }
      }
    } else {
      pilaCanciones.shuffle();
    }
  }

  ///Reproduce una lista en orden.
  Future<void> reproducirListaOrden(int idLista) async {
    idListaRep = idLista;

    pilaCanciones.clear();
    pilaCanciones.addAll(providerGeneral.lstCancionesListaRepSel);

    enOrden = true;
    await _reproducirCancionPos(0, idLista);
  }

  ///Reproduce una lista al azar.
  ///
  ///Mezcla la cola de canciones pendientes.
  Future<void> reproducirListaAzar(int idLista) async {
    idListaRep = idLista;

    pilaCanciones.clear();
    pilaCanciones.addAll(providerGeneral.lstCancionesListaRepSel);
    pilaCanciones.shuffle();

    enOrden = false;
    await moverCancionFinalPila(pilaCanciones.last);
  }

  ///Reproduce la cancion Indicada de la lista de reproduccion.
  ///
  ///Si el modo de reproduccion es en orden, se reproduce la siguiente cancion de la lista de Canciones
  ///del [ProviderGeneral].
  ///Si el modo de reproduccion es al azar, se mueve la cancion a reproducir al final de la pila de canciones y se reproduce.
  Future<void> reproducirCancion(CancionData cancion, int idLista) async {
    if (idListaRep != idLista || pilaCanciones.isEmpty) {
      enOrden = true;
      pilaCanciones.clear();
      pilaCanciones.addAll(providerGeneral.lstCancionesListaRepSel);
    }

    idListaRep = idLista;

    if (enOrden) {
      int pos = pilaCanciones.indexWhere((can) => can.id == cancion.id);
      await _reproducirCancionPos(pos, idLista);
    } else {
      await moverCancionInicioPila(cancion);
    }
  }

  ///Mueve una cancion al final de la Pila de canciones.
  Future<void> moverCancionFinalPila(CancionData cancion) async {
    pilaCanciones.remove(cancion);
    pilaCanciones.add(cancion);

    await empezarReproduccion(pilaCanciones.first);
  }

  Future<void> moverCancionInicioPila(CancionData cancion) async {
    final cancionInicial = pilaCanciones.removeAt(0);
    pilaCanciones.add(cancionInicial);

    pilaCanciones.remove(cancion);
    pilaCanciones.insert(0, cancion);

    await empezarReproduccion(pilaCanciones.first);
  }

  //Reproduce una cancion en la posicion
  Future<void> _reproducirCancionPos(int pos, int idLista) async {
    indexCancionAct = pos;
    CancionData cancion = pilaCanciones[indexCancionAct];

    await empezarReproduccion(cancion);
  }

  ///Reproduce la siguiente cancion de la lista actual.
  ///
  ///Si el modo de reproduccion es en orden, se reproduce la siguiente cancion de la lista de cancions del [ProviderGeneral].
  ///Si el modo de reproduccion es al azar,  se reproduce el Tope de la pila de canciones y se mueve al final.
  Future<void> reproducirSiguiente() async {
    int tamLista = pilaCanciones.length;
    if (enOrden) {
      int proxId = indexCancionAct + 1;
      if (proxId == tamLista) {
        proxId = 0;
      }
      await _reproducirCancionPos(proxId, idListaRep!);
    } else {
      await moverCancionFinalPila(pilaCanciones.first);
    }
  }

  ///Empieza a reproducir la lista indicada.
  Future<void> empezarReproduccion(CancionData can) async {
    cancionRep = can;
    await actualizarDatos(can.id);

    player.dispose();
    player = AudioPlayer();
    player.setVolume(volumen);

    await player.play(DeviceFileSource(rutaCan(cancionRep!.id)));
    reproduciendo = true;
    activo = true;

    player.onPlayerComplete.listen((event) {
      player.stop();
      reproducirSiguiente();
    });

    player.onPositionChanged.listen((Duration duracion) async {
      posActual = duracion.inSeconds;
      durActual = (await player.getDuration())?.inSeconds ?? 0;
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> detener() async {
    await player.stop();
    cancionRep = null;
    idListaRep = null;

    notifyListeners();
  }

  void pausarReanudar() {
    if (reproduciendo) {
      pausar();
    } else {
      reanudar();
    }

    reproduciendo = !reproduciendo;
    notifyListeners();
  }

  void pausar() {
    if (cancionRep != null) {
      player.pause();
    }

    notifyListeners();
  }

  void reanudar() {
    if (cancionRep != null) {
      player.resume();
    }

    notifyListeners();
  }

  Future<void> moverA(Duration dur) async {
    if (cancionRep != null) {
      await player.seek(dur);
    }

    notifyListeners();
  }

  Future<void> adelantar10s() async {
    if (cancionRep != null) {
      await player
          .seek(Duration(seconds: (posActual + 10).clamp(0, durActual)));
    }

    notifyListeners();
  }

  Future<void> regresar10s() async {
    if (cancionRep != null) {
      await player
          .seek(Duration(seconds: (posActual - 10).clamp(0, durActual)));
    }

    notifyListeners();
  }

  Future<void> cambiarVolumen(double nuevoVolumen) async {
    volumen = nuevoVolumen;
    await player.setVolume(volumen);
    notifyListeners();
  }

  Future<void> reproducirAnterior() async {
    if (idListaRep == null) return;

    if (enOrden) {
      var nuevaPos = indexCancionAct - 1;
      nuevaPos = nuevaPos < 0 ? (pilaCanciones.length - 1) : nuevaPos;
      await _reproducirCancionPos(nuevaPos, idListaRep!);
    } else {
      final cancion = pilaCanciones.removeLast();
      pilaCanciones.insert(0, cancion);

      empezarReproduccion(pilaCanciones.first);
    }
  }
}
