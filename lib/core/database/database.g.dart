// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cefrLevelMeta = const VerificationMeta(
    'cefrLevel',
  );
  @override
  late final GeneratedColumn<String> cefrLevel = GeneratedColumn<String>(
    'cefr_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    topic,
    cefrLevel,
    orderIndex,
    isLocked,
    isCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('cefr_level')) {
      context.handle(
        _cefrLevelMeta,
        cefrLevel.isAcceptableOrUnknown(data['cefr_level']!, _cefrLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_cefrLevelMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      cefrLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cefr_level'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      isLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_locked'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final int id;
  final String topic;
  final String cefrLevel;
  final int orderIndex;
  final bool isLocked;
  final bool isCompleted;
  const Lesson({
    required this.id,
    required this.topic,
    required this.cefrLevel,
    required this.orderIndex,
    required this.isLocked,
    required this.isCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['topic'] = Variable<String>(topic);
    map['cefr_level'] = Variable<String>(cefrLevel);
    map['order_index'] = Variable<int>(orderIndex);
    map['is_locked'] = Variable<bool>(isLocked);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      topic: Value(topic),
      cefrLevel: Value(cefrLevel),
      orderIndex: Value(orderIndex),
      isLocked: Value(isLocked),
      isCompleted: Value(isCompleted),
    );
  }

  factory Lesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<int>(json['id']),
      topic: serializer.fromJson<String>(json['topic']),
      cefrLevel: serializer.fromJson<String>(json['cefrLevel']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'topic': serializer.toJson<String>(topic),
      'cefrLevel': serializer.toJson<String>(cefrLevel),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'isLocked': serializer.toJson<bool>(isLocked),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  Lesson copyWith({
    int? id,
    String? topic,
    String? cefrLevel,
    int? orderIndex,
    bool? isLocked,
    bool? isCompleted,
  }) => Lesson(
    id: id ?? this.id,
    topic: topic ?? this.topic,
    cefrLevel: cefrLevel ?? this.cefrLevel,
    orderIndex: orderIndex ?? this.orderIndex,
    isLocked: isLocked ?? this.isLocked,
    isCompleted: isCompleted ?? this.isCompleted,
  );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      topic: data.topic.present ? data.topic.value : this.topic,
      cefrLevel: data.cefrLevel.present ? data.cefrLevel.value : this.cefrLevel,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('topic: $topic, ')
          ..write('cefrLevel: $cefrLevel, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isLocked: $isLocked, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, topic, cefrLevel, orderIndex, isLocked, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.topic == this.topic &&
          other.cefrLevel == this.cefrLevel &&
          other.orderIndex == this.orderIndex &&
          other.isLocked == this.isLocked &&
          other.isCompleted == this.isCompleted);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<int> id;
  final Value<String> topic;
  final Value<String> cefrLevel;
  final Value<int> orderIndex;
  final Value<bool> isLocked;
  final Value<bool> isCompleted;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.topic = const Value.absent(),
    this.cefrLevel = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
  LessonsCompanion.insert({
    this.id = const Value.absent(),
    required String topic,
    required String cefrLevel,
    required int orderIndex,
    this.isLocked = const Value.absent(),
    this.isCompleted = const Value.absent(),
  }) : topic = Value(topic),
       cefrLevel = Value(cefrLevel),
       orderIndex = Value(orderIndex);
  static Insertable<Lesson> custom({
    Expression<int>? id,
    Expression<String>? topic,
    Expression<String>? cefrLevel,
    Expression<int>? orderIndex,
    Expression<bool>? isLocked,
    Expression<bool>? isCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topic != null) 'topic': topic,
      if (cefrLevel != null) 'cefr_level': cefrLevel,
      if (orderIndex != null) 'order_index': orderIndex,
      if (isLocked != null) 'is_locked': isLocked,
      if (isCompleted != null) 'is_completed': isCompleted,
    });
  }

  LessonsCompanion copyWith({
    Value<int>? id,
    Value<String>? topic,
    Value<String>? cefrLevel,
    Value<int>? orderIndex,
    Value<bool>? isLocked,
    Value<bool>? isCompleted,
  }) {
    return LessonsCompanion(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      orderIndex: orderIndex ?? this.orderIndex,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (cefrLevel.present) {
      map['cefr_level'] = Variable<String>(cefrLevel.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('topic: $topic, ')
          ..write('cefrLevel: $cefrLevel, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isLocked: $isLocked, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }
}

class $VocabWordsTable extends VocabWords
    with TableInfo<$VocabWordsTable, VocabWord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabWordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lessons (id)',
    ),
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('new'),
  );
  static const VerificationMeta _nextReviewDateMeta = const VerificationMeta(
    'nextReviewDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewDate =
      GeneratedColumn<DateTime>(
        'next_review_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _easinessFactorMeta = const VerificationMeta(
    'easinessFactor',
  );
  @override
  late final GeneratedColumn<double> easinessFactor = GeneratedColumn<double>(
    'easiness_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalMeta = const VerificationMeta(
    'interval',
  );
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lessonId,
    word,
    translation,
    audioUrl,
    status,
    nextReviewDate,
    repetitions,
    easinessFactor,
    interval,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocab_words';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabWord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('next_review_date')) {
      context.handle(
        _nextReviewDateMeta,
        nextReviewDate.isAcceptableOrUnknown(
          data['next_review_date']!,
          _nextReviewDateMeta,
        ),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('easiness_factor')) {
      context.handle(
        _easinessFactorMeta,
        easinessFactor.isAcceptableOrUnknown(
          data['easiness_factor']!,
          _easinessFactorMeta,
        ),
      );
    }
    if (data.containsKey('interval')) {
      context.handle(
        _intervalMeta,
        interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabWord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabWord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      nextReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_date'],
      ),
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      easinessFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}easiness_factor'],
      )!,
      interval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval'],
      )!,
    );
  }

  @override
  $VocabWordsTable createAlias(String alias) {
    return $VocabWordsTable(attachedDatabase, alias);
  }
}

class VocabWord extends DataClass implements Insertable<VocabWord> {
  final int id;
  final int lessonId;
  final String word;
  final String translation;
  final String? audioUrl;
  final String status;
  final DateTime? nextReviewDate;
  final int repetitions;
  final double easinessFactor;
  final int interval;
  const VocabWord({
    required this.id,
    required this.lessonId,
    required this.word,
    required this.translation,
    this.audioUrl,
    required this.status,
    this.nextReviewDate,
    required this.repetitions,
    required this.easinessFactor,
    required this.interval,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<int>(lessonId);
    map['word'] = Variable<String>(word);
    map['translation'] = Variable<String>(translation);
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || nextReviewDate != null) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate);
    }
    map['repetitions'] = Variable<int>(repetitions);
    map['easiness_factor'] = Variable<double>(easinessFactor);
    map['interval'] = Variable<int>(interval);
    return map;
  }

  VocabWordsCompanion toCompanion(bool nullToAbsent) {
    return VocabWordsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      word: Value(word),
      translation: Value(translation),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      status: Value(status),
      nextReviewDate: nextReviewDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewDate),
      repetitions: Value(repetitions),
      easinessFactor: Value(easinessFactor),
      interval: Value(interval),
    );
  }

  factory VocabWord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabWord(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      word: serializer.fromJson<String>(json['word']),
      translation: serializer.fromJson<String>(json['translation']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      status: serializer.fromJson<String>(json['status']),
      nextReviewDate: serializer.fromJson<DateTime?>(json['nextReviewDate']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      easinessFactor: serializer.fromJson<double>(json['easinessFactor']),
      interval: serializer.fromJson<int>(json['interval']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<int>(lessonId),
      'word': serializer.toJson<String>(word),
      'translation': serializer.toJson<String>(translation),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'status': serializer.toJson<String>(status),
      'nextReviewDate': serializer.toJson<DateTime?>(nextReviewDate),
      'repetitions': serializer.toJson<int>(repetitions),
      'easinessFactor': serializer.toJson<double>(easinessFactor),
      'interval': serializer.toJson<int>(interval),
    };
  }

  VocabWord copyWith({
    int? id,
    int? lessonId,
    String? word,
    String? translation,
    Value<String?> audioUrl = const Value.absent(),
    String? status,
    Value<DateTime?> nextReviewDate = const Value.absent(),
    int? repetitions,
    double? easinessFactor,
    int? interval,
  }) => VocabWord(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    word: word ?? this.word,
    translation: translation ?? this.translation,
    audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
    status: status ?? this.status,
    nextReviewDate: nextReviewDate.present
        ? nextReviewDate.value
        : this.nextReviewDate,
    repetitions: repetitions ?? this.repetitions,
    easinessFactor: easinessFactor ?? this.easinessFactor,
    interval: interval ?? this.interval,
  );
  VocabWord copyWithCompanion(VocabWordsCompanion data) {
    return VocabWord(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      word: data.word.present ? data.word.value : this.word,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      status: data.status.present ? data.status.value : this.status,
      nextReviewDate: data.nextReviewDate.present
          ? data.nextReviewDate.value
          : this.nextReviewDate,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      easinessFactor: data.easinessFactor.present
          ? data.easinessFactor.value
          : this.easinessFactor,
      interval: data.interval.present ? data.interval.value : this.interval,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabWord(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('word: $word, ')
          ..write('translation: $translation, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('status: $status, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('repetitions: $repetitions, ')
          ..write('easinessFactor: $easinessFactor, ')
          ..write('interval: $interval')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lessonId,
    word,
    translation,
    audioUrl,
    status,
    nextReviewDate,
    repetitions,
    easinessFactor,
    interval,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabWord &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.word == this.word &&
          other.translation == this.translation &&
          other.audioUrl == this.audioUrl &&
          other.status == this.status &&
          other.nextReviewDate == this.nextReviewDate &&
          other.repetitions == this.repetitions &&
          other.easinessFactor == this.easinessFactor &&
          other.interval == this.interval);
}

class VocabWordsCompanion extends UpdateCompanion<VocabWord> {
  final Value<int> id;
  final Value<int> lessonId;
  final Value<String> word;
  final Value<String> translation;
  final Value<String?> audioUrl;
  final Value<String> status;
  final Value<DateTime?> nextReviewDate;
  final Value<int> repetitions;
  final Value<double> easinessFactor;
  final Value<int> interval;
  const VocabWordsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.word = const Value.absent(),
    this.translation = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.easinessFactor = const Value.absent(),
    this.interval = const Value.absent(),
  });
  VocabWordsCompanion.insert({
    this.id = const Value.absent(),
    required int lessonId,
    required String word,
    required String translation,
    this.audioUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.easinessFactor = const Value.absent(),
    this.interval = const Value.absent(),
  }) : lessonId = Value(lessonId),
       word = Value(word),
       translation = Value(translation);
  static Insertable<VocabWord> custom({
    Expression<int>? id,
    Expression<int>? lessonId,
    Expression<String>? word,
    Expression<String>? translation,
    Expression<String>? audioUrl,
    Expression<String>? status,
    Expression<DateTime>? nextReviewDate,
    Expression<int>? repetitions,
    Expression<double>? easinessFactor,
    Expression<int>? interval,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (word != null) 'word': word,
      if (translation != null) 'translation': translation,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (status != null) 'status': status,
      if (nextReviewDate != null) 'next_review_date': nextReviewDate,
      if (repetitions != null) 'repetitions': repetitions,
      if (easinessFactor != null) 'easiness_factor': easinessFactor,
      if (interval != null) 'interval': interval,
    });
  }

  VocabWordsCompanion copyWith({
    Value<int>? id,
    Value<int>? lessonId,
    Value<String>? word,
    Value<String>? translation,
    Value<String?>? audioUrl,
    Value<String>? status,
    Value<DateTime?>? nextReviewDate,
    Value<int>? repetitions,
    Value<double>? easinessFactor,
    Value<int>? interval,
  }) {
    return VocabWordsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      audioUrl: audioUrl ?? this.audioUrl,
      status: status ?? this.status,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      repetitions: repetitions ?? this.repetitions,
      easinessFactor: easinessFactor ?? this.easinessFactor,
      interval: interval ?? this.interval,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (nextReviewDate.present) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (easinessFactor.present) {
      map['easiness_factor'] = Variable<double>(easinessFactor.value);
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabWordsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('word: $word, ')
          ..write('translation: $translation, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('status: $status, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('repetitions: $repetitions, ')
          ..write('easinessFactor: $easinessFactor, ')
          ..write('interval: $interval')
          ..write(')'))
        .toString();
  }
}

class $OfflineReviewLogsTable extends OfflineReviewLogs
    with TableInfo<$OfflineReviewLogsTable, OfflineReviewLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vocabWordIdMeta = const VerificationMeta(
    'vocabWordId',
  );
  @override
  late final GeneratedColumn<int> vocabWordId = GeneratedColumn<int>(
    'vocab_word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vocab_words (id)',
    ),
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, vocabWordId, quality, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_review_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineReviewLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vocab_word_id')) {
      context.handle(
        _vocabWordIdMeta,
        vocabWordId.isAcceptableOrUnknown(
          data['vocab_word_id']!,
          _vocabWordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vocabWordIdMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    } else if (isInserting) {
      context.missing(_qualityMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineReviewLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineReviewLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vocabWordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vocab_word_id'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $OfflineReviewLogsTable createAlias(String alias) {
    return $OfflineReviewLogsTable(attachedDatabase, alias);
  }
}

class OfflineReviewLog extends DataClass
    implements Insertable<OfflineReviewLog> {
  final int id;
  final int vocabWordId;
  final int quality;
  final DateTime timestamp;
  const OfflineReviewLog({
    required this.id,
    required this.vocabWordId,
    required this.quality,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vocab_word_id'] = Variable<int>(vocabWordId);
    map['quality'] = Variable<int>(quality);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  OfflineReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return OfflineReviewLogsCompanion(
      id: Value(id),
      vocabWordId: Value(vocabWordId),
      quality: Value(quality),
      timestamp: Value(timestamp),
    );
  }

  factory OfflineReviewLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineReviewLog(
      id: serializer.fromJson<int>(json['id']),
      vocabWordId: serializer.fromJson<int>(json['vocabWordId']),
      quality: serializer.fromJson<int>(json['quality']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vocabWordId': serializer.toJson<int>(vocabWordId),
      'quality': serializer.toJson<int>(quality),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  OfflineReviewLog copyWith({
    int? id,
    int? vocabWordId,
    int? quality,
    DateTime? timestamp,
  }) => OfflineReviewLog(
    id: id ?? this.id,
    vocabWordId: vocabWordId ?? this.vocabWordId,
    quality: quality ?? this.quality,
    timestamp: timestamp ?? this.timestamp,
  );
  OfflineReviewLog copyWithCompanion(OfflineReviewLogsCompanion data) {
    return OfflineReviewLog(
      id: data.id.present ? data.id.value : this.id,
      vocabWordId: data.vocabWordId.present
          ? data.vocabWordId.value
          : this.vocabWordId,
      quality: data.quality.present ? data.quality.value : this.quality,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineReviewLog(')
          ..write('id: $id, ')
          ..write('vocabWordId: $vocabWordId, ')
          ..write('quality: $quality, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vocabWordId, quality, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineReviewLog &&
          other.id == this.id &&
          other.vocabWordId == this.vocabWordId &&
          other.quality == this.quality &&
          other.timestamp == this.timestamp);
}

class OfflineReviewLogsCompanion extends UpdateCompanion<OfflineReviewLog> {
  final Value<int> id;
  final Value<int> vocabWordId;
  final Value<int> quality;
  final Value<DateTime> timestamp;
  const OfflineReviewLogsCompanion({
    this.id = const Value.absent(),
    this.vocabWordId = const Value.absent(),
    this.quality = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  OfflineReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    required int vocabWordId,
    required int quality,
    required DateTime timestamp,
  }) : vocabWordId = Value(vocabWordId),
       quality = Value(quality),
       timestamp = Value(timestamp);
  static Insertable<OfflineReviewLog> custom({
    Expression<int>? id,
    Expression<int>? vocabWordId,
    Expression<int>? quality,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabWordId != null) 'vocab_word_id': vocabWordId,
      if (quality != null) 'quality': quality,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  OfflineReviewLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? vocabWordId,
    Value<int>? quality,
    Value<DateTime>? timestamp,
  }) {
    return OfflineReviewLogsCompanion(
      id: id ?? this.id,
      vocabWordId: vocabWordId ?? this.vocabWordId,
      quality: quality ?? this.quality,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vocabWordId.present) {
      map['vocab_word_id'] = Variable<int>(vocabWordId.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('vocabWordId: $vocabWordId, ')
          ..write('quality: $quality, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _totalXpMeta = const VerificationMeta(
    'totalXp',
  );
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
    'total_xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastActivityDateMeta = const VerificationMeta(
    'lastActivityDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastActivityDate =
      GeneratedColumn<DateTime>(
        'last_activity_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _streakFreezesMeta = const VerificationMeta(
    'streakFreezes',
  );
  @override
  late final GeneratedColumn<int> streakFreezes = GeneratedColumn<int>(
    'streak_freezes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    totalXp,
    level,
    currentStreak,
    lastActivityDate,
    streakFreezes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('total_xp')) {
      context.handle(
        _totalXpMeta,
        totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('last_activity_date')) {
      context.handle(
        _lastActivityDateMeta,
        lastActivityDate.isAcceptableOrUnknown(
          data['last_activity_date']!,
          _lastActivityDateMeta,
        ),
      );
    }
    if (data.containsKey('streak_freezes')) {
      context.handle(
        _streakFreezesMeta,
        streakFreezes.isAcceptableOrUnknown(
          data['streak_freezes']!,
          _streakFreezesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      totalXp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_xp'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      lastActivityDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_activity_date'],
      ),
      streakFreezes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_freezes'],
      )!,
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressEntry extends DataClass
    implements Insertable<UserProgressEntry> {
  final int id;
  final int totalXp;
  final int level;
  final int currentStreak;
  final DateTime? lastActivityDate;
  final int streakFreezes;
  const UserProgressEntry({
    required this.id,
    required this.totalXp,
    required this.level,
    required this.currentStreak,
    this.lastActivityDate,
    required this.streakFreezes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['total_xp'] = Variable<int>(totalXp);
    map['level'] = Variable<int>(level);
    map['current_streak'] = Variable<int>(currentStreak);
    if (!nullToAbsent || lastActivityDate != null) {
      map['last_activity_date'] = Variable<DateTime>(lastActivityDate);
    }
    map['streak_freezes'] = Variable<int>(streakFreezes);
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      id: Value(id),
      totalXp: Value(totalXp),
      level: Value(level),
      currentStreak: Value(currentStreak),
      lastActivityDate: lastActivityDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActivityDate),
      streakFreezes: Value(streakFreezes),
    );
  }

  factory UserProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressEntry(
      id: serializer.fromJson<int>(json['id']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
      level: serializer.fromJson<int>(json['level']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      lastActivityDate: serializer.fromJson<DateTime?>(
        json['lastActivityDate'],
      ),
      streakFreezes: serializer.fromJson<int>(json['streakFreezes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'totalXp': serializer.toJson<int>(totalXp),
      'level': serializer.toJson<int>(level),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'lastActivityDate': serializer.toJson<DateTime?>(lastActivityDate),
      'streakFreezes': serializer.toJson<int>(streakFreezes),
    };
  }

  UserProgressEntry copyWith({
    int? id,
    int? totalXp,
    int? level,
    int? currentStreak,
    Value<DateTime?> lastActivityDate = const Value.absent(),
    int? streakFreezes,
  }) => UserProgressEntry(
    id: id ?? this.id,
    totalXp: totalXp ?? this.totalXp,
    level: level ?? this.level,
    currentStreak: currentStreak ?? this.currentStreak,
    lastActivityDate: lastActivityDate.present
        ? lastActivityDate.value
        : this.lastActivityDate,
    streakFreezes: streakFreezes ?? this.streakFreezes,
  );
  UserProgressEntry copyWithCompanion(UserProgressCompanion data) {
    return UserProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
      level: data.level.present ? data.level.value : this.level,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      lastActivityDate: data.lastActivityDate.present
          ? data.lastActivityDate.value
          : this.lastActivityDate,
      streakFreezes: data.streakFreezes.present
          ? data.streakFreezes.value
          : this.streakFreezes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressEntry(')
          ..write('id: $id, ')
          ..write('totalXp: $totalXp, ')
          ..write('level: $level, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('lastActivityDate: $lastActivityDate, ')
          ..write('streakFreezes: $streakFreezes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    totalXp,
    level,
    currentStreak,
    lastActivityDate,
    streakFreezes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressEntry &&
          other.id == this.id &&
          other.totalXp == this.totalXp &&
          other.level == this.level &&
          other.currentStreak == this.currentStreak &&
          other.lastActivityDate == this.lastActivityDate &&
          other.streakFreezes == this.streakFreezes);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressEntry> {
  final Value<int> id;
  final Value<int> totalXp;
  final Value<int> level;
  final Value<int> currentStreak;
  final Value<DateTime?> lastActivityDate;
  final Value<int> streakFreezes;
  const UserProgressCompanion({
    this.id = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.level = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.lastActivityDate = const Value.absent(),
    this.streakFreezes = const Value.absent(),
  });
  UserProgressCompanion.insert({
    this.id = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.level = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.lastActivityDate = const Value.absent(),
    this.streakFreezes = const Value.absent(),
  });
  static Insertable<UserProgressEntry> custom({
    Expression<int>? id,
    Expression<int>? totalXp,
    Expression<int>? level,
    Expression<int>? currentStreak,
    Expression<DateTime>? lastActivityDate,
    Expression<int>? streakFreezes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalXp != null) 'total_xp': totalXp,
      if (level != null) 'level': level,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (lastActivityDate != null) 'last_activity_date': lastActivityDate,
      if (streakFreezes != null) 'streak_freezes': streakFreezes,
    });
  }

  UserProgressCompanion copyWith({
    Value<int>? id,
    Value<int>? totalXp,
    Value<int>? level,
    Value<int>? currentStreak,
    Value<DateTime?>? lastActivityDate,
    Value<int>? streakFreezes,
  }) {
    return UserProgressCompanion(
      id: id ?? this.id,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      streakFreezes: streakFreezes ?? this.streakFreezes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (lastActivityDate.present) {
      map['last_activity_date'] = Variable<DateTime>(lastActivityDate.value);
    }
    if (streakFreezes.present) {
      map['streak_freezes'] = Variable<int>(streakFreezes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('id: $id, ')
          ..write('totalXp: $totalXp, ')
          ..write('level: $level, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('lastActivityDate: $lastActivityDate, ')
          ..write('streakFreezes: $streakFreezes')
          ..write(')'))
        .toString();
  }
}

class $DailyXpTable extends DailyXp
    with TableInfo<$DailyXpTable, DailyXpEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyXpTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpEarnedMeta = const VerificationMeta(
    'xpEarned',
  );
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
    'xp_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, xpEarned];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_xp';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyXpEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('xp_earned')) {
      context.handle(
        _xpEarnedMeta,
        xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyXpEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyXpEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      xpEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_earned'],
      )!,
    );
  }

  @override
  $DailyXpTable createAlias(String alias) {
    return $DailyXpTable(attachedDatabase, alias);
  }
}

class DailyXpEntry extends DataClass implements Insertable<DailyXpEntry> {
  final int id;
  final DateTime date;
  final int xpEarned;
  const DailyXpEntry({
    required this.id,
    required this.date,
    required this.xpEarned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['xp_earned'] = Variable<int>(xpEarned);
    return map;
  }

  DailyXpCompanion toCompanion(bool nullToAbsent) {
    return DailyXpCompanion(
      id: Value(id),
      date: Value(date),
      xpEarned: Value(xpEarned),
    );
  }

  factory DailyXpEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyXpEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'xpEarned': serializer.toJson<int>(xpEarned),
    };
  }

  DailyXpEntry copyWith({int? id, DateTime? date, int? xpEarned}) =>
      DailyXpEntry(
        id: id ?? this.id,
        date: date ?? this.date,
        xpEarned: xpEarned ?? this.xpEarned,
      );
  DailyXpEntry copyWithCompanion(DailyXpCompanion data) {
    return DailyXpEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyXpEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('xpEarned: $xpEarned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, xpEarned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyXpEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.xpEarned == this.xpEarned);
}

class DailyXpCompanion extends UpdateCompanion<DailyXpEntry> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> xpEarned;
  const DailyXpCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.xpEarned = const Value.absent(),
  });
  DailyXpCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.xpEarned = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyXpEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? xpEarned,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (xpEarned != null) 'xp_earned': xpEarned,
    });
  }

  DailyXpCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? xpEarned,
  }) {
    return DailyXpCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      xpEarned: xpEarned ?? this.xpEarned,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyXpCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('xpEarned: $xpEarned')
          ..write(')'))
        .toString();
  }
}

class $OfflineXpLogsTable extends OfflineXpLogs
    with TableInfo<$OfflineXpLogsTable, OfflineXpLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineXpLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _xpAmountMeta = const VerificationMeta(
    'xpAmount',
  );
  @override
  late final GeneratedColumn<int> xpAmount = GeneratedColumn<int>(
    'xp_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, xpAmount, reason, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_xp_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineXpLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('xp_amount')) {
      context.handle(
        _xpAmountMeta,
        xpAmount.isAcceptableOrUnknown(data['xp_amount']!, _xpAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_xpAmountMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineXpLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineXpLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      xpAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_amount'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $OfflineXpLogsTable createAlias(String alias) {
    return $OfflineXpLogsTable(attachedDatabase, alias);
  }
}

class OfflineXpLog extends DataClass implements Insertable<OfflineXpLog> {
  final int id;
  final int xpAmount;
  final String reason;
  final DateTime timestamp;
  const OfflineXpLog({
    required this.id,
    required this.xpAmount,
    required this.reason,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['xp_amount'] = Variable<int>(xpAmount);
    map['reason'] = Variable<String>(reason);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  OfflineXpLogsCompanion toCompanion(bool nullToAbsent) {
    return OfflineXpLogsCompanion(
      id: Value(id),
      xpAmount: Value(xpAmount),
      reason: Value(reason),
      timestamp: Value(timestamp),
    );
  }

  factory OfflineXpLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineXpLog(
      id: serializer.fromJson<int>(json['id']),
      xpAmount: serializer.fromJson<int>(json['xpAmount']),
      reason: serializer.fromJson<String>(json['reason']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'xpAmount': serializer.toJson<int>(xpAmount),
      'reason': serializer.toJson<String>(reason),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  OfflineXpLog copyWith({
    int? id,
    int? xpAmount,
    String? reason,
    DateTime? timestamp,
  }) => OfflineXpLog(
    id: id ?? this.id,
    xpAmount: xpAmount ?? this.xpAmount,
    reason: reason ?? this.reason,
    timestamp: timestamp ?? this.timestamp,
  );
  OfflineXpLog copyWithCompanion(OfflineXpLogsCompanion data) {
    return OfflineXpLog(
      id: data.id.present ? data.id.value : this.id,
      xpAmount: data.xpAmount.present ? data.xpAmount.value : this.xpAmount,
      reason: data.reason.present ? data.reason.value : this.reason,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineXpLog(')
          ..write('id: $id, ')
          ..write('xpAmount: $xpAmount, ')
          ..write('reason: $reason, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, xpAmount, reason, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineXpLog &&
          other.id == this.id &&
          other.xpAmount == this.xpAmount &&
          other.reason == this.reason &&
          other.timestamp == this.timestamp);
}

class OfflineXpLogsCompanion extends UpdateCompanion<OfflineXpLog> {
  final Value<int> id;
  final Value<int> xpAmount;
  final Value<String> reason;
  final Value<DateTime> timestamp;
  const OfflineXpLogsCompanion({
    this.id = const Value.absent(),
    this.xpAmount = const Value.absent(),
    this.reason = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  OfflineXpLogsCompanion.insert({
    this.id = const Value.absent(),
    required int xpAmount,
    required String reason,
    required DateTime timestamp,
  }) : xpAmount = Value(xpAmount),
       reason = Value(reason),
       timestamp = Value(timestamp);
  static Insertable<OfflineXpLog> custom({
    Expression<int>? id,
    Expression<int>? xpAmount,
    Expression<String>? reason,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (xpAmount != null) 'xp_amount': xpAmount,
      if (reason != null) 'reason': reason,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  OfflineXpLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? xpAmount,
    Value<String>? reason,
    Value<DateTime>? timestamp,
  }) {
    return OfflineXpLogsCompanion(
      id: id ?? this.id,
      xpAmount: xpAmount ?? this.xpAmount,
      reason: reason ?? this.reason,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (xpAmount.present) {
      map['xp_amount'] = Variable<int>(xpAmount.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineXpLogsCompanion(')
          ..write('id: $id, ')
          ..write('xpAmount: $xpAmount, ')
          ..write('reason: $reason, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $VocabWordsTable vocabWords = $VocabWordsTable(this);
  late final $OfflineReviewLogsTable offlineReviewLogs =
      $OfflineReviewLogsTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $DailyXpTable dailyXp = $DailyXpTable(this);
  late final $OfflineXpLogsTable offlineXpLogs = $OfflineXpLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    lessons,
    vocabWords,
    offlineReviewLogs,
    userProgress,
    dailyXp,
    offlineXpLogs,
  ];
}

typedef $$LessonsTableCreateCompanionBuilder =
    LessonsCompanion Function({
      Value<int> id,
      required String topic,
      required String cefrLevel,
      required int orderIndex,
      Value<bool> isLocked,
      Value<bool> isCompleted,
    });
typedef $$LessonsTableUpdateCompanionBuilder =
    LessonsCompanion Function({
      Value<int> id,
      Value<String> topic,
      Value<String> cefrLevel,
      Value<int> orderIndex,
      Value<bool> isLocked,
      Value<bool> isCompleted,
    });

final class $$LessonsTableReferences
    extends BaseReferences<_$AppDatabase, $LessonsTable, Lesson> {
  $$LessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VocabWordsTable, List<VocabWord>>
  _vocabWordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vocabWords,
    aliasName: 'lessons__id__vocab_words__lesson_id',
  );

  $$VocabWordsTableProcessedTableManager get vocabWordsRefs {
    final manager = $$VocabWordsTableTableManager(
      $_db,
      $_db.vocabWords,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_vocabWordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
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

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cefrLevel => $composableBuilder(
    column: $table.cefrLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vocabWordsRefs(
    Expression<bool> Function($$VocabWordsTableFilterComposer f) f,
  ) {
    final $$VocabWordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabWords,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabWordsTableFilterComposer(
            $db: $db,
            $table: $db.vocabWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
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

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cefrLevel => $composableBuilder(
    column: $table.cefrLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get cefrLevel =>
      $composableBuilder(column: $table.cefrLevel, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  Expression<T> vocabWordsRefs<T extends Object>(
    Expression<T> Function($$VocabWordsTableAnnotationComposer a) f,
  ) {
    final $$VocabWordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabWords,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabWordsTableAnnotationComposer(
            $db: $db,
            $table: $db.vocabWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonsTable,
          Lesson,
          $$LessonsTableFilterComposer,
          $$LessonsTableOrderingComposer,
          $$LessonsTableAnnotationComposer,
          $$LessonsTableCreateCompanionBuilder,
          $$LessonsTableUpdateCompanionBuilder,
          (Lesson, $$LessonsTableReferences),
          Lesson,
          PrefetchHooks Function({bool vocabWordsRefs})
        > {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<String> cefrLevel = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
              }) => LessonsCompanion(
                id: id,
                topic: topic,
                cefrLevel: cefrLevel,
                orderIndex: orderIndex,
                isLocked: isLocked,
                isCompleted: isCompleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String topic,
                required String cefrLevel,
                required int orderIndex,
                Value<bool> isLocked = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
              }) => LessonsCompanion.insert(
                id: id,
                topic: topic,
                cefrLevel: cefrLevel,
                orderIndex: orderIndex,
                isLocked: isLocked,
                isCompleted: isCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LessonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vocabWordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vocabWordsRefs) db.vocabWords],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vocabWordsRefs)
                    await $_getPrefetchedData<Lesson, $LessonsTable, VocabWord>(
                      currentTable: table,
                      referencedTable: $$LessonsTableReferences
                          ._vocabWordsRefsTable(db),
                      managerFromTypedResult: (p0) => $$LessonsTableReferences(
                        db,
                        table,
                        p0,
                      ).vocabWordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.lessonId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonsTable,
      Lesson,
      $$LessonsTableFilterComposer,
      $$LessonsTableOrderingComposer,
      $$LessonsTableAnnotationComposer,
      $$LessonsTableCreateCompanionBuilder,
      $$LessonsTableUpdateCompanionBuilder,
      (Lesson, $$LessonsTableReferences),
      Lesson,
      PrefetchHooks Function({bool vocabWordsRefs})
    >;
typedef $$VocabWordsTableCreateCompanionBuilder =
    VocabWordsCompanion Function({
      Value<int> id,
      required int lessonId,
      required String word,
      required String translation,
      Value<String?> audioUrl,
      Value<String> status,
      Value<DateTime?> nextReviewDate,
      Value<int> repetitions,
      Value<double> easinessFactor,
      Value<int> interval,
    });
typedef $$VocabWordsTableUpdateCompanionBuilder =
    VocabWordsCompanion Function({
      Value<int> id,
      Value<int> lessonId,
      Value<String> word,
      Value<String> translation,
      Value<String?> audioUrl,
      Value<String> status,
      Value<DateTime?> nextReviewDate,
      Value<int> repetitions,
      Value<double> easinessFactor,
      Value<int> interval,
    });

final class $$VocabWordsTableReferences
    extends BaseReferences<_$AppDatabase, $VocabWordsTable, VocabWord> {
  $$VocabWordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LessonsTable _lessonIdTable(_$AppDatabase db) =>
      db.lessons.createAlias('vocab_words__lesson_id__lessons__id');

  $$LessonsTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$LessonsTableTableManager(
      $_db,
      $_db.lessons,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OfflineReviewLogsTable, List<OfflineReviewLog>>
  _offlineReviewLogsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.offlineReviewLogs,
        aliasName: 'vocab_words__id__offline_review_logs__vocab_word_id',
      );

  $$OfflineReviewLogsTableProcessedTableManager get offlineReviewLogsRefs {
    final manager = $$OfflineReviewLogsTableTableManager(
      $_db,
      $_db.offlineReviewLogs,
    ).filter((f) => f.vocabWordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _offlineReviewLogsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VocabWordsTableFilterComposer
    extends Composer<_$AppDatabase, $VocabWordsTable> {
  $$VocabWordsTableFilterComposer({
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

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get easinessFactor => $composableBuilder(
    column: $table.easinessFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnFilters(column),
  );

  $$LessonsTableFilterComposer get lessonId {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableFilterComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> offlineReviewLogsRefs(
    Expression<bool> Function($$OfflineReviewLogsTableFilterComposer f) f,
  ) {
    final $$OfflineReviewLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.offlineReviewLogs,
      getReferencedColumn: (t) => t.vocabWordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfflineReviewLogsTableFilterComposer(
            $db: $db,
            $table: $db.offlineReviewLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VocabWordsTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabWordsTable> {
  $$VocabWordsTableOrderingComposer({
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

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get easinessFactor => $composableBuilder(
    column: $table.easinessFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interval => $composableBuilder(
    column: $table.interval,
    builder: (column) => ColumnOrderings(column),
  );

  $$LessonsTableOrderingComposer get lessonId {
    final $$LessonsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableOrderingComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabWordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabWordsTable> {
  $$VocabWordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get easinessFactor => $composableBuilder(
    column: $table.easinessFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  $$LessonsTableAnnotationComposer get lessonId {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.lessons,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> offlineReviewLogsRefs<T extends Object>(
    Expression<T> Function($$OfflineReviewLogsTableAnnotationComposer a) f,
  ) {
    final $$OfflineReviewLogsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.offlineReviewLogs,
          getReferencedColumn: (t) => t.vocabWordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OfflineReviewLogsTableAnnotationComposer(
                $db: $db,
                $table: $db.offlineReviewLogs,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$VocabWordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VocabWordsTable,
          VocabWord,
          $$VocabWordsTableFilterComposer,
          $$VocabWordsTableOrderingComposer,
          $$VocabWordsTableAnnotationComposer,
          $$VocabWordsTableCreateCompanionBuilder,
          $$VocabWordsTableUpdateCompanionBuilder,
          (VocabWord, $$VocabWordsTableReferences),
          VocabWord,
          PrefetchHooks Function({bool lessonId, bool offlineReviewLogsRefs})
        > {
  $$VocabWordsTableTableManager(_$AppDatabase db, $VocabWordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabWordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabWordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabWordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<String?> audioUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> nextReviewDate = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<double> easinessFactor = const Value.absent(),
                Value<int> interval = const Value.absent(),
              }) => VocabWordsCompanion(
                id: id,
                lessonId: lessonId,
                word: word,
                translation: translation,
                audioUrl: audioUrl,
                status: status,
                nextReviewDate: nextReviewDate,
                repetitions: repetitions,
                easinessFactor: easinessFactor,
                interval: interval,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lessonId,
                required String word,
                required String translation,
                Value<String?> audioUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> nextReviewDate = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<double> easinessFactor = const Value.absent(),
                Value<int> interval = const Value.absent(),
              }) => VocabWordsCompanion.insert(
                id: id,
                lessonId: lessonId,
                word: word,
                translation: translation,
                audioUrl: audioUrl,
                status: status,
                nextReviewDate: nextReviewDate,
                repetitions: repetitions,
                easinessFactor: easinessFactor,
                interval: interval,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VocabWordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({lessonId = false, offlineReviewLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (offlineReviewLogsRefs) db.offlineReviewLogs,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (lessonId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.lessonId,
                                    referencedTable: $$VocabWordsTableReferences
                                        ._lessonIdTable(db),
                                    referencedColumn:
                                        $$VocabWordsTableReferences
                                            ._lessonIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (offlineReviewLogsRefs)
                        await $_getPrefetchedData<
                          VocabWord,
                          $VocabWordsTable,
                          OfflineReviewLog
                        >(
                          currentTable: table,
                          referencedTable: $$VocabWordsTableReferences
                              ._offlineReviewLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VocabWordsTableReferences(
                                db,
                                table,
                                p0,
                              ).offlineReviewLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vocabWordId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VocabWordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VocabWordsTable,
      VocabWord,
      $$VocabWordsTableFilterComposer,
      $$VocabWordsTableOrderingComposer,
      $$VocabWordsTableAnnotationComposer,
      $$VocabWordsTableCreateCompanionBuilder,
      $$VocabWordsTableUpdateCompanionBuilder,
      (VocabWord, $$VocabWordsTableReferences),
      VocabWord,
      PrefetchHooks Function({bool lessonId, bool offlineReviewLogsRefs})
    >;
typedef $$OfflineReviewLogsTableCreateCompanionBuilder =
    OfflineReviewLogsCompanion Function({
      Value<int> id,
      required int vocabWordId,
      required int quality,
      required DateTime timestamp,
    });
typedef $$OfflineReviewLogsTableUpdateCompanionBuilder =
    OfflineReviewLogsCompanion Function({
      Value<int> id,
      Value<int> vocabWordId,
      Value<int> quality,
      Value<DateTime> timestamp,
    });

final class $$OfflineReviewLogsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OfflineReviewLogsTable,
          OfflineReviewLog
        > {
  $$OfflineReviewLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VocabWordsTable _vocabWordIdTable(_$AppDatabase db) => db.vocabWords
      .createAlias('offline_review_logs__vocab_word_id__vocab_words__id');

  $$VocabWordsTableProcessedTableManager get vocabWordId {
    final $_column = $_itemColumn<int>('vocab_word_id')!;

    final manager = $$VocabWordsTableTableManager(
      $_db,
      $_db.vocabWords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vocabWordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OfflineReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineReviewLogsTable> {
  $$OfflineReviewLogsTableFilterComposer({
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

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  $$VocabWordsTableFilterComposer get vocabWordId {
    final $$VocabWordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabWordId,
      referencedTable: $db.vocabWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabWordsTableFilterComposer(
            $db: $db,
            $table: $db.vocabWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfflineReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineReviewLogsTable> {
  $$OfflineReviewLogsTableOrderingComposer({
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

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  $$VocabWordsTableOrderingComposer get vocabWordId {
    final $$VocabWordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabWordId,
      referencedTable: $db.vocabWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabWordsTableOrderingComposer(
            $db: $db,
            $table: $db.vocabWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfflineReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineReviewLogsTable> {
  $$OfflineReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$VocabWordsTableAnnotationComposer get vocabWordId {
    final $$VocabWordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabWordId,
      referencedTable: $db.vocabWords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabWordsTableAnnotationComposer(
            $db: $db,
            $table: $db.vocabWords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfflineReviewLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineReviewLogsTable,
          OfflineReviewLog,
          $$OfflineReviewLogsTableFilterComposer,
          $$OfflineReviewLogsTableOrderingComposer,
          $$OfflineReviewLogsTableAnnotationComposer,
          $$OfflineReviewLogsTableCreateCompanionBuilder,
          $$OfflineReviewLogsTableUpdateCompanionBuilder,
          (OfflineReviewLog, $$OfflineReviewLogsTableReferences),
          OfflineReviewLog,
          PrefetchHooks Function({bool vocabWordId})
        > {
  $$OfflineReviewLogsTableTableManager(
    _$AppDatabase db,
    $OfflineReviewLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineReviewLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vocabWordId = const Value.absent(),
                Value<int> quality = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => OfflineReviewLogsCompanion(
                id: id,
                vocabWordId: vocabWordId,
                quality: quality,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vocabWordId,
                required int quality,
                required DateTime timestamp,
              }) => OfflineReviewLogsCompanion.insert(
                id: id,
                vocabWordId: vocabWordId,
                quality: quality,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OfflineReviewLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vocabWordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vocabWordId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vocabWordId,
                                referencedTable:
                                    $$OfflineReviewLogsTableReferences
                                        ._vocabWordIdTable(db),
                                referencedColumn:
                                    $$OfflineReviewLogsTableReferences
                                        ._vocabWordIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OfflineReviewLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineReviewLogsTable,
      OfflineReviewLog,
      $$OfflineReviewLogsTableFilterComposer,
      $$OfflineReviewLogsTableOrderingComposer,
      $$OfflineReviewLogsTableAnnotationComposer,
      $$OfflineReviewLogsTableCreateCompanionBuilder,
      $$OfflineReviewLogsTableUpdateCompanionBuilder,
      (OfflineReviewLog, $$OfflineReviewLogsTableReferences),
      OfflineReviewLog,
      PrefetchHooks Function({bool vocabWordId})
    >;
typedef $$UserProgressTableCreateCompanionBuilder =
    UserProgressCompanion Function({
      Value<int> id,
      Value<int> totalXp,
      Value<int> level,
      Value<int> currentStreak,
      Value<DateTime?> lastActivityDate,
      Value<int> streakFreezes,
    });
typedef $$UserProgressTableUpdateCompanionBuilder =
    UserProgressCompanion Function({
      Value<int> id,
      Value<int> totalXp,
      Value<int> level,
      Value<int> currentStreak,
      Value<DateTime?> lastActivityDate,
      Value<int> streakFreezes,
    });

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
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

  ColumnFilters<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastActivityDate => $composableBuilder(
    column: $table.lastActivityDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakFreezes => $composableBuilder(
    column: $table.streakFreezes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
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

  ColumnOrderings<int> get totalXp => $composableBuilder(
    column: $table.totalXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastActivityDate => $composableBuilder(
    column: $table.lastActivityDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakFreezes => $composableBuilder(
    column: $table.streakFreezes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastActivityDate => $composableBuilder(
    column: $table.lastActivityDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakFreezes => $composableBuilder(
    column: $table.streakFreezes,
    builder: (column) => column,
  );
}

class $$UserProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProgressTable,
          UserProgressEntry,
          $$UserProgressTableFilterComposer,
          $$UserProgressTableOrderingComposer,
          $$UserProgressTableAnnotationComposer,
          $$UserProgressTableCreateCompanionBuilder,
          $$UserProgressTableUpdateCompanionBuilder,
          (
            UserProgressEntry,
            BaseReferences<
              _$AppDatabase,
              $UserProgressTable,
              UserProgressEntry
            >,
          ),
          UserProgressEntry,
          PrefetchHooks Function()
        > {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<DateTime?> lastActivityDate = const Value.absent(),
                Value<int> streakFreezes = const Value.absent(),
              }) => UserProgressCompanion(
                id: id,
                totalXp: totalXp,
                level: level,
                currentStreak: currentStreak,
                lastActivityDate: lastActivityDate,
                streakFreezes: streakFreezes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> totalXp = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<DateTime?> lastActivityDate = const Value.absent(),
                Value<int> streakFreezes = const Value.absent(),
              }) => UserProgressCompanion.insert(
                id: id,
                totalXp: totalXp,
                level: level,
                currentStreak: currentStreak,
                lastActivityDate: lastActivityDate,
                streakFreezes: streakFreezes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProgressTable,
      UserProgressEntry,
      $$UserProgressTableFilterComposer,
      $$UserProgressTableOrderingComposer,
      $$UserProgressTableAnnotationComposer,
      $$UserProgressTableCreateCompanionBuilder,
      $$UserProgressTableUpdateCompanionBuilder,
      (
        UserProgressEntry,
        BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressEntry>,
      ),
      UserProgressEntry,
      PrefetchHooks Function()
    >;
typedef $$DailyXpTableCreateCompanionBuilder =
    DailyXpCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int> xpEarned,
    });
typedef $$DailyXpTableUpdateCompanionBuilder =
    DailyXpCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> xpEarned,
    });

class $$DailyXpTableFilterComposer
    extends Composer<_$AppDatabase, $DailyXpTable> {
  $$DailyXpTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpEarned => $composableBuilder(
    column: $table.xpEarned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyXpTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyXpTable> {
  $$DailyXpTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpEarned => $composableBuilder(
    column: $table.xpEarned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyXpTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyXpTable> {
  $$DailyXpTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);
}

class $$DailyXpTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyXpTable,
          DailyXpEntry,
          $$DailyXpTableFilterComposer,
          $$DailyXpTableOrderingComposer,
          $$DailyXpTableAnnotationComposer,
          $$DailyXpTableCreateCompanionBuilder,
          $$DailyXpTableUpdateCompanionBuilder,
          (
            DailyXpEntry,
            BaseReferences<_$AppDatabase, $DailyXpTable, DailyXpEntry>,
          ),
          DailyXpEntry,
          PrefetchHooks Function()
        > {
  $$DailyXpTableTableManager(_$AppDatabase db, $DailyXpTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyXpTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyXpTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyXpTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> xpEarned = const Value.absent(),
              }) => DailyXpCompanion(id: id, date: date, xpEarned: xpEarned),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int> xpEarned = const Value.absent(),
              }) => DailyXpCompanion.insert(
                id: id,
                date: date,
                xpEarned: xpEarned,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyXpTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyXpTable,
      DailyXpEntry,
      $$DailyXpTableFilterComposer,
      $$DailyXpTableOrderingComposer,
      $$DailyXpTableAnnotationComposer,
      $$DailyXpTableCreateCompanionBuilder,
      $$DailyXpTableUpdateCompanionBuilder,
      (
        DailyXpEntry,
        BaseReferences<_$AppDatabase, $DailyXpTable, DailyXpEntry>,
      ),
      DailyXpEntry,
      PrefetchHooks Function()
    >;
typedef $$OfflineXpLogsTableCreateCompanionBuilder =
    OfflineXpLogsCompanion Function({
      Value<int> id,
      required int xpAmount,
      required String reason,
      required DateTime timestamp,
    });
typedef $$OfflineXpLogsTableUpdateCompanionBuilder =
    OfflineXpLogsCompanion Function({
      Value<int> id,
      Value<int> xpAmount,
      Value<String> reason,
      Value<DateTime> timestamp,
    });

class $$OfflineXpLogsTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineXpLogsTable> {
  $$OfflineXpLogsTableFilterComposer({
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

  ColumnFilters<int> get xpAmount => $composableBuilder(
    column: $table.xpAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineXpLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineXpLogsTable> {
  $$OfflineXpLogsTableOrderingComposer({
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

  ColumnOrderings<int> get xpAmount => $composableBuilder(
    column: $table.xpAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineXpLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineXpLogsTable> {
  $$OfflineXpLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get xpAmount =>
      $composableBuilder(column: $table.xpAmount, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$OfflineXpLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineXpLogsTable,
          OfflineXpLog,
          $$OfflineXpLogsTableFilterComposer,
          $$OfflineXpLogsTableOrderingComposer,
          $$OfflineXpLogsTableAnnotationComposer,
          $$OfflineXpLogsTableCreateCompanionBuilder,
          $$OfflineXpLogsTableUpdateCompanionBuilder,
          (
            OfflineXpLog,
            BaseReferences<_$AppDatabase, $OfflineXpLogsTable, OfflineXpLog>,
          ),
          OfflineXpLog,
          PrefetchHooks Function()
        > {
  $$OfflineXpLogsTableTableManager(_$AppDatabase db, $OfflineXpLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineXpLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineXpLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineXpLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> xpAmount = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => OfflineXpLogsCompanion(
                id: id,
                xpAmount: xpAmount,
                reason: reason,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int xpAmount,
                required String reason,
                required DateTime timestamp,
              }) => OfflineXpLogsCompanion.insert(
                id: id,
                xpAmount: xpAmount,
                reason: reason,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineXpLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineXpLogsTable,
      OfflineXpLog,
      $$OfflineXpLogsTableFilterComposer,
      $$OfflineXpLogsTableOrderingComposer,
      $$OfflineXpLogsTableAnnotationComposer,
      $$OfflineXpLogsTableCreateCompanionBuilder,
      $$OfflineXpLogsTableUpdateCompanionBuilder,
      (
        OfflineXpLog,
        BaseReferences<_$AppDatabase, $OfflineXpLogsTable, OfflineXpLog>,
      ),
      OfflineXpLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$VocabWordsTableTableManager get vocabWords =>
      $$VocabWordsTableTableManager(_db, _db.vocabWords);
  $$OfflineReviewLogsTableTableManager get offlineReviewLogs =>
      $$OfflineReviewLogsTableTableManager(_db, _db.offlineReviewLogs);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$DailyXpTableTableManager get dailyXp =>
      $$DailyXpTableTableManager(_db, _db.dailyXp);
  $$OfflineXpLogsTableTableManager get offlineXpLogs =>
      $$OfflineXpLogsTableTableManager(_db, _db.offlineXpLogs);
}
