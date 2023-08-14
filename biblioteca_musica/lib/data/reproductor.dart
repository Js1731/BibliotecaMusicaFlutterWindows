import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:biblioteca_musica/bloc/bloc_reproductor.dart';
import 'package:drift/drift.dart';

class Reproductor {
  final BehaviorSubject<CancionData?> streamContCancionReproducida =
      BehaviorSubject.seeded(null);

  final BehaviorSubject<ListaReproduccionData?> streamContListaReproducida =
      BehaviorSubject.seeded(null);

  List<CancionData> pilaCanciones = [];

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
  StreamSubscription? _subscriptionCanciones;

  void actCancionReproducida(CancionData? nuevaCancion) =>
      streamContCancionReproducida.add(nuevaCancion);

  void actListaReproducida(ListaReproduccionData? nuevaLista) =>
      streamContListaReproducida.add(nuevaLista);

  CancionData? obtCancionReproducida() => streamContCancionReproducida.value;

  ListaReproduccionData? obtListaReproducida() =>
      streamContListaReproducida.value;

  (Stream<CancionData?>, Stream<ListaReproduccionData?>) escucharReproductor() {
    return (
      streamContCancionReproducida.asBroadcastStream(),
      streamContListaReproducida.asBroadcastStream()
    );
  }

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

  Future<void> reproducirLista(ListaReproduccionData lista, bool enOrd) async {
    actListaReproducida(lista);
    enOrden = enOrd;

    if (_subscriptionCanciones != null) {
      await _subscriptionCanciones!.cancel();
    }

    if (obtListaReproducida()?.id == listaRepBiblioteca.id) {
      final streamFinal = appDb.select(appDb.cancion).watch();

      _subscriptionCanciones = streamFinal.listen((lista) {
        pilaCanciones.clear();
        pilaCanciones.addAll(lista);
        if (!enOrden) {
          pilaCanciones.shuffle();
        }
      });

      await streamFinal.first;
    } else {
      final streamBase = (appDb.select(appDb.cancion).join([
        leftOuterJoin(
            appDb.cancionListaReproduccion,
            appDb.cancionListaReproduccion.idCancion
                .equalsExp(appDb.cancion.id))
      ])
            ..where(appDb.cancionListaReproduccion.idListaRep
                .equals((obtListaReproducida())!.id)))
          .watch();

      final streamFinal = streamBase.map((lista) => lista
          .map((cancion) => CancionData(
              id: cancion.rawData.data["cancion.id"],
              nombre: cancion.rawData.data["cancion.nombre"],
              duracion: cancion.rawData.data["cancion.duracion"],
              estado: cancion.rawData.data["cancion.estado"]))
          .toList());

      streamFinal.listen((lista) {
        pilaCanciones.clear();
        pilaCanciones.addAll(lista);
        if (!enOrden) {
          pilaCanciones.shuffle();
        }
      });
      await streamFinal.first;
    }

    if (enOrden) {
      await _reproducirCancionPos(0);
    } else {
      await moverCancionFinalPila(pilaCanciones.last);
    }
  }

  ///Reproduce la cancion Indicada de la lista de reproduccion.
  ///
  ///Si el modo de reproduccion es en orden, se reproduce la siguiente cancion de la lista de Canciones
  ///del [ProviderGeneral].
  ///Si el modo de reproduccion es al azar, se mueve la cancion a reproducir al final de la pila de canciones y se reproduce.
  Future<void> reproducirCancion(
      CancionData cancion, ListaReproduccionData lista) async {
    actListaReproducida(lista);

    if (enOrden) {
      int pos = pilaCanciones.indexWhere((can) => can.id == cancion.id);
      await _reproducirCancionPos(pos);
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
  Future<void> _reproducirCancionPos(int pos) async {
    indexCancionAct = pos;
    CancionData cancion = pilaCanciones[indexCancionAct];

    streamContCancionReproducida.add(cancion);

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
      await _reproducirCancionPos(proxId);
    } else {
      await moverCancionFinalPila(pilaCanciones.first);
    }
  }

  ///Empieza a reproducir la lista indicada.
  Future<void> empezarReproduccion(CancionData can) async {
    streamContCancionReproducida.add(can);

    player.dispose();
    player = AudioPlayer();
    player.setVolume(volumen);

    await player.play(DeviceFileSource(rutaCan((obtCancionReproducida()!.id))));
    reproduciendo = true;
    activo = true;

    player.onPlayerComplete.listen((event) {
      player.stop();
      reproducirSiguiente();
    });

    player.onPositionChanged.listen((Duration duracion) async {
      posActual = duracion.inSeconds;
      durActual = (await player.getDuration())?.inSeconds ?? 0;
    });
  }

  Future<void> detener() async {
    await player.stop();
    streamContCancionReproducida.add(null);

    actCancionReproducida(null);
  }

  void pausarReanudar() {
    if (reproduciendo) {
      pausar();
    } else {
      reanudar();
    }

    reproduciendo = !reproduciendo;
  }

  void pausar() async {
    if (await obtCancionReproducida() != null) {
      player.pause();
    }
  }

  void reanudar() async {
    if (await obtCancionReproducida() != null) {
      player.resume();
    }
  }

  Future<void> moverA(Duration dur) async {
    if (await obtCancionReproducida() != null) {
      await player.seek(dur);
    }
  }

  Future<void> adelantar10s() async {
    if (await obtCancionReproducida() != null) {
      await player
          .seek(Duration(seconds: (posActual + 10).clamp(0, durActual)));
    }
  }

  Future<void> regresar10s() async {
    if (await obtCancionReproducida() != null) {
      await player
          .seek(Duration(seconds: (posActual - 10).clamp(0, durActual)));
    }
  }

  Future<void> cambiarVolumen(double nuevoVolumen) async {
    volumen = nuevoVolumen;
    await player.setVolume(volumen);
  }

  Future<void> reproducirAnterior() async {
    if (await obtListaReproducida() == null) return;

    if (enOrden) {
      var nuevaPos = indexCancionAct - 1;
      nuevaPos = nuevaPos < 0 ? (pilaCanciones.length - 1) : nuevaPos;
      await _reproducirCancionPos(nuevaPos);
    } else {
      final cancion = pilaCanciones.removeLast();
      pilaCanciones.insert(0, cancion);

      empezarReproduccion(pilaCanciones.first);
    }
  }
}
