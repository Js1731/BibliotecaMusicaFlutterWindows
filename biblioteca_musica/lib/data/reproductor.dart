import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/backend/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/backend/misc/archivos.dart';
import 'package:drift/drift.dart';

import '../backend/misc/custom_stream_controller.dart';

class Reproductor {
  final CustomStreamController<CancionColumnaPrincipal?>
      streamContCancionReproducida = CustomStreamController();

  final CustomStreamController<ListaReproduccionData?>
      streamContListaReproducida = CustomStreamController();

  final CustomStreamController<int> streamContProgresoReproduccion =
      CustomStreamController(semilla: 0);

  final CustomStreamController<bool> streamContEnOrden =
      CustomStreamController(semilla: true);

  final CustomStreamController<bool> streamContReproduciendo =
      CustomStreamController(semilla: false);

  final CustomStreamController<double> streamContVolumen =
      CustomStreamController(semilla: 1.0);

  List<CancionData> pilaCanciones = [];

  int indexCancionAct = 0;

  AudioPlayer player = AudioPlayer();
  StreamSubscription? _subscriptionListaCanciones;
  StreamSubscription? _subscriptionCompletarReproduccion;

  void ordenarListaColumna(
      List<CancionColumnas> lista, int? idColumnaOrden, bool ascendente) {
    if (idColumnaOrden != null) {
      if (idColumnaOrden == -1) {
        lista.sort(
            (a, b) => a.nombre.compareTo(b.nombre) * (ascendente ? 1 : -1));
      } else if (idColumnaOrden == -2) {
        lista.sort(
            (a, b) => a.duracion.compareTo(b.duracion) * (ascendente ? 1 : -1));
      } else {
        lista.sort((cancionA, cancionB) {
          String? columnaA =
              cancionA.mapaColumnas[idColumnaOrden]?["valor_columna_nombre"];
          final columnaB =
              cancionB.mapaColumnas[idColumnaOrden]?["valor_columna_nombre"];

          if (columnaA == null || columnaB == null) {
            return (ascendente ? 1 : -1);
          }

          return columnaA.compareTo(columnaB) * (ascendente ? 1 : -1);
        });
      }
    }
  }

  Future<CancionColumnaPrincipal> crearCancionColumnaPrincipal(
      CancionData cancion, ListaReproduccionData lista) async {
    ValorColumnaData? valorColumna;

    if (lista.idColumnaPrincipal != null) {
      final resultado = await (appDb.selectOnly(appDb.cancionListaReproduccion)
            ..join([
              leftOuterJoin(
                  appDb.cancionValorColumna,
                  appDb.cancionValorColumna.idCancion
                      .equalsExp(appDb.cancionListaReproduccion.idCancion)),
              leftOuterJoin(
                  appDb.valorColumna,
                  appDb.cancionValorColumna.idValorPropiedad
                      .equalsExp(appDb.valorColumna.id))
            ])
            ..where(appDb.valorColumna.idColumna
                    .equals(lista.idColumnaPrincipal!) &
                appDb.cancionListaReproduccion.idCancion.equals(cancion.id) &
                appDb.cancionListaReproduccion.idListaRep.equals(lista.id))
            ..addColumns([
              appDb.cancionListaReproduccion.idCancion,
              appDb.cancionListaReproduccion.idListaRep,
              appDb.valorColumna.id,
              appDb.valorColumna.nombre,
              appDb.valorColumna.estado,
              appDb.valorColumna.idColumna,
              appDb.cancionValorColumna.idCancion,
              appDb.cancionValorColumna.idValorPropiedad
            ]))
          .getSingleOrNull();

      valorColumna = resultado == null
          ? null
          : ValorColumnaData(
              id: resultado.rawData.data["valor_columna.id"],
              nombre: resultado.rawData.data["valor_columna.nombre"],
              idColumna: resultado.rawData.data["valor_columna.idColumna"],
              estado: resultado.rawData.data["valor_columna.estado"]);
    }

    return CancionColumnaPrincipal(
        id: cancion.id,
        nombre: cancion.nombre,
        duracion: cancion.duracion,
        estado: cancion.estado,
        valorColumnaPrincipal: valorColumna
        // ? null
        // :
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

  Future<void> reproducirLista(
      ListaReproduccionData lista,
      bool enOrd,
      List<CancionColumnas> nuevaListaCanciones,
      Stream<List<CancionColumnas>> streamCanciones) async {
    streamContEnOrden.actStream(enOrd);

    if (streamContListaReproducida.obtenerUltimo()?.id != lista.id) {
      await actStreamListaCanciones(streamCanciones, nuevaListaCanciones);
    }
    streamContListaReproducida.actStream(lista);

    if (streamContEnOrden.obtenerUltimo()!) {
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
      CancionData cancion,
      ListaReproduccionData lista,
      List<CancionColumnas> nuevaListaCanciones,
      Stream<List<CancionColumnas>> streamCanciones) async {
    final val = streamContListaReproducida.obtenerUltimo();
    if (val?.id != lista.id || pilaCanciones.isEmpty) {
      await actStreamListaCanciones(streamCanciones, nuevaListaCanciones);
    }
    streamContListaReproducida.actStream(lista);

    if (streamContEnOrden.obtenerUltimo()!) {
      int pos = pilaCanciones.indexWhere((can) => can.id == cancion.id);
      await _reproducirCancionPos(pos);
    } else {
      await moverCancionInicioPila(cancion);
    }
  }

  Future<void> actStreamListaCanciones(Stream<List<CancionColumnas>> stream,
      List<CancionColumnas> lstCanciones) async {
    if (_subscriptionListaCanciones != null) {
      await _subscriptionListaCanciones!.cancel();
    }

    _subscriptionListaCanciones = stream.listen((lista) {
      pilaCanciones.clear();
      pilaCanciones.addAll(lista.map((e) => CancionData(
          id: e.id, nombre: e.nombre, duracion: e.duracion, estado: e.estado)));
      if (!streamContEnOrden.obtenerUltimo()!) {
        pilaCanciones.shuffle();
      }
    });

    pilaCanciones.clear();
    pilaCanciones.addAll(lstCanciones.map((e) => CancionData(
        id: e.id, nombre: e.nombre, duracion: e.duracion, estado: e.estado)));
    if (!streamContEnOrden.obtenerUltimo()!) {
      pilaCanciones.shuffle();
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

    await empezarReproduccion(cancion);
  }

  ///Reproduce la siguiente cancion de la lista actual.
  ///
  ///Si el modo de reproduccion es en orden, se reproduce la siguiente cancion de la lista de cancions del [ProviderGeneral].
  ///Si el modo de reproduccion es al azar,  se reproduce el Tope de la pila de canciones y se mueve al final.
  Future<void> reproducirSiguiente() async {
    int tamLista = pilaCanciones.length;
    if (streamContEnOrden.obtenerUltimo()!) {
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
    streamContCancionReproducida.actStream(await crearCancionColumnaPrincipal(
        can, streamContListaReproducida.obtenerUltimo()!));

    streamContReproduciendo.actStream(true);

    if (_subscriptionCompletarReproduccion != null) {
      await _subscriptionCompletarReproduccion!.cancel();
    }

    if (player.state != PlayerState.completed) {
      await player.stop();
    }
    await player.play(DeviceFileSource(
        rutaCan((streamContCancionReproducida.obtenerUltimo()!.id))));

    _subscriptionCompletarReproduccion =
        player.onPlayerComplete.listen((event) async {
      await reproducirSiguiente();
    });

    player.onPositionChanged.listen((Duration duracion) async {
      streamContProgresoReproduccion.actStream(duracion.inSeconds);
    });
  }

  Future<void> detener() async {
    await player.stop();

    streamContCancionReproducida.actStream(null);
  }

  void pausarReanudar() {
    if (streamContReproduciendo.obtenerUltimo()!) {
      pausar();
    } else {
      reanudar();
    }

    streamContReproduciendo
        .actStream(!streamContReproduciendo.obtenerUltimo()!);
  }

  void pausar() async {
    if (streamContCancionReproducida.obtenerUltimo() != null) {
      player.pause();
    }
  }

  void reanudar() async {
    if (streamContCancionReproducida.obtenerUltimo() != null) {
      player.resume();
    }
  }

  Future<void> moverA(Duration dur) async {
    if (streamContCancionReproducida.obtenerUltimo() != null) {
      await player.seek(dur);
    }
  }

  Future<void> adelantar10s() async {
    if (streamContCancionReproducida.obtenerUltimo() != null) {
      await player.seek(Duration(
          seconds: (streamContProgresoReproduccion.obtenerUltimo()! + 10).clamp(
              0, streamContCancionReproducida.obtenerUltimo()!.duracion)));
    }
  }

  Future<void> regresar10s() async {
    if (streamContCancionReproducida.obtenerUltimo() != null) {
      await player.seek(Duration(
          seconds: (streamContProgresoReproduccion.obtenerUltimo()! - 10).clamp(
              0, streamContCancionReproducida.obtenerUltimo()!.duracion)));
    }
  }

  Future<void> cambiarVolumen(double nuevoVolumen) async {
    streamContVolumen.actStream(nuevoVolumen);
    await player.setVolume(nuevoVolumen);
  }

  Future<void> reproducirAnterior() async {
    if (streamContListaReproducida.obtenerUltimo() == null) return;

    if (streamContEnOrden.obtenerUltimo()!) {
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
