// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoomsTable extends Rooms with TableInfo<$RoomsTable, RoomRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberCountMeta = const VerificationMeta(
    'memberCount',
  );
  @override
  late final GeneratedColumn<int> memberCount = GeneratedColumn<int>(
    'member_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMicrosMeta = const VerificationMeta(
    'createdAtMicros',
  );
  @override
  late final GeneratedColumn<int> createdAtMicros = GeneratedColumn<int>(
    'created_at_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasMoreHistoryMeta = const VerificationMeta(
    'hasMoreHistory',
  );
  @override
  late final GeneratedColumn<bool> hasMoreHistory = GeneratedColumn<bool>(
    'has_more_history',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_more_history" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    code,
    memberCount,
    createdAtMicros,
    hasMoreHistory,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('member_count')) {
      context.handle(
        _memberCountMeta,
        memberCount.isAcceptableOrUnknown(
          data['member_count']!,
          _memberCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at_micros')) {
      context.handle(
        _createdAtMicrosMeta,
        createdAtMicros.isAcceptableOrUnknown(
          data['created_at_micros']!,
          _createdAtMicrosMeta,
        ),
      );
    }
    if (data.containsKey('has_more_history')) {
      context.handle(
        _hasMoreHistoryMeta,
        hasMoreHistory.isAcceptableOrUnknown(
          data['has_more_history']!,
          _hasMoreHistoryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  RoomRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomRow(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      memberCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_count'],
      )!,
      createdAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_micros'],
      ),
      hasMoreHistory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_more_history'],
      )!,
    );
  }

  @override
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }
}

class RoomRow extends DataClass implements Insertable<RoomRow> {
  final String code;
  final int memberCount;
  final int? createdAtMicros;
  final bool hasMoreHistory;
  const RoomRow({
    required this.code,
    required this.memberCount,
    this.createdAtMicros,
    required this.hasMoreHistory,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['member_count'] = Variable<int>(memberCount);
    if (!nullToAbsent || createdAtMicros != null) {
      map['created_at_micros'] = Variable<int>(createdAtMicros);
    }
    map['has_more_history'] = Variable<bool>(hasMoreHistory);
    return map;
  }

  RoomsCompanion toCompanion(bool nullToAbsent) {
    return RoomsCompanion(
      code: Value(code),
      memberCount: Value(memberCount),
      createdAtMicros: createdAtMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAtMicros),
      hasMoreHistory: Value(hasMoreHistory),
    );
  }

  factory RoomRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomRow(
      code: serializer.fromJson<String>(json['code']),
      memberCount: serializer.fromJson<int>(json['memberCount']),
      createdAtMicros: serializer.fromJson<int?>(json['createdAtMicros']),
      hasMoreHistory: serializer.fromJson<bool>(json['hasMoreHistory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'memberCount': serializer.toJson<int>(memberCount),
      'createdAtMicros': serializer.toJson<int?>(createdAtMicros),
      'hasMoreHistory': serializer.toJson<bool>(hasMoreHistory),
    };
  }

  RoomRow copyWith({
    String? code,
    int? memberCount,
    Value<int?> createdAtMicros = const Value.absent(),
    bool? hasMoreHistory,
  }) => RoomRow(
    code: code ?? this.code,
    memberCount: memberCount ?? this.memberCount,
    createdAtMicros: createdAtMicros.present
        ? createdAtMicros.value
        : this.createdAtMicros,
    hasMoreHistory: hasMoreHistory ?? this.hasMoreHistory,
  );
  RoomRow copyWithCompanion(RoomsCompanion data) {
    return RoomRow(
      code: data.code.present ? data.code.value : this.code,
      memberCount: data.memberCount.present
          ? data.memberCount.value
          : this.memberCount,
      createdAtMicros: data.createdAtMicros.present
          ? data.createdAtMicros.value
          : this.createdAtMicros,
      hasMoreHistory: data.hasMoreHistory.present
          ? data.hasMoreHistory.value
          : this.hasMoreHistory,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomRow(')
          ..write('code: $code, ')
          ..write('memberCount: $memberCount, ')
          ..write('createdAtMicros: $createdAtMicros, ')
          ..write('hasMoreHistory: $hasMoreHistory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(code, memberCount, createdAtMicros, hasMoreHistory);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomRow &&
          other.code == this.code &&
          other.memberCount == this.memberCount &&
          other.createdAtMicros == this.createdAtMicros &&
          other.hasMoreHistory == this.hasMoreHistory);
}

class RoomsCompanion extends UpdateCompanion<RoomRow> {
  final Value<String> code;
  final Value<int> memberCount;
  final Value<int?> createdAtMicros;
  final Value<bool> hasMoreHistory;
  final Value<int> rowid;
  const RoomsCompanion({
    this.code = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.createdAtMicros = const Value.absent(),
    this.hasMoreHistory = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomsCompanion.insert({
    required String code,
    this.memberCount = const Value.absent(),
    this.createdAtMicros = const Value.absent(),
    this.hasMoreHistory = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : code = Value(code);
  static Insertable<RoomRow> custom({
    Expression<String>? code,
    Expression<int>? memberCount,
    Expression<int>? createdAtMicros,
    Expression<bool>? hasMoreHistory,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (memberCount != null) 'member_count': memberCount,
      if (createdAtMicros != null) 'created_at_micros': createdAtMicros,
      if (hasMoreHistory != null) 'has_more_history': hasMoreHistory,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomsCompanion copyWith({
    Value<String>? code,
    Value<int>? memberCount,
    Value<int?>? createdAtMicros,
    Value<bool>? hasMoreHistory,
    Value<int>? rowid,
  }) {
    return RoomsCompanion(
      code: code ?? this.code,
      memberCount: memberCount ?? this.memberCount,
      createdAtMicros: createdAtMicros ?? this.createdAtMicros,
      hasMoreHistory: hasMoreHistory ?? this.hasMoreHistory,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (memberCount.present) {
      map['member_count'] = Variable<int>(memberCount.value);
    }
    if (createdAtMicros.present) {
      map['created_at_micros'] = Variable<int>(createdAtMicros.value);
    }
    if (hasMoreHistory.present) {
      map['has_more_history'] = Variable<bool>(hasMoreHistory.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('code: $code, ')
          ..write('memberCount: $memberCount, ')
          ..write('createdAtMicros: $createdAtMicros, ')
          ..write('hasMoreHistory: $hasMoreHistory, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoomIdentitiesTable extends RoomIdentities
    with TableInfo<$RoomIdentitiesTable, RoomIdentityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomIdentitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _roomCodeMeta = const VerificationMeta(
    'roomCode',
  );
  @override
  late final GeneratedColumn<String> roomCode = GeneratedColumn<String>(
    'room_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acknowledgedMeta = const VerificationMeta(
    'acknowledged',
  );
  @override
  late final GeneratedColumn<bool> acknowledged = GeneratedColumn<bool>(
    'acknowledged',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("acknowledged" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    roomCode,
    uid,
    displayName,
    acknowledged,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'room_identities';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoomIdentityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('room_code')) {
      context.handle(
        _roomCodeMeta,
        roomCode.isAcceptableOrUnknown(data['room_code']!, _roomCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_roomCodeMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('acknowledged')) {
      context.handle(
        _acknowledgedMeta,
        acknowledged.isAcceptableOrUnknown(
          data['acknowledged']!,
          _acknowledgedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {roomCode};
  @override
  RoomIdentityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomIdentityRow(
      roomCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_code'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      acknowledged: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}acknowledged'],
      )!,
    );
  }

  @override
  $RoomIdentitiesTable createAlias(String alias) {
    return $RoomIdentitiesTable(attachedDatabase, alias);
  }
}

class RoomIdentityRow extends DataClass implements Insertable<RoomIdentityRow> {
  final String roomCode;
  final String uid;
  final String displayName;
  final bool acknowledged;
  const RoomIdentityRow({
    required this.roomCode,
    required this.uid,
    required this.displayName,
    required this.acknowledged,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['room_code'] = Variable<String>(roomCode);
    map['uid'] = Variable<String>(uid);
    map['display_name'] = Variable<String>(displayName);
    map['acknowledged'] = Variable<bool>(acknowledged);
    return map;
  }

  RoomIdentitiesCompanion toCompanion(bool nullToAbsent) {
    return RoomIdentitiesCompanion(
      roomCode: Value(roomCode),
      uid: Value(uid),
      displayName: Value(displayName),
      acknowledged: Value(acknowledged),
    );
  }

  factory RoomIdentityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomIdentityRow(
      roomCode: serializer.fromJson<String>(json['roomCode']),
      uid: serializer.fromJson<String>(json['uid']),
      displayName: serializer.fromJson<String>(json['displayName']),
      acknowledged: serializer.fromJson<bool>(json['acknowledged']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'roomCode': serializer.toJson<String>(roomCode),
      'uid': serializer.toJson<String>(uid),
      'displayName': serializer.toJson<String>(displayName),
      'acknowledged': serializer.toJson<bool>(acknowledged),
    };
  }

  RoomIdentityRow copyWith({
    String? roomCode,
    String? uid,
    String? displayName,
    bool? acknowledged,
  }) => RoomIdentityRow(
    roomCode: roomCode ?? this.roomCode,
    uid: uid ?? this.uid,
    displayName: displayName ?? this.displayName,
    acknowledged: acknowledged ?? this.acknowledged,
  );
  RoomIdentityRow copyWithCompanion(RoomIdentitiesCompanion data) {
    return RoomIdentityRow(
      roomCode: data.roomCode.present ? data.roomCode.value : this.roomCode,
      uid: data.uid.present ? data.uid.value : this.uid,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      acknowledged: data.acknowledged.present
          ? data.acknowledged.value
          : this.acknowledged,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomIdentityRow(')
          ..write('roomCode: $roomCode, ')
          ..write('uid: $uid, ')
          ..write('displayName: $displayName, ')
          ..write('acknowledged: $acknowledged')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(roomCode, uid, displayName, acknowledged);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomIdentityRow &&
          other.roomCode == this.roomCode &&
          other.uid == this.uid &&
          other.displayName == this.displayName &&
          other.acknowledged == this.acknowledged);
}

class RoomIdentitiesCompanion extends UpdateCompanion<RoomIdentityRow> {
  final Value<String> roomCode;
  final Value<String> uid;
  final Value<String> displayName;
  final Value<bool> acknowledged;
  final Value<int> rowid;
  const RoomIdentitiesCompanion({
    this.roomCode = const Value.absent(),
    this.uid = const Value.absent(),
    this.displayName = const Value.absent(),
    this.acknowledged = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomIdentitiesCompanion.insert({
    required String roomCode,
    required String uid,
    required String displayName,
    this.acknowledged = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : roomCode = Value(roomCode),
       uid = Value(uid),
       displayName = Value(displayName);
  static Insertable<RoomIdentityRow> custom({
    Expression<String>? roomCode,
    Expression<String>? uid,
    Expression<String>? displayName,
    Expression<bool>? acknowledged,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (roomCode != null) 'room_code': roomCode,
      if (uid != null) 'uid': uid,
      if (displayName != null) 'display_name': displayName,
      if (acknowledged != null) 'acknowledged': acknowledged,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomIdentitiesCompanion copyWith({
    Value<String>? roomCode,
    Value<String>? uid,
    Value<String>? displayName,
    Value<bool>? acknowledged,
    Value<int>? rowid,
  }) {
    return RoomIdentitiesCompanion(
      roomCode: roomCode ?? this.roomCode,
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      acknowledged: acknowledged ?? this.acknowledged,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (roomCode.present) {
      map['room_code'] = Variable<String>(roomCode.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (acknowledged.present) {
      map['acknowledged'] = Variable<bool>(acknowledged.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomIdentitiesCompanion(')
          ..write('roomCode: $roomCode, ')
          ..write('uid: $uid, ')
          ..write('displayName: $displayName, ')
          ..write('acknowledged: $acknowledged, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages
    with TableInfo<$MessagesTable, MessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomCodeMeta = const VerificationMeta(
    'roomCode',
  );
  @override
  late final GeneratedColumn<String> roomCode = GeneratedColumn<String>(
    'room_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderNameMeta = const VerificationMeta(
    'senderName',
  );
  @override
  late final GeneratedColumn<String> senderName = GeneratedColumn<String>(
    'sender_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMicrosMeta = const VerificationMeta(
    'createdAtMicros',
  );
  @override
  late final GeneratedColumn<int> createdAtMicros = GeneratedColumn<int>(
    'created_at_micros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortAtMicrosMeta = const VerificationMeta(
    'sortAtMicros',
  );
  @override
  late final GeneratedColumn<int> sortAtMicros = GeneratedColumn<int>(
    'sort_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roomCode,
    senderId,
    senderName,
    body,
    createdAtMicros,
    sortAtMicros,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('room_code')) {
      context.handle(
        _roomCodeMeta,
        roomCode.isAcceptableOrUnknown(data['room_code']!, _roomCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_roomCodeMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('sender_name')) {
      context.handle(
        _senderNameMeta,
        senderName.isAcceptableOrUnknown(data['sender_name']!, _senderNameMeta),
      );
    } else if (isInserting) {
      context.missing(_senderNameMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at_micros')) {
      context.handle(
        _createdAtMicrosMeta,
        createdAtMicros.isAcceptableOrUnknown(
          data['created_at_micros']!,
          _createdAtMicrosMeta,
        ),
      );
    }
    if (data.containsKey('sort_at_micros')) {
      context.handle(
        _sortAtMicrosMeta,
        sortAtMicros.isAcceptableOrUnknown(
          data['sort_at_micros']!,
          _sortAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sortAtMicrosMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      roomCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_code'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      senderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_name'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_micros'],
      ),
      sortAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_at_micros'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class MessageRow extends DataClass implements Insertable<MessageRow> {
  final String id;
  final String roomCode;
  final String senderId;
  final String senderName;
  final String body;
  final int? createdAtMicros;
  final int sortAtMicros;
  final int status;
  const MessageRow({
    required this.id,
    required this.roomCode,
    required this.senderId,
    required this.senderName,
    required this.body,
    this.createdAtMicros,
    required this.sortAtMicros,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['room_code'] = Variable<String>(roomCode);
    map['sender_id'] = Variable<String>(senderId);
    map['sender_name'] = Variable<String>(senderName);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || createdAtMicros != null) {
      map['created_at_micros'] = Variable<int>(createdAtMicros);
    }
    map['sort_at_micros'] = Variable<int>(sortAtMicros);
    map['status'] = Variable<int>(status);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      roomCode: Value(roomCode),
      senderId: Value(senderId),
      senderName: Value(senderName),
      body: Value(body),
      createdAtMicros: createdAtMicros == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAtMicros),
      sortAtMicros: Value(sortAtMicros),
      status: Value(status),
    );
  }

  factory MessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageRow(
      id: serializer.fromJson<String>(json['id']),
      roomCode: serializer.fromJson<String>(json['roomCode']),
      senderId: serializer.fromJson<String>(json['senderId']),
      senderName: serializer.fromJson<String>(json['senderName']),
      body: serializer.fromJson<String>(json['body']),
      createdAtMicros: serializer.fromJson<int?>(json['createdAtMicros']),
      sortAtMicros: serializer.fromJson<int>(json['sortAtMicros']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'roomCode': serializer.toJson<String>(roomCode),
      'senderId': serializer.toJson<String>(senderId),
      'senderName': serializer.toJson<String>(senderName),
      'body': serializer.toJson<String>(body),
      'createdAtMicros': serializer.toJson<int?>(createdAtMicros),
      'sortAtMicros': serializer.toJson<int>(sortAtMicros),
      'status': serializer.toJson<int>(status),
    };
  }

  MessageRow copyWith({
    String? id,
    String? roomCode,
    String? senderId,
    String? senderName,
    String? body,
    Value<int?> createdAtMicros = const Value.absent(),
    int? sortAtMicros,
    int? status,
  }) => MessageRow(
    id: id ?? this.id,
    roomCode: roomCode ?? this.roomCode,
    senderId: senderId ?? this.senderId,
    senderName: senderName ?? this.senderName,
    body: body ?? this.body,
    createdAtMicros: createdAtMicros.present
        ? createdAtMicros.value
        : this.createdAtMicros,
    sortAtMicros: sortAtMicros ?? this.sortAtMicros,
    status: status ?? this.status,
  );
  MessageRow copyWithCompanion(MessagesCompanion data) {
    return MessageRow(
      id: data.id.present ? data.id.value : this.id,
      roomCode: data.roomCode.present ? data.roomCode.value : this.roomCode,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      senderName: data.senderName.present
          ? data.senderName.value
          : this.senderName,
      body: data.body.present ? data.body.value : this.body,
      createdAtMicros: data.createdAtMicros.present
          ? data.createdAtMicros.value
          : this.createdAtMicros,
      sortAtMicros: data.sortAtMicros.present
          ? data.sortAtMicros.value
          : this.sortAtMicros,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageRow(')
          ..write('id: $id, ')
          ..write('roomCode: $roomCode, ')
          ..write('senderId: $senderId, ')
          ..write('senderName: $senderName, ')
          ..write('body: $body, ')
          ..write('createdAtMicros: $createdAtMicros, ')
          ..write('sortAtMicros: $sortAtMicros, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    roomCode,
    senderId,
    senderName,
    body,
    createdAtMicros,
    sortAtMicros,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageRow &&
          other.id == this.id &&
          other.roomCode == this.roomCode &&
          other.senderId == this.senderId &&
          other.senderName == this.senderName &&
          other.body == this.body &&
          other.createdAtMicros == this.createdAtMicros &&
          other.sortAtMicros == this.sortAtMicros &&
          other.status == this.status);
}

class MessagesCompanion extends UpdateCompanion<MessageRow> {
  final Value<String> id;
  final Value<String> roomCode;
  final Value<String> senderId;
  final Value<String> senderName;
  final Value<String> body;
  final Value<int?> createdAtMicros;
  final Value<int> sortAtMicros;
  final Value<int> status;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.roomCode = const Value.absent(),
    this.senderId = const Value.absent(),
    this.senderName = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAtMicros = const Value.absent(),
    this.sortAtMicros = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String roomCode,
    required String senderId,
    required String senderName,
    required String body,
    this.createdAtMicros = const Value.absent(),
    required int sortAtMicros,
    required int status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       roomCode = Value(roomCode),
       senderId = Value(senderId),
       senderName = Value(senderName),
       body = Value(body),
       sortAtMicros = Value(sortAtMicros),
       status = Value(status);
  static Insertable<MessageRow> custom({
    Expression<String>? id,
    Expression<String>? roomCode,
    Expression<String>? senderId,
    Expression<String>? senderName,
    Expression<String>? body,
    Expression<int>? createdAtMicros,
    Expression<int>? sortAtMicros,
    Expression<int>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomCode != null) 'room_code': roomCode,
      if (senderId != null) 'sender_id': senderId,
      if (senderName != null) 'sender_name': senderName,
      if (body != null) 'body': body,
      if (createdAtMicros != null) 'created_at_micros': createdAtMicros,
      if (sortAtMicros != null) 'sort_at_micros': sortAtMicros,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? roomCode,
    Value<String>? senderId,
    Value<String>? senderName,
    Value<String>? body,
    Value<int?>? createdAtMicros,
    Value<int>? sortAtMicros,
    Value<int>? status,
    Value<int>? rowid,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      roomCode: roomCode ?? this.roomCode,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      body: body ?? this.body,
      createdAtMicros: createdAtMicros ?? this.createdAtMicros,
      sortAtMicros: sortAtMicros ?? this.sortAtMicros,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (roomCode.present) {
      map['room_code'] = Variable<String>(roomCode.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (senderName.present) {
      map['sender_name'] = Variable<String>(senderName.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAtMicros.present) {
      map['created_at_micros'] = Variable<int>(createdAtMicros.value);
    }
    if (sortAtMicros.present) {
      map['sort_at_micros'] = Variable<int>(sortAtMicros.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('roomCode: $roomCode, ')
          ..write('senderId: $senderId, ')
          ..write('senderName: $senderName, ')
          ..write('body: $body, ')
          ..write('createdAtMicros: $createdAtMicros, ')
          ..write('sortAtMicros: $sortAtMicros, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, themeMode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    } else if (isInserting) {
      context.missing(_themeModeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingsRow extends DataClass implements Insertable<AppSettingsRow> {
  final int id;
  final String themeMode;
  const AppSettingsRow({required this.id, required this.themeMode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(id: Value(id), themeMode: Value(themeMode));
  }

  factory AppSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
    };
  }

  AppSettingsRow copyWith({int? id, String? themeMode}) =>
      AppSettingsRow(id: id ?? this.id, themeMode: themeMode ?? this.themeMode);
  AppSettingsRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRow(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, themeMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsRow &&
          other.id == this.id &&
          other.themeMode == this.themeMode);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingsRow> {
  final Value<int> id;
  final Value<String> themeMode;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String themeMode,
  }) : themeMode = Value(themeMode);
  static Insertable<AppSettingsRow> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
    });
  }

  AppSettingsCompanion copyWith({Value<int>? id, Value<String>? themeMode}) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final $RoomIdentitiesTable roomIdentities = $RoomIdentitiesTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final Index messagesRoomSort = Index(
    'messages_room_sort',
    'CREATE INDEX messages_room_sort ON messages (room_code, sort_at_micros)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    rooms,
    roomIdentities,
    messages,
    appSettings,
    messagesRoomSort,
  ];
}

typedef $$RoomsTableCreateCompanionBuilder =
    RoomsCompanion Function({
      required String code,
      Value<int> memberCount,
      Value<int?> createdAtMicros,
      Value<bool> hasMoreHistory,
      Value<int> rowid,
    });
typedef $$RoomsTableUpdateCompanionBuilder =
    RoomsCompanion Function({
      Value<String> code,
      Value<int> memberCount,
      Value<int?> createdAtMicros,
      Value<bool> hasMoreHistory,
      Value<int> rowid,
    });

class $$RoomsTableFilterComposer extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasMoreHistory => $composableBuilder(
    column: $table.hasMoreHistory,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasMoreHistory => $composableBuilder(
    column: $table.hasMoreHistory,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomsTable> {
  $$RoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasMoreHistory => $composableBuilder(
    column: $table.hasMoreHistory,
    builder: (column) => column,
  );
}

class $$RoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomsTable,
          RoomRow,
          $$RoomsTableFilterComposer,
          $$RoomsTableOrderingComposer,
          $$RoomsTableAnnotationComposer,
          $$RoomsTableCreateCompanionBuilder,
          $$RoomsTableUpdateCompanionBuilder,
          (RoomRow, BaseReferences<_$AppDatabase, $RoomsTable, RoomRow>),
          RoomRow,
          PrefetchHooks Function()
        > {
  $$RoomsTableTableManager(_$AppDatabase db, $RoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<int> memberCount = const Value.absent(),
                Value<int?> createdAtMicros = const Value.absent(),
                Value<bool> hasMoreHistory = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomsCompanion(
                code: code,
                memberCount: memberCount,
                createdAtMicros: createdAtMicros,
                hasMoreHistory: hasMoreHistory,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                Value<int> memberCount = const Value.absent(),
                Value<int?> createdAtMicros = const Value.absent(),
                Value<bool> hasMoreHistory = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomsCompanion.insert(
                code: code,
                memberCount: memberCount,
                createdAtMicros: createdAtMicros,
                hasMoreHistory: hasMoreHistory,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomsTable, RoomRow>(table),
                  BaseReferences<_$AppDatabase, $RoomsTable, RoomRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomsTable,
      RoomRow,
      $$RoomsTableFilterComposer,
      $$RoomsTableOrderingComposer,
      $$RoomsTableAnnotationComposer,
      $$RoomsTableCreateCompanionBuilder,
      $$RoomsTableUpdateCompanionBuilder,
      (RoomRow, BaseReferences<_$AppDatabase, $RoomsTable, RoomRow>),
      RoomRow,
      PrefetchHooks Function()
    >;
typedef $$RoomIdentitiesTableCreateCompanionBuilder =
    RoomIdentitiesCompanion Function({
      required String roomCode,
      required String uid,
      required String displayName,
      Value<bool> acknowledged,
      Value<int> rowid,
    });
typedef $$RoomIdentitiesTableUpdateCompanionBuilder =
    RoomIdentitiesCompanion Function({
      Value<String> roomCode,
      Value<String> uid,
      Value<String> displayName,
      Value<bool> acknowledged,
      Value<int> rowid,
    });

class $$RoomIdentitiesTableFilterComposer
    extends Composer<_$AppDatabase, $RoomIdentitiesTable> {
  $$RoomIdentitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get roomCode => $composableBuilder(
    column: $table.roomCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoomIdentitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoomIdentitiesTable> {
  $$RoomIdentitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get roomCode => $composableBuilder(
    column: $table.roomCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoomIdentitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoomIdentitiesTable> {
  $$RoomIdentitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get roomCode =>
      $composableBuilder(column: $table.roomCode, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get acknowledged => $composableBuilder(
    column: $table.acknowledged,
    builder: (column) => column,
  );
}

class $$RoomIdentitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoomIdentitiesTable,
          RoomIdentityRow,
          $$RoomIdentitiesTableFilterComposer,
          $$RoomIdentitiesTableOrderingComposer,
          $$RoomIdentitiesTableAnnotationComposer,
          $$RoomIdentitiesTableCreateCompanionBuilder,
          $$RoomIdentitiesTableUpdateCompanionBuilder,
          (
            RoomIdentityRow,
            BaseReferences<
              _$AppDatabase,
              $RoomIdentitiesTable,
              RoomIdentityRow
            >,
          ),
          RoomIdentityRow,
          PrefetchHooks Function()
        > {
  $$RoomIdentitiesTableTableManager(
    _$AppDatabase db,
    $RoomIdentitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomIdentitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomIdentitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomIdentitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> roomCode = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> acknowledged = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomIdentitiesCompanion(
                roomCode: roomCode,
                uid: uid,
                displayName: displayName,
                acknowledged: acknowledged,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String roomCode,
                required String uid,
                required String displayName,
                Value<bool> acknowledged = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoomIdentitiesCompanion.insert(
                roomCode: roomCode,
                uid: uid,
                displayName: displayName,
                acknowledged: acknowledged,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoomIdentitiesTable, RoomIdentityRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RoomIdentitiesTable,
                    RoomIdentityRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoomIdentitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoomIdentitiesTable,
      RoomIdentityRow,
      $$RoomIdentitiesTableFilterComposer,
      $$RoomIdentitiesTableOrderingComposer,
      $$RoomIdentitiesTableAnnotationComposer,
      $$RoomIdentitiesTableCreateCompanionBuilder,
      $$RoomIdentitiesTableUpdateCompanionBuilder,
      (
        RoomIdentityRow,
        BaseReferences<_$AppDatabase, $RoomIdentitiesTable, RoomIdentityRow>,
      ),
      RoomIdentityRow,
      PrefetchHooks Function()
    >;
typedef $$MessagesTableCreateCompanionBuilder =
    MessagesCompanion Function({
      required String id,
      required String roomCode,
      required String senderId,
      required String senderName,
      required String body,
      Value<int?> createdAtMicros,
      required int sortAtMicros,
      required int status,
      Value<int> rowid,
    });
typedef $$MessagesTableUpdateCompanionBuilder =
    MessagesCompanion Function({
      Value<String> id,
      Value<String> roomCode,
      Value<String> senderId,
      Value<String> senderName,
      Value<String> body,
      Value<int?> createdAtMicros,
      Value<int> sortAtMicros,
      Value<int> status,
      Value<int> rowid,
    });

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roomCode => $composableBuilder(
    column: $table.roomCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortAtMicros => $composableBuilder(
    column: $table.sortAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roomCode => $composableBuilder(
    column: $table.roomCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortAtMicros => $composableBuilder(
    column: $table.sortAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get roomCode =>
      $composableBuilder(column: $table.roomCode, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortAtMicros => $composableBuilder(
    column: $table.sortAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          MessageRow,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (
            MessageRow,
            BaseReferences<_$AppDatabase, $MessagesTable, MessageRow>,
          ),
          MessageRow,
          PrefetchHooks Function()
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> roomCode = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> senderName = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int?> createdAtMicros = const Value.absent(),
                Value<int> sortAtMicros = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                roomCode: roomCode,
                senderId: senderId,
                senderName: senderName,
                body: body,
                createdAtMicros: createdAtMicros,
                sortAtMicros: sortAtMicros,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String roomCode,
                required String senderId,
                required String senderName,
                required String body,
                Value<int?> createdAtMicros = const Value.absent(),
                required int sortAtMicros,
                required int status,
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                roomCode: roomCode,
                senderId: senderId,
                senderName: senderName,
                body: body,
                createdAtMicros: createdAtMicros,
                sortAtMicros: sortAtMicros,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessagesTable, MessageRow>(table),
                  BaseReferences<_$AppDatabase, $MessagesTable, MessageRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      MessageRow,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (MessageRow, BaseReferences<_$AppDatabase, $MessagesTable, MessageRow>),
      MessageRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({Value<int> id, required String themeMode});
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({Value<int> id, Value<String> themeMode});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingsRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingsRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingsRow>,
          ),
          AppSettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
              }) => AppSettingsCompanion(id: id, themeMode: themeMode),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String themeMode,
              }) => AppSettingsCompanion.insert(id: id, themeMode: themeMode),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSettingsRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTable,
                    AppSettingsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingsRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingsRow>,
      ),
      AppSettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db, _db.rooms);
  $$RoomIdentitiesTableTableManager get roomIdentities =>
      $$RoomIdentitiesTableTableManager(_db, _db.roomIdentities);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
