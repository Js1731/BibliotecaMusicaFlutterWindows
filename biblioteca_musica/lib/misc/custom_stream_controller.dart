import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CustomStreamController<T> {
  late final BehaviorSubject<T?> behaviorSubject;

  CustomStreamController({T? semilla}) {
    behaviorSubject = BehaviorSubject.seeded(semilla);
  }

  T? obtenerUltimo() => behaviorSubject.value;

  void actStream(T nuevoValor) => behaviorSubject.add(nuevoValor);

  Stream<T?> obtStream() => behaviorSubject.asBroadcastStream();

  StreamSubscription escuchar(void Function(T? nuevoValor) callback) {
    return behaviorSubject.listen(callback);
  }
}
