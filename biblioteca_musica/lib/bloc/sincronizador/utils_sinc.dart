import 'dart:io';

import 'package:biblioteca_musica/bloc/sincronizador/sincronizacion.dart';
import 'package:drift/drift.dart';

import '../../datos/AppDb.dart';

Future<void> cambiarEstadoCancion(List<int> lstCanciones, int estado) async {
  appDb.update(appDb.cancion)
    ..where((tbl) => tbl.id.isIn(lstCanciones))
    ..write(CancionCompanion(estado: Value(estado)));
}

Future<void> cambiarEstadoImagen(List<int> lstImagenes, int estado) async {
  appDb.update(appDb.valorColumna)
    ..where((tbl) => tbl.id.isIn(lstImagenes))
    ..write(ValorColumnaCompanion(estado: Value(estado)));
}

Future<void> cancelarDescargaSubida() async {
  appDb.update(appDb.cancion)
    ..where((tbl) => tbl.estado.equals(estadoDescargando))
    ..write(const CancionCompanion(estado: Value(estadoServidor)));

  appDb.update(appDb.cancion)
    ..where((tbl) => tbl.estado.equals(estadoSubiendo))
    ..write(const CancionCompanion(estado: Value(estadoLocal)));

  appDb.update(appDb.valorColumna)
    ..where((tbl) => tbl.estado.equals(estadoDescargando))
    ..write(const ValorColumnaCompanion(estado: Value(estadoServidor)));

  appDb.update(appDb.valorColumna)
    ..where((tbl) => tbl.estado.equals(estadoSubiendo))
    ..write(const ValorColumnaCompanion(estado: Value(estadoLocal)));
}

Future<void> enviarMDNS() async {
  final queryPacket = [
    // Transaction ID
    0x00, 0x00, // Set your own transaction ID here

    // Flags
    0x00, 0x00, // Standard query, no flags set

    // Question count
    0x00, 0x01, // 1 question

    // Answer count
    0x00, 0x00, // 0 answers

    // Authority count
    0x00, 0x00, // 0 authorities

    // Additional count
    0x00, 0x00, // 0 additionals

    // Query question
    // QNAME
    // _miserv
    0x07, 0x5f, 0x6d, 0x69, 0x73, 0x65, 0x72, 0x76,
    // _tcp
    0x04, 0x5f, 0x74, 0x63, 0x70,
    // local
    0x05, 0x6c, 0x6f, 0x63, 0x61, 0x6c,
    // null terminator
    0x00,

    // QTYPE
    0x00, 0x01, // A record type

    // QCLASS
    0x00, 0x01, // IN class
  ];

  RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
    socket.send(queryPacket, InternetAddress('224.0.0.251'), 5353);
    socket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {}
    }, onDone: () {});
  });
}
