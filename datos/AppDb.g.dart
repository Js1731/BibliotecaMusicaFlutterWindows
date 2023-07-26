// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDb.dart';

// ignore_for_file: type=lint
class $ColumnaTable extends Columna with TableInfo<$ColumnaTable, ColumnaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ColumnaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? 'columna';
  @override
  String get actualTableName => 'columna';
  @override
  VerificationContext validateIntegrity(Insertable<ColumnaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ColumnaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ColumnaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
    );
  }

  @override
  $ColumnaTable createAlias(String alias) {
    return $ColumnaTable(attachedDatabase, alias);
  }
}

class ColumnaData extends DataClass implements Insertable<ColumnaData> {
  final int id;
  final String nombre;
  const ColumnaData({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  ColumnaCompanion toCompanion(bool nullToAbsent) {
    return ColumnaCompanion(
      id: Value(id),
      nombre: Value(nombre),
    );
  }

  factory ColumnaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ColumnaData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  ColumnaData copyWith({int? id, String? nombre}) => ColumnaData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
      );
  @override
  String toString() {
    return (StringBuffer('ColumnaData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ColumnaData &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class ColumnaCompanion extends UpdateCompanion<ColumnaData> {
  final Value<int> id;
  final Value<String> nombre;
  const ColumnaCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  ColumnaCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<ColumnaData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  ColumnaCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return ColumnaCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ColumnaCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $ListaReproduccionTable extends ListaReproduccion
    with TableInfo<$ListaReproduccionTable, ListaReproduccionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListaReproduccionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idColumnaPrincipalMeta =
      const VerificationMeta('idColumnaPrincipal');
  @override
  late final GeneratedColumn<int> idColumnaPrincipal = GeneratedColumn<int>(
      'idColumnaPrincipal', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES columna (id)'));
  static const VerificationMeta _idColumnaOrdenMeta =
      const VerificationMeta('idColumnaOrden');
  @override
  late final GeneratedColumn<int> idColumnaOrden = GeneratedColumn<int>(
      'idColumnaOrden', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _ordenAscendenteMeta =
      const VerificationMeta('ordenAscendente');
  @override
  late final GeneratedColumn<bool> ordenAscendente =
      GeneratedColumn<bool>('ordenAscendente', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("ordenAscendente" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nombre, idColumnaPrincipal, idColumnaOrden, ordenAscendente];
  @override
  String get aliasedName => _alias ?? 'lista_reproduccion';
  @override
  String get actualTableName => 'lista_reproduccion';
  @override
  VerificationContext validateIntegrity(
      Insertable<ListaReproduccionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('idColumnaPrincipal')) {
      context.handle(
          _idColumnaPrincipalMeta,
          idColumnaPrincipal.isAcceptableOrUnknown(
              data['idColumnaPrincipal']!, _idColumnaPrincipalMeta));
    }
    if (data.containsKey('idColumnaOrden')) {
      context.handle(
          _idColumnaOrdenMeta,
          idColumnaOrden.isAcceptableOrUnknown(
              data['idColumnaOrden']!, _idColumnaOrdenMeta));
    }
    if (data.containsKey('ordenAscendente')) {
      context.handle(
          _ordenAscendenteMeta,
          ordenAscendente.isAcceptableOrUnknown(
              data['ordenAscendente']!, _ordenAscendenteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListaReproduccionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListaReproduccionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      idColumnaPrincipal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idColumnaPrincipal']),
      idColumnaOrden: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idColumnaOrden']),
      ordenAscendente: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}ordenAscendente'])!,
    );
  }

  @override
  $ListaReproduccionTable createAlias(String alias) {
    return $ListaReproduccionTable(attachedDatabase, alias);
  }
}

class ListaReproduccionData extends DataClass
    implements Insertable<ListaReproduccionData> {
  final int id;
  final String nombre;
  final int? idColumnaPrincipal;
  final int? idColumnaOrden;
  final bool ordenAscendente;
  const ListaReproduccionData(
      {required this.id,
      required this.nombre,
      this.idColumnaPrincipal,
      this.idColumnaOrden,
      required this.ordenAscendente});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || idColumnaPrincipal != null) {
      map['idColumnaPrincipal'] = Variable<int>(idColumnaPrincipal);
    }
    if (!nullToAbsent || idColumnaOrden != null) {
      map['idColumnaOrden'] = Variable<int>(idColumnaOrden);
    }
    map['ordenAscendente'] = Variable<bool>(ordenAscendente);
    return map;
  }

  ListaReproduccionCompanion toCompanion(bool nullToAbsent) {
    return ListaReproduccionCompanion(
      id: Value(id),
      nombre: Value(nombre),
      idColumnaPrincipal: idColumnaPrincipal == null && nullToAbsent
          ? const Value.absent()
          : Value(idColumnaPrincipal),
      idColumnaOrden: idColumnaOrden == null && nullToAbsent
          ? const Value.absent()
          : Value(idColumnaOrden),
      ordenAscendente: Value(ordenAscendente),
    );
  }

  factory ListaReproduccionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListaReproduccionData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      idColumnaPrincipal: serializer.fromJson<int?>(json['idColumnaPrincipal']),
      idColumnaOrden: serializer.fromJson<int?>(json['idColumnaOrden']),
      ordenAscendente: serializer.fromJson<bool>(json['ordenAscendente']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'idColumnaPrincipal': serializer.toJson<int?>(idColumnaPrincipal),
      'idColumnaOrden': serializer.toJson<int?>(idColumnaOrden),
      'ordenAscendente': serializer.toJson<bool>(ordenAscendente),
    };
  }

  ListaReproduccionData copyWith(
          {int? id,
          String? nombre,
          Value<int?> idColumnaPrincipal = const Value.absent(),
          Value<int?> idColumnaOrden = const Value.absent(),
          bool? ordenAscendente}) =>
      ListaReproduccionData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        idColumnaPrincipal: idColumnaPrincipal.present
            ? idColumnaPrincipal.value
            : this.idColumnaPrincipal,
        idColumnaOrden:
            idColumnaOrden.present ? idColumnaOrden.value : this.idColumnaOrden,
        ordenAscendente: ordenAscendente ?? this.ordenAscendente,
      );
  @override
  String toString() {
    return (StringBuffer('ListaReproduccionData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('idColumnaPrincipal: $idColumnaPrincipal, ')
          ..write('idColumnaOrden: $idColumnaOrden, ')
          ..write('ordenAscendente: $ordenAscendente')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, nombre, idColumnaPrincipal, idColumnaOrden, ordenAscendente);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListaReproduccionData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.idColumnaPrincipal == this.idColumnaPrincipal &&
          other.idColumnaOrden == this.idColumnaOrden &&
          other.ordenAscendente == this.ordenAscendente);
}

class ListaReproduccionCompanion
    extends UpdateCompanion<ListaReproduccionData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int?> idColumnaPrincipal;
  final Value<int?> idColumnaOrden;
  final Value<bool> ordenAscendente;
  const ListaReproduccionCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.idColumnaPrincipal = const Value.absent(),
    this.idColumnaOrden = const Value.absent(),
    this.ordenAscendente = const Value.absent(),
  });
  ListaReproduccionCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.idColumnaPrincipal = const Value.absent(),
    this.idColumnaOrden = const Value.absent(),
    this.ordenAscendente = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<ListaReproduccionData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? idColumnaPrincipal,
    Expression<int>? idColumnaOrden,
    Expression<bool>? ordenAscendente,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (idColumnaPrincipal != null) 'idColumnaPrincipal': idColumnaPrincipal,
      if (idColumnaOrden != null) 'idColumnaOrden': idColumnaOrden,
      if (ordenAscendente != null) 'ordenAscendente': ordenAscendente,
    });
  }

  ListaReproduccionCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<int?>? idColumnaPrincipal,
      Value<int?>? idColumnaOrden,
      Value<bool>? ordenAscendente}) {
    return ListaReproduccionCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      idColumnaPrincipal: idColumnaPrincipal ?? this.idColumnaPrincipal,
      idColumnaOrden: idColumnaOrden ?? this.idColumnaOrden,
      ordenAscendente: ordenAscendente ?? this.ordenAscendente,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (idColumnaPrincipal.present) {
      map['idColumnaPrincipal'] = Variable<int>(idColumnaPrincipal.value);
    }
    if (idColumnaOrden.present) {
      map['idColumnaOrden'] = Variable<int>(idColumnaOrden.value);
    }
    if (ordenAscendente.present) {
      map['ordenAscendente'] = Variable<bool>(ordenAscendente.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListaReproduccionCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('idColumnaPrincipal: $idColumnaPrincipal, ')
          ..write('idColumnaOrden: $idColumnaOrden, ')
          ..write('ordenAscendente: $ordenAscendente')
          ..write(')'))
        .toString();
  }
}

class $CancionTable extends Cancion with TableInfo<$CancionTable, CancionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CancionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _duracionMeta =
      const VerificationMeta('duracion');
  @override
  late final GeneratedColumn<int> duracion = GeneratedColumn<int>(
      'duracion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<int> estado = GeneratedColumn<int>(
      'estado', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nombre, duracion, estado];
  @override
  String get aliasedName => _alias ?? 'cancion';
  @override
  String get actualTableName => 'cancion';
  @override
  VerificationContext validateIntegrity(Insertable<CancionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('duracion')) {
      context.handle(_duracionMeta,
          duracion.isAcceptableOrUnknown(data['duracion']!, _duracionMeta));
    } else if (isInserting) {
      context.missing(_duracionMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CancionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CancionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      duracion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duracion'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estado'])!,
    );
  }

  @override
  $CancionTable createAlias(String alias) {
    return $CancionTable(attachedDatabase, alias);
  }
}

class CancionData extends DataClass implements Insertable<CancionData> {
  final int id;
  final String nombre;
  final int duracion;
  final int estado;
  const CancionData(
      {required this.id,
      required this.nombre,
      required this.duracion,
      required this.estado});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['duracion'] = Variable<int>(duracion);
    map['estado'] = Variable<int>(estado);
    return map;
  }

  CancionCompanion toCompanion(bool nullToAbsent) {
    return CancionCompanion(
      id: Value(id),
      nombre: Value(nombre),
      duracion: Value(duracion),
      estado: Value(estado),
    );
  }

  factory CancionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CancionData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      duracion: serializer.fromJson<int>(json['duracion']),
      estado: serializer.fromJson<int>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'duracion': serializer.toJson<int>(duracion),
      'estado': serializer.toJson<int>(estado),
    };
  }

  CancionData copyWith({int? id, String? nombre, int? duracion, int? estado}) =>
      CancionData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        duracion: duracion ?? this.duracion,
        estado: estado ?? this.estado,
      );
  @override
  String toString() {
    return (StringBuffer('CancionData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('duracion: $duracion, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, duracion, estado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CancionData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.duracion == this.duracion &&
          other.estado == this.estado);
}

class CancionCompanion extends UpdateCompanion<CancionData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> duracion;
  final Value<int> estado;
  const CancionCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.duracion = const Value.absent(),
    this.estado = const Value.absent(),
  });
  CancionCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required int duracion,
    required int estado,
  })  : nombre = Value(nombre),
        duracion = Value(duracion),
        estado = Value(estado);
  static Insertable<CancionData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? duracion,
    Expression<int>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (duracion != null) 'duracion': duracion,
      if (estado != null) 'estado': estado,
    });
  }

  CancionCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<int>? duracion,
      Value<int>? estado}) {
    return CancionCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      duracion: duracion ?? this.duracion,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (duracion.present) {
      map['duracion'] = Variable<int>(duracion.value);
    }
    if (estado.present) {
      map['estado'] = Variable<int>(estado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CancionCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('duracion: $duracion, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class $CancionListaReproduccionTable extends CancionListaReproduccion
    with
        TableInfo<$CancionListaReproduccionTable,
            CancionListaReproduccionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CancionListaReproduccionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idCancionMeta =
      const VerificationMeta('idCancion');
  @override
  late final GeneratedColumn<int> idCancion = GeneratedColumn<int>(
      'idCancion', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cancion (id)'));
  static const VerificationMeta _idListaRepMeta =
      const VerificationMeta('idListaRep');
  @override
  late final GeneratedColumn<int> idListaRep = GeneratedColumn<int>(
      'idListaRep', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lista_reproduccion (id)'));
  @override
  List<GeneratedColumn> get $columns => [idCancion, idListaRep];
  @override
  String get aliasedName => _alias ?? 'cancion_lista_reproduccion';
  @override
  String get actualTableName => 'cancion_lista_reproduccion';
  @override
  VerificationContext validateIntegrity(
      Insertable<CancionListaReproduccionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('idCancion')) {
      context.handle(_idCancionMeta,
          idCancion.isAcceptableOrUnknown(data['idCancion']!, _idCancionMeta));
    } else if (isInserting) {
      context.missing(_idCancionMeta);
    }
    if (data.containsKey('idListaRep')) {
      context.handle(
          _idListaRepMeta,
          idListaRep.isAcceptableOrUnknown(
              data['idListaRep']!, _idListaRepMeta));
    } else if (isInserting) {
      context.missing(_idListaRepMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  CancionListaReproduccionData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CancionListaReproduccionData(
      idCancion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idCancion'])!,
      idListaRep: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idListaRep'])!,
    );
  }

  @override
  $CancionListaReproduccionTable createAlias(String alias) {
    return $CancionListaReproduccionTable(attachedDatabase, alias);
  }
}

class CancionListaReproduccionData extends DataClass
    implements Insertable<CancionListaReproduccionData> {
  final int idCancion;
  final int idListaRep;
  const CancionListaReproduccionData(
      {required this.idCancion, required this.idListaRep});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['idCancion'] = Variable<int>(idCancion);
    map['idListaRep'] = Variable<int>(idListaRep);
    return map;
  }

  CancionListaReproduccionCompanion toCompanion(bool nullToAbsent) {
    return CancionListaReproduccionCompanion(
      idCancion: Value(idCancion),
      idListaRep: Value(idListaRep),
    );
  }

  factory CancionListaReproduccionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CancionListaReproduccionData(
      idCancion: serializer.fromJson<int>(json['idCancion']),
      idListaRep: serializer.fromJson<int>(json['idListaRep']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idCancion': serializer.toJson<int>(idCancion),
      'idListaRep': serializer.toJson<int>(idListaRep),
    };
  }

  CancionListaReproduccionData copyWith({int? idCancion, int? idListaRep}) =>
      CancionListaReproduccionData(
        idCancion: idCancion ?? this.idCancion,
        idListaRep: idListaRep ?? this.idListaRep,
      );
  @override
  String toString() {
    return (StringBuffer('CancionListaReproduccionData(')
          ..write('idCancion: $idCancion, ')
          ..write('idListaRep: $idListaRep')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idCancion, idListaRep);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CancionListaReproduccionData &&
          other.idCancion == this.idCancion &&
          other.idListaRep == this.idListaRep);
}

class CancionListaReproduccionCompanion
    extends UpdateCompanion<CancionListaReproduccionData> {
  final Value<int> idCancion;
  final Value<int> idListaRep;
  final Value<int> rowid;
  const CancionListaReproduccionCompanion({
    this.idCancion = const Value.absent(),
    this.idListaRep = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CancionListaReproduccionCompanion.insert({
    required int idCancion,
    required int idListaRep,
    this.rowid = const Value.absent(),
  })  : idCancion = Value(idCancion),
        idListaRep = Value(idListaRep);
  static Insertable<CancionListaReproduccionData> custom({
    Expression<int>? idCancion,
    Expression<int>? idListaRep,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idCancion != null) 'idCancion': idCancion,
      if (idListaRep != null) 'idListaRep': idListaRep,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CancionListaReproduccionCompanion copyWith(
      {Value<int>? idCancion, Value<int>? idListaRep, Value<int>? rowid}) {
    return CancionListaReproduccionCompanion(
      idCancion: idCancion ?? this.idCancion,
      idListaRep: idListaRep ?? this.idListaRep,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idCancion.present) {
      map['idCancion'] = Variable<int>(idCancion.value);
    }
    if (idListaRep.present) {
      map['idListaRep'] = Variable<int>(idListaRep.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CancionListaReproduccionCompanion(')
          ..write('idCancion: $idCancion, ')
          ..write('idListaRep: $idListaRep, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ValorColumnaTable extends ValorColumna
    with TableInfo<$ValorColumnaTable, ValorColumnaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ValorColumnaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idColumnaMeta =
      const VerificationMeta('idColumna');
  @override
  late final GeneratedColumn<int> idColumna = GeneratedColumn<int>(
      'idColumna', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES columna (id)'));
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<int> estado = GeneratedColumn<int>(
      'estado', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nombre, idColumna, estado];
  @override
  String get aliasedName => _alias ?? 'valor_columna';
  @override
  String get actualTableName => 'valor_columna';
  @override
  VerificationContext validateIntegrity(Insertable<ValorColumnaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('idColumna')) {
      context.handle(_idColumnaMeta,
          idColumna.isAcceptableOrUnknown(data['idColumna']!, _idColumnaMeta));
    } else if (isInserting) {
      context.missing(_idColumnaMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ValorColumnaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ValorColumnaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      idColumna: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idColumna'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estado'])!,
    );
  }

  @override
  $ValorColumnaTable createAlias(String alias) {
    return $ValorColumnaTable(attachedDatabase, alias);
  }
}

class ValorColumnaData extends DataClass
    implements Insertable<ValorColumnaData> {
  final int id;
  final String nombre;
  final int idColumna;
  final int estado;
  const ValorColumnaData(
      {required this.id,
      required this.nombre,
      required this.idColumna,
      required this.estado});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['idColumna'] = Variable<int>(idColumna);
    map['estado'] = Variable<int>(estado);
    return map;
  }

  ValorColumnaCompanion toCompanion(bool nullToAbsent) {
    return ValorColumnaCompanion(
      id: Value(id),
      nombre: Value(nombre),
      idColumna: Value(idColumna),
      estado: Value(estado),
    );
  }

  factory ValorColumnaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ValorColumnaData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      idColumna: serializer.fromJson<int>(json['idColumna']),
      estado: serializer.fromJson<int>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'idColumna': serializer.toJson<int>(idColumna),
      'estado': serializer.toJson<int>(estado),
    };
  }

  ValorColumnaData copyWith(
          {int? id, String? nombre, int? idColumna, int? estado}) =>
      ValorColumnaData(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        idColumna: idColumna ?? this.idColumna,
        estado: estado ?? this.estado,
      );
  @override
  String toString() {
    return (StringBuffer('ValorColumnaData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('idColumna: $idColumna, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, idColumna, estado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ValorColumnaData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.idColumna == this.idColumna &&
          other.estado == this.estado);
}

class ValorColumnaCompanion extends UpdateCompanion<ValorColumnaData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> idColumna;
  final Value<int> estado;
  const ValorColumnaCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.idColumna = const Value.absent(),
    this.estado = const Value.absent(),
  });
  ValorColumnaCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required int idColumna,
    required int estado,
  })  : nombre = Value(nombre),
        idColumna = Value(idColumna),
        estado = Value(estado);
  static Insertable<ValorColumnaData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? idColumna,
    Expression<int>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (idColumna != null) 'idColumna': idColumna,
      if (estado != null) 'estado': estado,
    });
  }

  ValorColumnaCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<int>? idColumna,
      Value<int>? estado}) {
    return ValorColumnaCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      idColumna: idColumna ?? this.idColumna,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (idColumna.present) {
      map['idColumna'] = Variable<int>(idColumna.value);
    }
    if (estado.present) {
      map['estado'] = Variable<int>(estado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ValorColumnaCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('idColumna: $idColumna, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class $CancionValorColumnaTable extends CancionValorColumna
    with TableInfo<$CancionValorColumnaTable, CancionValorColumnaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CancionValorColumnaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idCancionMeta =
      const VerificationMeta('idCancion');
  @override
  late final GeneratedColumn<int> idCancion = GeneratedColumn<int>(
      'idCancion', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cancion (id)'));
  static const VerificationMeta _idValorPropiedadMeta =
      const VerificationMeta('idValorPropiedad');
  @override
  late final GeneratedColumn<int> idValorPropiedad = GeneratedColumn<int>(
      'idValorColumna', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES valor_columna (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, idCancion, idValorPropiedad];
  @override
  String get aliasedName => _alias ?? 'cancion_valor_columna';
  @override
  String get actualTableName => 'cancion_valor_columna';
  @override
  VerificationContext validateIntegrity(
      Insertable<CancionValorColumnaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('idCancion')) {
      context.handle(_idCancionMeta,
          idCancion.isAcceptableOrUnknown(data['idCancion']!, _idCancionMeta));
    } else if (isInserting) {
      context.missing(_idCancionMeta);
    }
    if (data.containsKey('idValorColumna')) {
      context.handle(
          _idValorPropiedadMeta,
          idValorPropiedad.isAcceptableOrUnknown(
              data['idValorColumna']!, _idValorPropiedadMeta));
    } else if (isInserting) {
      context.missing(_idValorPropiedadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CancionValorColumnaData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CancionValorColumnaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      idCancion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idCancion'])!,
      idValorPropiedad: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idValorColumna'])!,
    );
  }

  @override
  $CancionValorColumnaTable createAlias(String alias) {
    return $CancionValorColumnaTable(attachedDatabase, alias);
  }
}

class CancionValorColumnaData extends DataClass
    implements Insertable<CancionValorColumnaData> {
  final int id;
  final int idCancion;
  final int idValorPropiedad;
  const CancionValorColumnaData(
      {required this.id,
      required this.idCancion,
      required this.idValorPropiedad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['idCancion'] = Variable<int>(idCancion);
    map['idValorColumna'] = Variable<int>(idValorPropiedad);
    return map;
  }

  CancionValorColumnaCompanion toCompanion(bool nullToAbsent) {
    return CancionValorColumnaCompanion(
      id: Value(id),
      idCancion: Value(idCancion),
      idValorPropiedad: Value(idValorPropiedad),
    );
  }

  factory CancionValorColumnaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CancionValorColumnaData(
      id: serializer.fromJson<int>(json['id']),
      idCancion: serializer.fromJson<int>(json['idCancion']),
      idValorPropiedad: serializer.fromJson<int>(json['idValorPropiedad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idCancion': serializer.toJson<int>(idCancion),
      'idValorPropiedad': serializer.toJson<int>(idValorPropiedad),
    };
  }

  CancionValorColumnaData copyWith(
          {int? id, int? idCancion, int? idValorPropiedad}) =>
      CancionValorColumnaData(
        id: id ?? this.id,
        idCancion: idCancion ?? this.idCancion,
        idValorPropiedad: idValorPropiedad ?? this.idValorPropiedad,
      );
  @override
  String toString() {
    return (StringBuffer('CancionValorColumnaData(')
          ..write('id: $id, ')
          ..write('idCancion: $idCancion, ')
          ..write('idValorPropiedad: $idValorPropiedad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idCancion, idValorPropiedad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CancionValorColumnaData &&
          other.id == this.id &&
          other.idCancion == this.idCancion &&
          other.idValorPropiedad == this.idValorPropiedad);
}

class CancionValorColumnaCompanion
    extends UpdateCompanion<CancionValorColumnaData> {
  final Value<int> id;
  final Value<int> idCancion;
  final Value<int> idValorPropiedad;
  const CancionValorColumnaCompanion({
    this.id = const Value.absent(),
    this.idCancion = const Value.absent(),
    this.idValorPropiedad = const Value.absent(),
  });
  CancionValorColumnaCompanion.insert({
    this.id = const Value.absent(),
    required int idCancion,
    required int idValorPropiedad,
  })  : idCancion = Value(idCancion),
        idValorPropiedad = Value(idValorPropiedad);
  static Insertable<CancionValorColumnaData> custom({
    Expression<int>? id,
    Expression<int>? idCancion,
    Expression<int>? idValorPropiedad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idCancion != null) 'idCancion': idCancion,
      if (idValorPropiedad != null) 'idValorColumna': idValorPropiedad,
    });
  }

  CancionValorColumnaCompanion copyWith(
      {Value<int>? id, Value<int>? idCancion, Value<int>? idValorPropiedad}) {
    return CancionValorColumnaCompanion(
      id: id ?? this.id,
      idCancion: idCancion ?? this.idCancion,
      idValorPropiedad: idValorPropiedad ?? this.idValorPropiedad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idCancion.present) {
      map['idCancion'] = Variable<int>(idCancion.value);
    }
    if (idValorPropiedad.present) {
      map['idValorColumna'] = Variable<int>(idValorPropiedad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CancionValorColumnaCompanion(')
          ..write('id: $id, ')
          ..write('idCancion: $idCancion, ')
          ..write('idValorPropiedad: $idValorPropiedad')
          ..write(')'))
        .toString();
  }
}

class $ListaColumnasTable extends ListaColumnas
    with TableInfo<$ListaColumnasTable, ListaColumna> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListaColumnasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idListaRepMeta =
      const VerificationMeta('idListaRep');
  @override
  late final GeneratedColumn<int> idListaRep = GeneratedColumn<int>(
      'idListaRep', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lista_reproduccion (id)'));
  static const VerificationMeta _idColumnaMeta =
      const VerificationMeta('idColumna');
  @override
  late final GeneratedColumn<int> idColumna = GeneratedColumn<int>(
      'idColumna', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES columna (id)'));
  static const VerificationMeta _posicionMeta =
      const VerificationMeta('posicion');
  @override
  late final GeneratedColumn<int> posicion = GeneratedColumn<int>(
      'posicion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [idListaRep, idColumna, posicion];
  @override
  String get aliasedName => _alias ?? 'lista_columnas';
  @override
  String get actualTableName => 'lista_columnas';
  @override
  VerificationContext validateIntegrity(Insertable<ListaColumna> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('idListaRep')) {
      context.handle(
          _idListaRepMeta,
          idListaRep.isAcceptableOrUnknown(
              data['idListaRep']!, _idListaRepMeta));
    } else if (isInserting) {
      context.missing(_idListaRepMeta);
    }
    if (data.containsKey('idColumna')) {
      context.handle(_idColumnaMeta,
          idColumna.isAcceptableOrUnknown(data['idColumna']!, _idColumnaMeta));
    } else if (isInserting) {
      context.missing(_idColumnaMeta);
    }
    if (data.containsKey('posicion')) {
      context.handle(_posicionMeta,
          posicion.isAcceptableOrUnknown(data['posicion']!, _posicionMeta));
    } else if (isInserting) {
      context.missing(_posicionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ListaColumna map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListaColumna(
      idListaRep: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idListaRep'])!,
      idColumna: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}idColumna'])!,
      posicion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}posicion'])!,
    );
  }

  @override
  $ListaColumnasTable createAlias(String alias) {
    return $ListaColumnasTable(attachedDatabase, alias);
  }
}

class ListaColumna extends DataClass implements Insertable<ListaColumna> {
  final int idListaRep;
  final int idColumna;
  final int posicion;
  const ListaColumna(
      {required this.idListaRep,
      required this.idColumna,
      required this.posicion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['idListaRep'] = Variable<int>(idListaRep);
    map['idColumna'] = Variable<int>(idColumna);
    map['posicion'] = Variable<int>(posicion);
    return map;
  }

  ListaColumnasCompanion toCompanion(bool nullToAbsent) {
    return ListaColumnasCompanion(
      idListaRep: Value(idListaRep),
      idColumna: Value(idColumna),
      posicion: Value(posicion),
    );
  }

  factory ListaColumna.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListaColumna(
      idListaRep: serializer.fromJson<int>(json['idListaRep']),
      idColumna: serializer.fromJson<int>(json['idColumna']),
      posicion: serializer.fromJson<int>(json['posicion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idListaRep': serializer.toJson<int>(idListaRep),
      'idColumna': serializer.toJson<int>(idColumna),
      'posicion': serializer.toJson<int>(posicion),
    };
  }

  ListaColumna copyWith({int? idListaRep, int? idColumna, int? posicion}) =>
      ListaColumna(
        idListaRep: idListaRep ?? this.idListaRep,
        idColumna: idColumna ?? this.idColumna,
        posicion: posicion ?? this.posicion,
      );
  @override
  String toString() {
    return (StringBuffer('ListaColumna(')
          ..write('idListaRep: $idListaRep, ')
          ..write('idColumna: $idColumna, ')
          ..write('posicion: $posicion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idListaRep, idColumna, posicion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListaColumna &&
          other.idListaRep == this.idListaRep &&
          other.idColumna == this.idColumna &&
          other.posicion == this.posicion);
}

class ListaColumnasCompanion extends UpdateCompanion<ListaColumna> {
  final Value<int> idListaRep;
  final Value<int> idColumna;
  final Value<int> posicion;
  final Value<int> rowid;
  const ListaColumnasCompanion({
    this.idListaRep = const Value.absent(),
    this.idColumna = const Value.absent(),
    this.posicion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListaColumnasCompanion.insert({
    required int idListaRep,
    required int idColumna,
    required int posicion,
    this.rowid = const Value.absent(),
  })  : idListaRep = Value(idListaRep),
        idColumna = Value(idColumna),
        posicion = Value(posicion);
  static Insertable<ListaColumna> custom({
    Expression<int>? idListaRep,
    Expression<int>? idColumna,
    Expression<int>? posicion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idListaRep != null) 'idListaRep': idListaRep,
      if (idColumna != null) 'idColumna': idColumna,
      if (posicion != null) 'posicion': posicion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListaColumnasCompanion copyWith(
      {Value<int>? idListaRep,
      Value<int>? idColumna,
      Value<int>? posicion,
      Value<int>? rowid}) {
    return ListaColumnasCompanion(
      idListaRep: idListaRep ?? this.idListaRep,
      idColumna: idColumna ?? this.idColumna,
      posicion: posicion ?? this.posicion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idListaRep.present) {
      map['idListaRep'] = Variable<int>(idListaRep.value);
    }
    if (idColumna.present) {
      map['idColumna'] = Variable<int>(idColumna.value);
    }
    if (posicion.present) {
      map['posicion'] = Variable<int>(posicion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListaColumnasCompanion(')
          ..write('idListaRep: $idListaRep, ')
          ..write('idColumna: $idColumna, ')
          ..write('posicion: $posicion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  late final $ColumnaTable columna = $ColumnaTable(this);
  late final $ListaReproduccionTable listaReproduccion =
      $ListaReproduccionTable(this);
  late final $CancionTable cancion = $CancionTable(this);
  late final $CancionListaReproduccionTable cancionListaReproduccion =
      $CancionListaReproduccionTable(this);
  late final $ValorColumnaTable valorColumna = $ValorColumnaTable(this);
  late final $CancionValorColumnaTable cancionValorColumna =
      $CancionValorColumnaTable(this);
  late final $ListaColumnasTable listaColumnas = $ListaColumnasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        columna,
        listaReproduccion,
        cancion,
        cancionListaReproduccion,
        valorColumna,
        cancionValorColumna,
        listaColumnas
      ];
}
