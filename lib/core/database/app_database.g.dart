// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, icon, isDefault, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final String? description;
  final String icon;
  final bool isDefault;
  final DateTime createdAt;
  const Category(
      {required this.id,
      required this.name,
      this.description,
      required this.icon,
      required this.isDefault,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['icon'] = Variable<String>(icon);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: Value(icon),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String>(json['icon']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String>(icon),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Category copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          String? icon,
          bool? isDefault,
          DateTime? createdAt}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        icon: icon ?? this.icon,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, icon, isDefault, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> icon;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String icon,
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        icon = Value(icon),
        createdAt = Value(createdAt);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? icon,
      Value<bool>? isDefault,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  final DateTime createdAt;
  const Tag({required this.id, required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tag copyWith({String? id, String? name, DateTime? createdAt}) => Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TreasuresTable extends Treasures
    with TableInfo<$TreasuresTable, Treasure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreasuresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shortDescriptionMeta =
      const VerificationMeta('shortDescription');
  @override
  late final GeneratedColumn<String> shortDescription = GeneratedColumn<String>(
      'short_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _problemMeta =
      const VerificationMeta('problem');
  @override
  late final GeneratedColumn<String> problem = GeneratedColumn<String>(
      'problem', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _solutionMeta =
      const VerificationMeta('solution');
  @override
  late final GeneratedColumn<String> solution = GeneratedColumn<String>(
      'solution', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _whyUsefulMeta =
      const VerificationMeta('whyUseful');
  @override
  late final GeneratedColumn<String> whyUseful = GeneratedColumn<String>(
      'why_useful', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('idea'));
  static const VerificationMeta _deviceMeta = const VerificationMeta('device');
  @override
  late final GeneratedColumn<String> device = GeneratedColumn<String>(
      'device', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _platformMeta =
      const VerificationMeta('platform');
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
      'platform', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _osVersionMeta =
      const VerificationMeta('osVersion');
  @override
  late final GeneratedColumn<String> osVersion = GeneratedColumn<String>(
      'os_version', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _requirementsMeta =
      const VerificationMeta('requirements');
  @override
  late final GeneratedColumn<String> requirements = GeneratedColumn<String>(
      'requirements', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stepsJsonMeta =
      const VerificationMeta('stepsJson');
  @override
  late final GeneratedColumn<String> stepsJson = GeneratedColumn<String>(
      'steps_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _limitationsMeta =
      const VerificationMeta('limitations');
  @override
  late final GeneratedColumn<String> limitations = GeneratedColumn<String>(
      'limitations', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _securityNotesMeta =
      const VerificationMeta('securityNotes');
  @override
  late final GeneratedColumn<String> securityNotes = GeneratedColumn<String>(
      'security_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _researchStatusMeta =
      const VerificationMeta('researchStatus');
  @override
  late final GeneratedColumn<String> researchStatus = GeneratedColumn<String>(
      'research_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('notResearched'));
  static const VerificationMeta _isVerifiedMeta =
      const VerificationMeta('isVerified');
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
      'is_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_verified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _noAppNeededMeta =
      const VerificationMeta('noAppNeeded');
  @override
  late final GeneratedColumn<bool> noAppNeeded = GeneratedColumn<bool>(
      'no_app_needed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("no_app_needed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _contentPotentialMeta =
      const VerificationMeta('contentPotential');
  @override
  late final GeneratedColumn<int> contentPotential = GeneratedColumn<int>(
      'content_potential', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        shortDescription,
        problem,
        solution,
        whyUseful,
        categoryId,
        status,
        device,
        platform,
        osVersion,
        requirements,
        stepsJson,
        limitations,
        securityNotes,
        researchStatus,
        isVerified,
        isFavorite,
        noAppNeeded,
        contentPotential,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treasures';
  @override
  VerificationContext validateIntegrity(Insertable<Treasure> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('short_description')) {
      context.handle(
          _shortDescriptionMeta,
          shortDescription.isAcceptableOrUnknown(
              data['short_description']!, _shortDescriptionMeta));
    } else if (isInserting) {
      context.missing(_shortDescriptionMeta);
    }
    if (data.containsKey('problem')) {
      context.handle(_problemMeta,
          problem.isAcceptableOrUnknown(data['problem']!, _problemMeta));
    }
    if (data.containsKey('solution')) {
      context.handle(_solutionMeta,
          solution.isAcceptableOrUnknown(data['solution']!, _solutionMeta));
    }
    if (data.containsKey('why_useful')) {
      context.handle(_whyUsefulMeta,
          whyUseful.isAcceptableOrUnknown(data['why_useful']!, _whyUsefulMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('device')) {
      context.handle(_deviceMeta,
          device.isAcceptableOrUnknown(data['device']!, _deviceMeta));
    }
    if (data.containsKey('platform')) {
      context.handle(_platformMeta,
          platform.isAcceptableOrUnknown(data['platform']!, _platformMeta));
    }
    if (data.containsKey('os_version')) {
      context.handle(_osVersionMeta,
          osVersion.isAcceptableOrUnknown(data['os_version']!, _osVersionMeta));
    }
    if (data.containsKey('requirements')) {
      context.handle(
          _requirementsMeta,
          requirements.isAcceptableOrUnknown(
              data['requirements']!, _requirementsMeta));
    }
    if (data.containsKey('steps_json')) {
      context.handle(_stepsJsonMeta,
          stepsJson.isAcceptableOrUnknown(data['steps_json']!, _stepsJsonMeta));
    }
    if (data.containsKey('limitations')) {
      context.handle(
          _limitationsMeta,
          limitations.isAcceptableOrUnknown(
              data['limitations']!, _limitationsMeta));
    }
    if (data.containsKey('security_notes')) {
      context.handle(
          _securityNotesMeta,
          securityNotes.isAcceptableOrUnknown(
              data['security_notes']!, _securityNotesMeta));
    }
    if (data.containsKey('research_status')) {
      context.handle(
          _researchStatusMeta,
          researchStatus.isAcceptableOrUnknown(
              data['research_status']!, _researchStatusMeta));
    }
    if (data.containsKey('is_verified')) {
      context.handle(
          _isVerifiedMeta,
          isVerified.isAcceptableOrUnknown(
              data['is_verified']!, _isVerifiedMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('no_app_needed')) {
      context.handle(
          _noAppNeededMeta,
          noAppNeeded.isAcceptableOrUnknown(
              data['no_app_needed']!, _noAppNeededMeta));
    }
    if (data.containsKey('content_potential')) {
      context.handle(
          _contentPotentialMeta,
          contentPotential.isAcceptableOrUnknown(
              data['content_potential']!, _contentPotentialMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Treasure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Treasure(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      shortDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}short_description'])!,
      problem: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}problem']),
      solution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}solution']),
      whyUseful: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}why_useful']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      device: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device']),
      platform: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}platform']),
      osVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}os_version']),
      requirements: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}requirements']),
      stepsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}steps_json']),
      limitations: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}limitations']),
      securityNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}security_notes']),
      researchStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}research_status'])!,
      isVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_verified'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      noAppNeeded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}no_app_needed'])!,
      contentPotential: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}content_potential'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TreasuresTable createAlias(String alias) {
    return $TreasuresTable(attachedDatabase, alias);
  }
}

class Treasure extends DataClass implements Insertable<Treasure> {
  final String id;
  final String title;
  final String shortDescription;
  final String? problem;
  final String? solution;
  final String? whyUseful;
  final String categoryId;
  final String status;
  final String? device;
  final String? platform;
  final String? osVersion;
  final String? requirements;
  final String? stepsJson;
  final String? limitations;
  final String? securityNotes;
  final String researchStatus;
  final bool isVerified;
  final bool isFavorite;
  final bool noAppNeeded;
  final int contentPotential;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Treasure(
      {required this.id,
      required this.title,
      required this.shortDescription,
      this.problem,
      this.solution,
      this.whyUseful,
      required this.categoryId,
      required this.status,
      this.device,
      this.platform,
      this.osVersion,
      this.requirements,
      this.stepsJson,
      this.limitations,
      this.securityNotes,
      required this.researchStatus,
      required this.isVerified,
      required this.isFavorite,
      required this.noAppNeeded,
      required this.contentPotential,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['short_description'] = Variable<String>(shortDescription);
    if (!nullToAbsent || problem != null) {
      map['problem'] = Variable<String>(problem);
    }
    if (!nullToAbsent || solution != null) {
      map['solution'] = Variable<String>(solution);
    }
    if (!nullToAbsent || whyUseful != null) {
      map['why_useful'] = Variable<String>(whyUseful);
    }
    map['category_id'] = Variable<String>(categoryId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || device != null) {
      map['device'] = Variable<String>(device);
    }
    if (!nullToAbsent || platform != null) {
      map['platform'] = Variable<String>(platform);
    }
    if (!nullToAbsent || osVersion != null) {
      map['os_version'] = Variable<String>(osVersion);
    }
    if (!nullToAbsent || requirements != null) {
      map['requirements'] = Variable<String>(requirements);
    }
    if (!nullToAbsent || stepsJson != null) {
      map['steps_json'] = Variable<String>(stepsJson);
    }
    if (!nullToAbsent || limitations != null) {
      map['limitations'] = Variable<String>(limitations);
    }
    if (!nullToAbsent || securityNotes != null) {
      map['security_notes'] = Variable<String>(securityNotes);
    }
    map['research_status'] = Variable<String>(researchStatus);
    map['is_verified'] = Variable<bool>(isVerified);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['no_app_needed'] = Variable<bool>(noAppNeeded);
    map['content_potential'] = Variable<int>(contentPotential);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TreasuresCompanion toCompanion(bool nullToAbsent) {
    return TreasuresCompanion(
      id: Value(id),
      title: Value(title),
      shortDescription: Value(shortDescription),
      problem: problem == null && nullToAbsent
          ? const Value.absent()
          : Value(problem),
      solution: solution == null && nullToAbsent
          ? const Value.absent()
          : Value(solution),
      whyUseful: whyUseful == null && nullToAbsent
          ? const Value.absent()
          : Value(whyUseful),
      categoryId: Value(categoryId),
      status: Value(status),
      device:
          device == null && nullToAbsent ? const Value.absent() : Value(device),
      platform: platform == null && nullToAbsent
          ? const Value.absent()
          : Value(platform),
      osVersion: osVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(osVersion),
      requirements: requirements == null && nullToAbsent
          ? const Value.absent()
          : Value(requirements),
      stepsJson: stepsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(stepsJson),
      limitations: limitations == null && nullToAbsent
          ? const Value.absent()
          : Value(limitations),
      securityNotes: securityNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(securityNotes),
      researchStatus: Value(researchStatus),
      isVerified: Value(isVerified),
      isFavorite: Value(isFavorite),
      noAppNeeded: Value(noAppNeeded),
      contentPotential: Value(contentPotential),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Treasure.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Treasure(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      shortDescription: serializer.fromJson<String>(json['shortDescription']),
      problem: serializer.fromJson<String?>(json['problem']),
      solution: serializer.fromJson<String?>(json['solution']),
      whyUseful: serializer.fromJson<String?>(json['whyUseful']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      status: serializer.fromJson<String>(json['status']),
      device: serializer.fromJson<String?>(json['device']),
      platform: serializer.fromJson<String?>(json['platform']),
      osVersion: serializer.fromJson<String?>(json['osVersion']),
      requirements: serializer.fromJson<String?>(json['requirements']),
      stepsJson: serializer.fromJson<String?>(json['stepsJson']),
      limitations: serializer.fromJson<String?>(json['limitations']),
      securityNotes: serializer.fromJson<String?>(json['securityNotes']),
      researchStatus: serializer.fromJson<String>(json['researchStatus']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      noAppNeeded: serializer.fromJson<bool>(json['noAppNeeded']),
      contentPotential: serializer.fromJson<int>(json['contentPotential']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'shortDescription': serializer.toJson<String>(shortDescription),
      'problem': serializer.toJson<String?>(problem),
      'solution': serializer.toJson<String?>(solution),
      'whyUseful': serializer.toJson<String?>(whyUseful),
      'categoryId': serializer.toJson<String>(categoryId),
      'status': serializer.toJson<String>(status),
      'device': serializer.toJson<String?>(device),
      'platform': serializer.toJson<String?>(platform),
      'osVersion': serializer.toJson<String?>(osVersion),
      'requirements': serializer.toJson<String?>(requirements),
      'stepsJson': serializer.toJson<String?>(stepsJson),
      'limitations': serializer.toJson<String?>(limitations),
      'securityNotes': serializer.toJson<String?>(securityNotes),
      'researchStatus': serializer.toJson<String>(researchStatus),
      'isVerified': serializer.toJson<bool>(isVerified),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'noAppNeeded': serializer.toJson<bool>(noAppNeeded),
      'contentPotential': serializer.toJson<int>(contentPotential),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Treasure copyWith(
          {String? id,
          String? title,
          String? shortDescription,
          Value<String?> problem = const Value.absent(),
          Value<String?> solution = const Value.absent(),
          Value<String?> whyUseful = const Value.absent(),
          String? categoryId,
          String? status,
          Value<String?> device = const Value.absent(),
          Value<String?> platform = const Value.absent(),
          Value<String?> osVersion = const Value.absent(),
          Value<String?> requirements = const Value.absent(),
          Value<String?> stepsJson = const Value.absent(),
          Value<String?> limitations = const Value.absent(),
          Value<String?> securityNotes = const Value.absent(),
          String? researchStatus,
          bool? isVerified,
          bool? isFavorite,
          bool? noAppNeeded,
          int? contentPotential,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Treasure(
        id: id ?? this.id,
        title: title ?? this.title,
        shortDescription: shortDescription ?? this.shortDescription,
        problem: problem.present ? problem.value : this.problem,
        solution: solution.present ? solution.value : this.solution,
        whyUseful: whyUseful.present ? whyUseful.value : this.whyUseful,
        categoryId: categoryId ?? this.categoryId,
        status: status ?? this.status,
        device: device.present ? device.value : this.device,
        platform: platform.present ? platform.value : this.platform,
        osVersion: osVersion.present ? osVersion.value : this.osVersion,
        requirements:
            requirements.present ? requirements.value : this.requirements,
        stepsJson: stepsJson.present ? stepsJson.value : this.stepsJson,
        limitations: limitations.present ? limitations.value : this.limitations,
        securityNotes:
            securityNotes.present ? securityNotes.value : this.securityNotes,
        researchStatus: researchStatus ?? this.researchStatus,
        isVerified: isVerified ?? this.isVerified,
        isFavorite: isFavorite ?? this.isFavorite,
        noAppNeeded: noAppNeeded ?? this.noAppNeeded,
        contentPotential: contentPotential ?? this.contentPotential,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Treasure copyWithCompanion(TreasuresCompanion data) {
    return Treasure(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      shortDescription: data.shortDescription.present
          ? data.shortDescription.value
          : this.shortDescription,
      problem: data.problem.present ? data.problem.value : this.problem,
      solution: data.solution.present ? data.solution.value : this.solution,
      whyUseful: data.whyUseful.present ? data.whyUseful.value : this.whyUseful,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      status: data.status.present ? data.status.value : this.status,
      device: data.device.present ? data.device.value : this.device,
      platform: data.platform.present ? data.platform.value : this.platform,
      osVersion: data.osVersion.present ? data.osVersion.value : this.osVersion,
      requirements: data.requirements.present
          ? data.requirements.value
          : this.requirements,
      stepsJson: data.stepsJson.present ? data.stepsJson.value : this.stepsJson,
      limitations:
          data.limitations.present ? data.limitations.value : this.limitations,
      securityNotes: data.securityNotes.present
          ? data.securityNotes.value
          : this.securityNotes,
      researchStatus: data.researchStatus.present
          ? data.researchStatus.value
          : this.researchStatus,
      isVerified:
          data.isVerified.present ? data.isVerified.value : this.isVerified,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      noAppNeeded:
          data.noAppNeeded.present ? data.noAppNeeded.value : this.noAppNeeded,
      contentPotential: data.contentPotential.present
          ? data.contentPotential.value
          : this.contentPotential,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Treasure(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('shortDescription: $shortDescription, ')
          ..write('problem: $problem, ')
          ..write('solution: $solution, ')
          ..write('whyUseful: $whyUseful, ')
          ..write('categoryId: $categoryId, ')
          ..write('status: $status, ')
          ..write('device: $device, ')
          ..write('platform: $platform, ')
          ..write('osVersion: $osVersion, ')
          ..write('requirements: $requirements, ')
          ..write('stepsJson: $stepsJson, ')
          ..write('limitations: $limitations, ')
          ..write('securityNotes: $securityNotes, ')
          ..write('researchStatus: $researchStatus, ')
          ..write('isVerified: $isVerified, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('noAppNeeded: $noAppNeeded, ')
          ..write('contentPotential: $contentPotential, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        shortDescription,
        problem,
        solution,
        whyUseful,
        categoryId,
        status,
        device,
        platform,
        osVersion,
        requirements,
        stepsJson,
        limitations,
        securityNotes,
        researchStatus,
        isVerified,
        isFavorite,
        noAppNeeded,
        contentPotential,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Treasure &&
          other.id == this.id &&
          other.title == this.title &&
          other.shortDescription == this.shortDescription &&
          other.problem == this.problem &&
          other.solution == this.solution &&
          other.whyUseful == this.whyUseful &&
          other.categoryId == this.categoryId &&
          other.status == this.status &&
          other.device == this.device &&
          other.platform == this.platform &&
          other.osVersion == this.osVersion &&
          other.requirements == this.requirements &&
          other.stepsJson == this.stepsJson &&
          other.limitations == this.limitations &&
          other.securityNotes == this.securityNotes &&
          other.researchStatus == this.researchStatus &&
          other.isVerified == this.isVerified &&
          other.isFavorite == this.isFavorite &&
          other.noAppNeeded == this.noAppNeeded &&
          other.contentPotential == this.contentPotential &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TreasuresCompanion extends UpdateCompanion<Treasure> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> shortDescription;
  final Value<String?> problem;
  final Value<String?> solution;
  final Value<String?> whyUseful;
  final Value<String> categoryId;
  final Value<String> status;
  final Value<String?> device;
  final Value<String?> platform;
  final Value<String?> osVersion;
  final Value<String?> requirements;
  final Value<String?> stepsJson;
  final Value<String?> limitations;
  final Value<String?> securityNotes;
  final Value<String> researchStatus;
  final Value<bool> isVerified;
  final Value<bool> isFavorite;
  final Value<bool> noAppNeeded;
  final Value<int> contentPotential;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TreasuresCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.shortDescription = const Value.absent(),
    this.problem = const Value.absent(),
    this.solution = const Value.absent(),
    this.whyUseful = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.status = const Value.absent(),
    this.device = const Value.absent(),
    this.platform = const Value.absent(),
    this.osVersion = const Value.absent(),
    this.requirements = const Value.absent(),
    this.stepsJson = const Value.absent(),
    this.limitations = const Value.absent(),
    this.securityNotes = const Value.absent(),
    this.researchStatus = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.noAppNeeded = const Value.absent(),
    this.contentPotential = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TreasuresCompanion.insert({
    required String id,
    required String title,
    required String shortDescription,
    this.problem = const Value.absent(),
    this.solution = const Value.absent(),
    this.whyUseful = const Value.absent(),
    required String categoryId,
    this.status = const Value.absent(),
    this.device = const Value.absent(),
    this.platform = const Value.absent(),
    this.osVersion = const Value.absent(),
    this.requirements = const Value.absent(),
    this.stepsJson = const Value.absent(),
    this.limitations = const Value.absent(),
    this.securityNotes = const Value.absent(),
    this.researchStatus = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.noAppNeeded = const Value.absent(),
    this.contentPotential = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        shortDescription = Value(shortDescription),
        categoryId = Value(categoryId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Treasure> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? shortDescription,
    Expression<String>? problem,
    Expression<String>? solution,
    Expression<String>? whyUseful,
    Expression<String>? categoryId,
    Expression<String>? status,
    Expression<String>? device,
    Expression<String>? platform,
    Expression<String>? osVersion,
    Expression<String>? requirements,
    Expression<String>? stepsJson,
    Expression<String>? limitations,
    Expression<String>? securityNotes,
    Expression<String>? researchStatus,
    Expression<bool>? isVerified,
    Expression<bool>? isFavorite,
    Expression<bool>? noAppNeeded,
    Expression<int>? contentPotential,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (shortDescription != null) 'short_description': shortDescription,
      if (problem != null) 'problem': problem,
      if (solution != null) 'solution': solution,
      if (whyUseful != null) 'why_useful': whyUseful,
      if (categoryId != null) 'category_id': categoryId,
      if (status != null) 'status': status,
      if (device != null) 'device': device,
      if (platform != null) 'platform': platform,
      if (osVersion != null) 'os_version': osVersion,
      if (requirements != null) 'requirements': requirements,
      if (stepsJson != null) 'steps_json': stepsJson,
      if (limitations != null) 'limitations': limitations,
      if (securityNotes != null) 'security_notes': securityNotes,
      if (researchStatus != null) 'research_status': researchStatus,
      if (isVerified != null) 'is_verified': isVerified,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (noAppNeeded != null) 'no_app_needed': noAppNeeded,
      if (contentPotential != null) 'content_potential': contentPotential,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TreasuresCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? shortDescription,
      Value<String?>? problem,
      Value<String?>? solution,
      Value<String?>? whyUseful,
      Value<String>? categoryId,
      Value<String>? status,
      Value<String?>? device,
      Value<String?>? platform,
      Value<String?>? osVersion,
      Value<String?>? requirements,
      Value<String?>? stepsJson,
      Value<String?>? limitations,
      Value<String?>? securityNotes,
      Value<String>? researchStatus,
      Value<bool>? isVerified,
      Value<bool>? isFavorite,
      Value<bool>? noAppNeeded,
      Value<int>? contentPotential,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TreasuresCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      problem: problem ?? this.problem,
      solution: solution ?? this.solution,
      whyUseful: whyUseful ?? this.whyUseful,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      device: device ?? this.device,
      platform: platform ?? this.platform,
      osVersion: osVersion ?? this.osVersion,
      requirements: requirements ?? this.requirements,
      stepsJson: stepsJson ?? this.stepsJson,
      limitations: limitations ?? this.limitations,
      securityNotes: securityNotes ?? this.securityNotes,
      researchStatus: researchStatus ?? this.researchStatus,
      isVerified: isVerified ?? this.isVerified,
      isFavorite: isFavorite ?? this.isFavorite,
      noAppNeeded: noAppNeeded ?? this.noAppNeeded,
      contentPotential: contentPotential ?? this.contentPotential,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (shortDescription.present) {
      map['short_description'] = Variable<String>(shortDescription.value);
    }
    if (problem.present) {
      map['problem'] = Variable<String>(problem.value);
    }
    if (solution.present) {
      map['solution'] = Variable<String>(solution.value);
    }
    if (whyUseful.present) {
      map['why_useful'] = Variable<String>(whyUseful.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (device.present) {
      map['device'] = Variable<String>(device.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (osVersion.present) {
      map['os_version'] = Variable<String>(osVersion.value);
    }
    if (requirements.present) {
      map['requirements'] = Variable<String>(requirements.value);
    }
    if (stepsJson.present) {
      map['steps_json'] = Variable<String>(stepsJson.value);
    }
    if (limitations.present) {
      map['limitations'] = Variable<String>(limitations.value);
    }
    if (securityNotes.present) {
      map['security_notes'] = Variable<String>(securityNotes.value);
    }
    if (researchStatus.present) {
      map['research_status'] = Variable<String>(researchStatus.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (noAppNeeded.present) {
      map['no_app_needed'] = Variable<bool>(noAppNeeded.value);
    }
    if (contentPotential.present) {
      map['content_potential'] = Variable<int>(contentPotential.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreasuresCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('shortDescription: $shortDescription, ')
          ..write('problem: $problem, ')
          ..write('solution: $solution, ')
          ..write('whyUseful: $whyUseful, ')
          ..write('categoryId: $categoryId, ')
          ..write('status: $status, ')
          ..write('device: $device, ')
          ..write('platform: $platform, ')
          ..write('osVersion: $osVersion, ')
          ..write('requirements: $requirements, ')
          ..write('stepsJson: $stepsJson, ')
          ..write('limitations: $limitations, ')
          ..write('securityNotes: $securityNotes, ')
          ..write('researchStatus: $researchStatus, ')
          ..write('isVerified: $isVerified, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('noAppNeeded: $noAppNeeded, ')
          ..write('contentPotential: $contentPotential, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TreasureTagsTable extends TreasureTags
    with TableInfo<$TreasureTagsTable, TreasureTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreasureTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _treasureIdMeta =
      const VerificationMeta('treasureId');
  @override
  late final GeneratedColumn<String> treasureId = GeneratedColumn<String>(
      'treasure_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES treasures (id) ON DELETE CASCADE'));
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES tags (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [treasureId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'treasure_tags';
  @override
  VerificationContext validateIntegrity(Insertable<TreasureTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('treasure_id')) {
      context.handle(
          _treasureIdMeta,
          treasureId.isAcceptableOrUnknown(
              data['treasure_id']!, _treasureIdMeta));
    } else if (isInserting) {
      context.missing(_treasureIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {treasureId, tagId};
  @override
  TreasureTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreasureTag(
      treasureId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}treasure_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  $TreasureTagsTable createAlias(String alias) {
    return $TreasureTagsTable(attachedDatabase, alias);
  }
}

class TreasureTag extends DataClass implements Insertable<TreasureTag> {
  final String treasureId;
  final String tagId;
  const TreasureTag({required this.treasureId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['treasure_id'] = Variable<String>(treasureId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  TreasureTagsCompanion toCompanion(bool nullToAbsent) {
    return TreasureTagsCompanion(
      treasureId: Value(treasureId),
      tagId: Value(tagId),
    );
  }

  factory TreasureTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreasureTag(
      treasureId: serializer.fromJson<String>(json['treasureId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'treasureId': serializer.toJson<String>(treasureId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  TreasureTag copyWith({String? treasureId, String? tagId}) => TreasureTag(
        treasureId: treasureId ?? this.treasureId,
        tagId: tagId ?? this.tagId,
      );
  TreasureTag copyWithCompanion(TreasureTagsCompanion data) {
    return TreasureTag(
      treasureId:
          data.treasureId.present ? data.treasureId.value : this.treasureId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TreasureTag(')
          ..write('treasureId: $treasureId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(treasureId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreasureTag &&
          other.treasureId == this.treasureId &&
          other.tagId == this.tagId);
}

class TreasureTagsCompanion extends UpdateCompanion<TreasureTag> {
  final Value<String> treasureId;
  final Value<String> tagId;
  final Value<int> rowid;
  const TreasureTagsCompanion({
    this.treasureId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TreasureTagsCompanion.insert({
    required String treasureId,
    required String tagId,
    this.rowid = const Value.absent(),
  })  : treasureId = Value(treasureId),
        tagId = Value(tagId);
  static Insertable<TreasureTag> custom({
    Expression<String>? treasureId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (treasureId != null) 'treasure_id': treasureId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TreasureTagsCompanion copyWith(
      {Value<String>? treasureId, Value<String>? tagId, Value<int>? rowid}) {
    return TreasureTagsCompanion(
      treasureId: treasureId ?? this.treasureId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (treasureId.present) {
      map['treasure_id'] = Variable<String>(treasureId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TreasureTagsCompanion(')
          ..write('treasureId: $treasureId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SourcesTable extends Sources with TableInfo<$SourcesTable, Source> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _treasureIdMeta =
      const VerificationMeta('treasureId');
  @override
  late final GeneratedColumn<String> treasureId = GeneratedColumn<String>(
      'treasure_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES treasures (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, treasureId, title, url, sourceType, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sources';
  @override
  VerificationContext validateIntegrity(Insertable<Source> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('treasure_id')) {
      context.handle(
          _treasureIdMeta,
          treasureId.isAcceptableOrUnknown(
              data['treasure_id']!, _treasureIdMeta));
    } else if (isInserting) {
      context.missing(_treasureIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('source_type')) {
      context.handle(
          _sourceTypeMeta,
          sourceType.isAcceptableOrUnknown(
              data['source_type']!, _sourceTypeMeta));
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Source map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Source(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      treasureId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}treasure_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url']),
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SourcesTable createAlias(String alias) {
    return $SourcesTable(attachedDatabase, alias);
  }
}

class Source extends DataClass implements Insertable<Source> {
  final String id;
  final String treasureId;
  final String title;
  final String? url;
  final String sourceType;
  final String? notes;
  final DateTime createdAt;
  const Source(
      {required this.id,
      required this.treasureId,
      required this.title,
      this.url,
      required this.sourceType,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['treasure_id'] = Variable<String>(treasureId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SourcesCompanion toCompanion(bool nullToAbsent) {
    return SourcesCompanion(
      id: Value(id),
      treasureId: Value(treasureId),
      title: Value(title),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      sourceType: Value(sourceType),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Source.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Source(
      id: serializer.fromJson<String>(json['id']),
      treasureId: serializer.fromJson<String>(json['treasureId']),
      title: serializer.fromJson<String>(json['title']),
      url: serializer.fromJson<String?>(json['url']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'treasureId': serializer.toJson<String>(treasureId),
      'title': serializer.toJson<String>(title),
      'url': serializer.toJson<String?>(url),
      'sourceType': serializer.toJson<String>(sourceType),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Source copyWith(
          {String? id,
          String? treasureId,
          String? title,
          Value<String?> url = const Value.absent(),
          String? sourceType,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      Source(
        id: id ?? this.id,
        treasureId: treasureId ?? this.treasureId,
        title: title ?? this.title,
        url: url.present ? url.value : this.url,
        sourceType: sourceType ?? this.sourceType,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  Source copyWithCompanion(SourcesCompanion data) {
    return Source(
      id: data.id.present ? data.id.value : this.id,
      treasureId:
          data.treasureId.present ? data.treasureId.value : this.treasureId,
      title: data.title.present ? data.title.value : this.title,
      url: data.url.present ? data.url.value : this.url,
      sourceType:
          data.sourceType.present ? data.sourceType.value : this.sourceType,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Source(')
          ..write('id: $id, ')
          ..write('treasureId: $treasureId, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('sourceType: $sourceType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, treasureId, title, url, sourceType, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Source &&
          other.id == this.id &&
          other.treasureId == this.treasureId &&
          other.title == this.title &&
          other.url == this.url &&
          other.sourceType == this.sourceType &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class SourcesCompanion extends UpdateCompanion<Source> {
  final Value<String> id;
  final Value<String> treasureId;
  final Value<String> title;
  final Value<String?> url;
  final Value<String> sourceType;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SourcesCompanion({
    this.id = const Value.absent(),
    this.treasureId = const Value.absent(),
    this.title = const Value.absent(),
    this.url = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SourcesCompanion.insert({
    required String id,
    required String treasureId,
    required String title,
    this.url = const Value.absent(),
    required String sourceType,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        treasureId = Value(treasureId),
        title = Value(title),
        sourceType = Value(sourceType),
        createdAt = Value(createdAt);
  static Insertable<Source> custom({
    Expression<String>? id,
    Expression<String>? treasureId,
    Expression<String>? title,
    Expression<String>? url,
    Expression<String>? sourceType,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (treasureId != null) 'treasure_id': treasureId,
      if (title != null) 'title': title,
      if (url != null) 'url': url,
      if (sourceType != null) 'source_type': sourceType,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SourcesCompanion copyWith(
      {Value<String>? id,
      Value<String>? treasureId,
      Value<String>? title,
      Value<String?>? url,
      Value<String>? sourceType,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SourcesCompanion(
      id: id ?? this.id,
      treasureId: treasureId ?? this.treasureId,
      title: title ?? this.title,
      url: url ?? this.url,
      sourceType: sourceType ?? this.sourceType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (treasureId.present) {
      map['treasure_id'] = Variable<String>(treasureId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcesCompanion(')
          ..write('id: $id, ')
          ..write('treasureId: $treasureId, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('sourceType: $sourceType, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TestRecordsTable extends TestRecords
    with TableInfo<$TestRecordsTable, TestRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _treasureIdMeta =
      const VerificationMeta('treasureId');
  @override
  late final GeneratedColumn<String> treasureId = GeneratedColumn<String>(
      'treasure_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES treasures (id) ON DELETE CASCADE'));
  static const VerificationMeta _deviceMeta = const VerificationMeta('device');
  @override
  late final GeneratedColumn<String> device = GeneratedColumn<String>(
      'device', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _osVersionMeta =
      const VerificationMeta('osVersion');
  @override
  late final GeneratedColumn<String> osVersion = GeneratedColumn<String>(
      'os_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _environmentMeta =
      const VerificationMeta('environment');
  @override
  late final GeneratedColumn<String> environment = GeneratedColumn<String>(
      'environment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
      'result', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _testedAtMeta =
      const VerificationMeta('testedAt');
  @override
  late final GeneratedColumn<DateTime> testedAt = GeneratedColumn<DateTime>(
      'tested_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, treasureId, device, osVersion, environment, result, notes, testedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_records';
  @override
  VerificationContext validateIntegrity(Insertable<TestRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('treasure_id')) {
      context.handle(
          _treasureIdMeta,
          treasureId.isAcceptableOrUnknown(
              data['treasure_id']!, _treasureIdMeta));
    } else if (isInserting) {
      context.missing(_treasureIdMeta);
    }
    if (data.containsKey('device')) {
      context.handle(_deviceMeta,
          device.isAcceptableOrUnknown(data['device']!, _deviceMeta));
    } else if (isInserting) {
      context.missing(_deviceMeta);
    }
    if (data.containsKey('os_version')) {
      context.handle(_osVersionMeta,
          osVersion.isAcceptableOrUnknown(data['os_version']!, _osVersionMeta));
    } else if (isInserting) {
      context.missing(_osVersionMeta);
    }
    if (data.containsKey('environment')) {
      context.handle(
          _environmentMeta,
          environment.isAcceptableOrUnknown(
              data['environment']!, _environmentMeta));
    }
    if (data.containsKey('result')) {
      context.handle(_resultMeta,
          result.isAcceptableOrUnknown(data['result']!, _resultMeta));
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('tested_at')) {
      context.handle(_testedAtMeta,
          testedAt.isAcceptableOrUnknown(data['tested_at']!, _testedAtMeta));
    } else if (isInserting) {
      context.missing(_testedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      treasureId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}treasure_id'])!,
      device: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device'])!,
      osVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}os_version'])!,
      environment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}environment']),
      result: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}result'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      testedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}tested_at'])!,
    );
  }

  @override
  $TestRecordsTable createAlias(String alias) {
    return $TestRecordsTable(attachedDatabase, alias);
  }
}

class TestRecord extends DataClass implements Insertable<TestRecord> {
  final String id;
  final String treasureId;
  final String device;
  final String osVersion;
  final String? environment;
  final String result;
  final String? notes;
  final DateTime testedAt;
  const TestRecord(
      {required this.id,
      required this.treasureId,
      required this.device,
      required this.osVersion,
      this.environment,
      required this.result,
      this.notes,
      required this.testedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['treasure_id'] = Variable<String>(treasureId);
    map['device'] = Variable<String>(device);
    map['os_version'] = Variable<String>(osVersion);
    if (!nullToAbsent || environment != null) {
      map['environment'] = Variable<String>(environment);
    }
    map['result'] = Variable<String>(result);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['tested_at'] = Variable<DateTime>(testedAt);
    return map;
  }

  TestRecordsCompanion toCompanion(bool nullToAbsent) {
    return TestRecordsCompanion(
      id: Value(id),
      treasureId: Value(treasureId),
      device: Value(device),
      osVersion: Value(osVersion),
      environment: environment == null && nullToAbsent
          ? const Value.absent()
          : Value(environment),
      result: Value(result),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      testedAt: Value(testedAt),
    );
  }

  factory TestRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestRecord(
      id: serializer.fromJson<String>(json['id']),
      treasureId: serializer.fromJson<String>(json['treasureId']),
      device: serializer.fromJson<String>(json['device']),
      osVersion: serializer.fromJson<String>(json['osVersion']),
      environment: serializer.fromJson<String?>(json['environment']),
      result: serializer.fromJson<String>(json['result']),
      notes: serializer.fromJson<String?>(json['notes']),
      testedAt: serializer.fromJson<DateTime>(json['testedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'treasureId': serializer.toJson<String>(treasureId),
      'device': serializer.toJson<String>(device),
      'osVersion': serializer.toJson<String>(osVersion),
      'environment': serializer.toJson<String?>(environment),
      'result': serializer.toJson<String>(result),
      'notes': serializer.toJson<String?>(notes),
      'testedAt': serializer.toJson<DateTime>(testedAt),
    };
  }

  TestRecord copyWith(
          {String? id,
          String? treasureId,
          String? device,
          String? osVersion,
          Value<String?> environment = const Value.absent(),
          String? result,
          Value<String?> notes = const Value.absent(),
          DateTime? testedAt}) =>
      TestRecord(
        id: id ?? this.id,
        treasureId: treasureId ?? this.treasureId,
        device: device ?? this.device,
        osVersion: osVersion ?? this.osVersion,
        environment: environment.present ? environment.value : this.environment,
        result: result ?? this.result,
        notes: notes.present ? notes.value : this.notes,
        testedAt: testedAt ?? this.testedAt,
      );
  TestRecord copyWithCompanion(TestRecordsCompanion data) {
    return TestRecord(
      id: data.id.present ? data.id.value : this.id,
      treasureId:
          data.treasureId.present ? data.treasureId.value : this.treasureId,
      device: data.device.present ? data.device.value : this.device,
      osVersion: data.osVersion.present ? data.osVersion.value : this.osVersion,
      environment:
          data.environment.present ? data.environment.value : this.environment,
      result: data.result.present ? data.result.value : this.result,
      notes: data.notes.present ? data.notes.value : this.notes,
      testedAt: data.testedAt.present ? data.testedAt.value : this.testedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestRecord(')
          ..write('id: $id, ')
          ..write('treasureId: $treasureId, ')
          ..write('device: $device, ')
          ..write('osVersion: $osVersion, ')
          ..write('environment: $environment, ')
          ..write('result: $result, ')
          ..write('notes: $notes, ')
          ..write('testedAt: $testedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, treasureId, device, osVersion, environment, result, notes, testedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestRecord &&
          other.id == this.id &&
          other.treasureId == this.treasureId &&
          other.device == this.device &&
          other.osVersion == this.osVersion &&
          other.environment == this.environment &&
          other.result == this.result &&
          other.notes == this.notes &&
          other.testedAt == this.testedAt);
}

class TestRecordsCompanion extends UpdateCompanion<TestRecord> {
  final Value<String> id;
  final Value<String> treasureId;
  final Value<String> device;
  final Value<String> osVersion;
  final Value<String?> environment;
  final Value<String> result;
  final Value<String?> notes;
  final Value<DateTime> testedAt;
  final Value<int> rowid;
  const TestRecordsCompanion({
    this.id = const Value.absent(),
    this.treasureId = const Value.absent(),
    this.device = const Value.absent(),
    this.osVersion = const Value.absent(),
    this.environment = const Value.absent(),
    this.result = const Value.absent(),
    this.notes = const Value.absent(),
    this.testedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TestRecordsCompanion.insert({
    required String id,
    required String treasureId,
    required String device,
    required String osVersion,
    this.environment = const Value.absent(),
    required String result,
    this.notes = const Value.absent(),
    required DateTime testedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        treasureId = Value(treasureId),
        device = Value(device),
        osVersion = Value(osVersion),
        result = Value(result),
        testedAt = Value(testedAt);
  static Insertable<TestRecord> custom({
    Expression<String>? id,
    Expression<String>? treasureId,
    Expression<String>? device,
    Expression<String>? osVersion,
    Expression<String>? environment,
    Expression<String>? result,
    Expression<String>? notes,
    Expression<DateTime>? testedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (treasureId != null) 'treasure_id': treasureId,
      if (device != null) 'device': device,
      if (osVersion != null) 'os_version': osVersion,
      if (environment != null) 'environment': environment,
      if (result != null) 'result': result,
      if (notes != null) 'notes': notes,
      if (testedAt != null) 'tested_at': testedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TestRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String>? treasureId,
      Value<String>? device,
      Value<String>? osVersion,
      Value<String?>? environment,
      Value<String>? result,
      Value<String?>? notes,
      Value<DateTime>? testedAt,
      Value<int>? rowid}) {
    return TestRecordsCompanion(
      id: id ?? this.id,
      treasureId: treasureId ?? this.treasureId,
      device: device ?? this.device,
      osVersion: osVersion ?? this.osVersion,
      environment: environment ?? this.environment,
      result: result ?? this.result,
      notes: notes ?? this.notes,
      testedAt: testedAt ?? this.testedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (treasureId.present) {
      map['treasure_id'] = Variable<String>(treasureId.value);
    }
    if (device.present) {
      map['device'] = Variable<String>(device.value);
    }
    if (osVersion.present) {
      map['os_version'] = Variable<String>(osVersion.value);
    }
    if (environment.present) {
      map['environment'] = Variable<String>(environment.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (testedAt.present) {
      map['tested_at'] = Variable<DateTime>(testedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestRecordsCompanion(')
          ..write('id: $id, ')
          ..write('treasureId: $treasureId, ')
          ..write('device: $device, ')
          ..write('osVersion: $osVersion, ')
          ..write('environment: $environment, ')
          ..write('result: $result, ')
          ..write('notes: $notes, ')
          ..write('testedAt: $testedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentsTable extends Contents with TableInfo<$ContentsTable, Content> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _treasureIdMeta =
      const VerificationMeta('treasureId');
  @override
  late final GeneratedColumn<String> treasureId = GeneratedColumn<String>(
      'treasure_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES treasures (id) ON DELETE CASCADE'));
  static const VerificationMeta _contentTypeMeta =
      const VerificationMeta('contentType');
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
      'content_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hookMeta = const VerificationMeta('hook');
  @override
  late final GeneratedColumn<String> hook = GeneratedColumn<String>(
      'hook', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _problemMeta =
      const VerificationMeta('problem');
  @override
  late final GeneratedColumn<String> problem = GeneratedColumn<String>(
      'problem', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _demonstrationMeta =
      const VerificationMeta('demonstration');
  @override
  late final GeneratedColumn<String> demonstration = GeneratedColumn<String>(
      'demonstration', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scriptMeta = const VerificationMeta('script');
  @override
  late final GeneratedColumn<String> script = GeneratedColumn<String>(
      'script', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ctaMeta = const VerificationMeta('cta');
  @override
  late final GeneratedColumn<String> cta = GeneratedColumn<String>(
      'cta', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('idea'));
  static const VerificationMeta _platformUrlMeta =
      const VerificationMeta('platformUrl');
  @override
  late final GeneratedColumn<String> platformUrl = GeneratedColumn<String>(
      'platform_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedAtMeta =
      const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
      'published_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        treasureId,
        contentType,
        hook,
        problem,
        demonstration,
        script,
        cta,
        status,
        platformUrl,
        publishedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contents';
  @override
  VerificationContext validateIntegrity(Insertable<Content> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('treasure_id')) {
      context.handle(
          _treasureIdMeta,
          treasureId.isAcceptableOrUnknown(
              data['treasure_id']!, _treasureIdMeta));
    } else if (isInserting) {
      context.missing(_treasureIdMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
          _contentTypeMeta,
          contentType.isAcceptableOrUnknown(
              data['content_type']!, _contentTypeMeta));
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('hook')) {
      context.handle(
          _hookMeta, hook.isAcceptableOrUnknown(data['hook']!, _hookMeta));
    }
    if (data.containsKey('problem')) {
      context.handle(_problemMeta,
          problem.isAcceptableOrUnknown(data['problem']!, _problemMeta));
    }
    if (data.containsKey('demonstration')) {
      context.handle(
          _demonstrationMeta,
          demonstration.isAcceptableOrUnknown(
              data['demonstration']!, _demonstrationMeta));
    }
    if (data.containsKey('script')) {
      context.handle(_scriptMeta,
          script.isAcceptableOrUnknown(data['script']!, _scriptMeta));
    }
    if (data.containsKey('cta')) {
      context.handle(
          _ctaMeta, cta.isAcceptableOrUnknown(data['cta']!, _ctaMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('platform_url')) {
      context.handle(
          _platformUrlMeta,
          platformUrl.isAcceptableOrUnknown(
              data['platform_url']!, _platformUrlMeta));
    }
    if (data.containsKey('published_at')) {
      context.handle(
          _publishedAtMeta,
          publishedAt.isAcceptableOrUnknown(
              data['published_at']!, _publishedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Content map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Content(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      treasureId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}treasure_id'])!,
      contentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_type'])!,
      hook: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hook']),
      problem: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}problem']),
      demonstration: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}demonstration']),
      script: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}script']),
      cta: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cta']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      platformUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}platform_url']),
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ContentsTable createAlias(String alias) {
    return $ContentsTable(attachedDatabase, alias);
  }
}

class Content extends DataClass implements Insertable<Content> {
  final String id;
  final String treasureId;
  final String contentType;
  final String? hook;
  final String? problem;
  final String? demonstration;
  final String? script;
  final String? cta;
  final String status;
  final String? platformUrl;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Content(
      {required this.id,
      required this.treasureId,
      required this.contentType,
      this.hook,
      this.problem,
      this.demonstration,
      this.script,
      this.cta,
      required this.status,
      this.platformUrl,
      this.publishedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['treasure_id'] = Variable<String>(treasureId);
    map['content_type'] = Variable<String>(contentType);
    if (!nullToAbsent || hook != null) {
      map['hook'] = Variable<String>(hook);
    }
    if (!nullToAbsent || problem != null) {
      map['problem'] = Variable<String>(problem);
    }
    if (!nullToAbsent || demonstration != null) {
      map['demonstration'] = Variable<String>(demonstration);
    }
    if (!nullToAbsent || script != null) {
      map['script'] = Variable<String>(script);
    }
    if (!nullToAbsent || cta != null) {
      map['cta'] = Variable<String>(cta);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || platformUrl != null) {
      map['platform_url'] = Variable<String>(platformUrl);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ContentsCompanion toCompanion(bool nullToAbsent) {
    return ContentsCompanion(
      id: Value(id),
      treasureId: Value(treasureId),
      contentType: Value(contentType),
      hook: hook == null && nullToAbsent ? const Value.absent() : Value(hook),
      problem: problem == null && nullToAbsent
          ? const Value.absent()
          : Value(problem),
      demonstration: demonstration == null && nullToAbsent
          ? const Value.absent()
          : Value(demonstration),
      script:
          script == null && nullToAbsent ? const Value.absent() : Value(script),
      cta: cta == null && nullToAbsent ? const Value.absent() : Value(cta),
      status: Value(status),
      platformUrl: platformUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(platformUrl),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Content.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Content(
      id: serializer.fromJson<String>(json['id']),
      treasureId: serializer.fromJson<String>(json['treasureId']),
      contentType: serializer.fromJson<String>(json['contentType']),
      hook: serializer.fromJson<String?>(json['hook']),
      problem: serializer.fromJson<String?>(json['problem']),
      demonstration: serializer.fromJson<String?>(json['demonstration']),
      script: serializer.fromJson<String?>(json['script']),
      cta: serializer.fromJson<String?>(json['cta']),
      status: serializer.fromJson<String>(json['status']),
      platformUrl: serializer.fromJson<String?>(json['platformUrl']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'treasureId': serializer.toJson<String>(treasureId),
      'contentType': serializer.toJson<String>(contentType),
      'hook': serializer.toJson<String?>(hook),
      'problem': serializer.toJson<String?>(problem),
      'demonstration': serializer.toJson<String?>(demonstration),
      'script': serializer.toJson<String?>(script),
      'cta': serializer.toJson<String?>(cta),
      'status': serializer.toJson<String>(status),
      'platformUrl': serializer.toJson<String?>(platformUrl),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Content copyWith(
          {String? id,
          String? treasureId,
          String? contentType,
          Value<String?> hook = const Value.absent(),
          Value<String?> problem = const Value.absent(),
          Value<String?> demonstration = const Value.absent(),
          Value<String?> script = const Value.absent(),
          Value<String?> cta = const Value.absent(),
          String? status,
          Value<String?> platformUrl = const Value.absent(),
          Value<DateTime?> publishedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Content(
        id: id ?? this.id,
        treasureId: treasureId ?? this.treasureId,
        contentType: contentType ?? this.contentType,
        hook: hook.present ? hook.value : this.hook,
        problem: problem.present ? problem.value : this.problem,
        demonstration:
            demonstration.present ? demonstration.value : this.demonstration,
        script: script.present ? script.value : this.script,
        cta: cta.present ? cta.value : this.cta,
        status: status ?? this.status,
        platformUrl: platformUrl.present ? platformUrl.value : this.platformUrl,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Content copyWithCompanion(ContentsCompanion data) {
    return Content(
      id: data.id.present ? data.id.value : this.id,
      treasureId:
          data.treasureId.present ? data.treasureId.value : this.treasureId,
      contentType:
          data.contentType.present ? data.contentType.value : this.contentType,
      hook: data.hook.present ? data.hook.value : this.hook,
      problem: data.problem.present ? data.problem.value : this.problem,
      demonstration: data.demonstration.present
          ? data.demonstration.value
          : this.demonstration,
      script: data.script.present ? data.script.value : this.script,
      cta: data.cta.present ? data.cta.value : this.cta,
      status: data.status.present ? data.status.value : this.status,
      platformUrl:
          data.platformUrl.present ? data.platformUrl.value : this.platformUrl,
      publishedAt:
          data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Content(')
          ..write('id: $id, ')
          ..write('treasureId: $treasureId, ')
          ..write('contentType: $contentType, ')
          ..write('hook: $hook, ')
          ..write('problem: $problem, ')
          ..write('demonstration: $demonstration, ')
          ..write('script: $script, ')
          ..write('cta: $cta, ')
          ..write('status: $status, ')
          ..write('platformUrl: $platformUrl, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      treasureId,
      contentType,
      hook,
      problem,
      demonstration,
      script,
      cta,
      status,
      platformUrl,
      publishedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Content &&
          other.id == this.id &&
          other.treasureId == this.treasureId &&
          other.contentType == this.contentType &&
          other.hook == this.hook &&
          other.problem == this.problem &&
          other.demonstration == this.demonstration &&
          other.script == this.script &&
          other.cta == this.cta &&
          other.status == this.status &&
          other.platformUrl == this.platformUrl &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ContentsCompanion extends UpdateCompanion<Content> {
  final Value<String> id;
  final Value<String> treasureId;
  final Value<String> contentType;
  final Value<String?> hook;
  final Value<String?> problem;
  final Value<String?> demonstration;
  final Value<String?> script;
  final Value<String?> cta;
  final Value<String> status;
  final Value<String?> platformUrl;
  final Value<DateTime?> publishedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ContentsCompanion({
    this.id = const Value.absent(),
    this.treasureId = const Value.absent(),
    this.contentType = const Value.absent(),
    this.hook = const Value.absent(),
    this.problem = const Value.absent(),
    this.demonstration = const Value.absent(),
    this.script = const Value.absent(),
    this.cta = const Value.absent(),
    this.status = const Value.absent(),
    this.platformUrl = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentsCompanion.insert({
    required String id,
    required String treasureId,
    required String contentType,
    this.hook = const Value.absent(),
    this.problem = const Value.absent(),
    this.demonstration = const Value.absent(),
    this.script = const Value.absent(),
    this.cta = const Value.absent(),
    this.status = const Value.absent(),
    this.platformUrl = const Value.absent(),
    this.publishedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        treasureId = Value(treasureId),
        contentType = Value(contentType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Content> custom({
    Expression<String>? id,
    Expression<String>? treasureId,
    Expression<String>? contentType,
    Expression<String>? hook,
    Expression<String>? problem,
    Expression<String>? demonstration,
    Expression<String>? script,
    Expression<String>? cta,
    Expression<String>? status,
    Expression<String>? platformUrl,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (treasureId != null) 'treasure_id': treasureId,
      if (contentType != null) 'content_type': contentType,
      if (hook != null) 'hook': hook,
      if (problem != null) 'problem': problem,
      if (demonstration != null) 'demonstration': demonstration,
      if (script != null) 'script': script,
      if (cta != null) 'cta': cta,
      if (status != null) 'status': status,
      if (platformUrl != null) 'platform_url': platformUrl,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? treasureId,
      Value<String>? contentType,
      Value<String?>? hook,
      Value<String?>? problem,
      Value<String?>? demonstration,
      Value<String?>? script,
      Value<String?>? cta,
      Value<String>? status,
      Value<String?>? platformUrl,
      Value<DateTime?>? publishedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ContentsCompanion(
      id: id ?? this.id,
      treasureId: treasureId ?? this.treasureId,
      contentType: contentType ?? this.contentType,
      hook: hook ?? this.hook,
      problem: problem ?? this.problem,
      demonstration: demonstration ?? this.demonstration,
      script: script ?? this.script,
      cta: cta ?? this.cta,
      status: status ?? this.status,
      platformUrl: platformUrl ?? this.platformUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (treasureId.present) {
      map['treasure_id'] = Variable<String>(treasureId.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (hook.present) {
      map['hook'] = Variable<String>(hook.value);
    }
    if (problem.present) {
      map['problem'] = Variable<String>(problem.value);
    }
    if (demonstration.present) {
      map['demonstration'] = Variable<String>(demonstration.value);
    }
    if (script.present) {
      map['script'] = Variable<String>(script.value);
    }
    if (cta.present) {
      map['cta'] = Variable<String>(cta.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (platformUrl.present) {
      map['platform_url'] = Variable<String>(platformUrl.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentsCompanion(')
          ..write('id: $id, ')
          ..write('treasureId: $treasureId, ')
          ..write('contentType: $contentType, ')
          ..write('hook: $hook, ')
          ..write('problem: $problem, ')
          ..write('demonstration: $demonstration, ')
          ..write('script: $script, ')
          ..write('cta: $cta, ')
          ..write('status: $status, ')
          ..write('platformUrl: $platformUrl, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentMetricsTable extends ContentMetrics
    with TableInfo<$ContentMetricsTable, ContentMetric> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentMetricsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentIdMeta =
      const VerificationMeta('contentId');
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
      'content_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES contents (id) ON DELETE CASCADE'));
  static const VerificationMeta _viewsMeta = const VerificationMeta('views');
  @override
  late final GeneratedColumn<int> views = GeneratedColumn<int>(
      'views', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _likesMeta = const VerificationMeta('likes');
  @override
  late final GeneratedColumn<int> likes = GeneratedColumn<int>(
      'likes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _commentsMeta =
      const VerificationMeta('comments');
  @override
  late final GeneratedColumn<int> comments = GeneratedColumn<int>(
      'comments', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<int> shares = GeneratedColumn<int>(
      'shares', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _savesMeta = const VerificationMeta('saves');
  @override
  late final GeneratedColumn<int> saves = GeneratedColumn<int>(
      'saves', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _followersGainedMeta =
      const VerificationMeta('followersGained');
  @override
  late final GeneratedColumn<int> followersGained = GeneratedColumn<int>(
      'followers_gained', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _performanceNotesMeta =
      const VerificationMeta('performanceNotes');
  @override
  late final GeneratedColumn<String> performanceNotes = GeneratedColumn<String>(
      'performance_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        contentId,
        views,
        likes,
        comments,
        shares,
        saves,
        followersGained,
        performanceNotes,
        recordedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_metrics';
  @override
  VerificationContext validateIntegrity(Insertable<ContentMetric> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(_contentIdMeta,
          contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta));
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('views')) {
      context.handle(
          _viewsMeta, views.isAcceptableOrUnknown(data['views']!, _viewsMeta));
    }
    if (data.containsKey('likes')) {
      context.handle(
          _likesMeta, likes.isAcceptableOrUnknown(data['likes']!, _likesMeta));
    }
    if (data.containsKey('comments')) {
      context.handle(_commentsMeta,
          comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta));
    }
    if (data.containsKey('shares')) {
      context.handle(_sharesMeta,
          shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta));
    }
    if (data.containsKey('saves')) {
      context.handle(
          _savesMeta, saves.isAcceptableOrUnknown(data['saves']!, _savesMeta));
    }
    if (data.containsKey('followers_gained')) {
      context.handle(
          _followersGainedMeta,
          followersGained.isAcceptableOrUnknown(
              data['followers_gained']!, _followersGainedMeta));
    }
    if (data.containsKey('performance_notes')) {
      context.handle(
          _performanceNotesMeta,
          performanceNotes.isAcceptableOrUnknown(
              data['performance_notes']!, _performanceNotesMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentMetric map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentMetric(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      contentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_id'])!,
      views: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}views'])!,
      likes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}likes'])!,
      comments: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}comments'])!,
      shares: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shares'])!,
      saves: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}saves'])!,
      followersGained: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}followers_gained'])!,
      performanceNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}performance_notes']),
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
    );
  }

  @override
  $ContentMetricsTable createAlias(String alias) {
    return $ContentMetricsTable(attachedDatabase, alias);
  }
}

class ContentMetric extends DataClass implements Insertable<ContentMetric> {
  final String id;
  final String contentId;
  final int views;
  final int likes;
  final int comments;
  final int shares;
  final int saves;
  final int followersGained;
  final String? performanceNotes;
  final DateTime recordedAt;
  const ContentMetric(
      {required this.id,
      required this.contentId,
      required this.views,
      required this.likes,
      required this.comments,
      required this.shares,
      required this.saves,
      required this.followersGained,
      this.performanceNotes,
      required this.recordedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content_id'] = Variable<String>(contentId);
    map['views'] = Variable<int>(views);
    map['likes'] = Variable<int>(likes);
    map['comments'] = Variable<int>(comments);
    map['shares'] = Variable<int>(shares);
    map['saves'] = Variable<int>(saves);
    map['followers_gained'] = Variable<int>(followersGained);
    if (!nullToAbsent || performanceNotes != null) {
      map['performance_notes'] = Variable<String>(performanceNotes);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  ContentMetricsCompanion toCompanion(bool nullToAbsent) {
    return ContentMetricsCompanion(
      id: Value(id),
      contentId: Value(contentId),
      views: Value(views),
      likes: Value(likes),
      comments: Value(comments),
      shares: Value(shares),
      saves: Value(saves),
      followersGained: Value(followersGained),
      performanceNotes: performanceNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(performanceNotes),
      recordedAt: Value(recordedAt),
    );
  }

  factory ContentMetric.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentMetric(
      id: serializer.fromJson<String>(json['id']),
      contentId: serializer.fromJson<String>(json['contentId']),
      views: serializer.fromJson<int>(json['views']),
      likes: serializer.fromJson<int>(json['likes']),
      comments: serializer.fromJson<int>(json['comments']),
      shares: serializer.fromJson<int>(json['shares']),
      saves: serializer.fromJson<int>(json['saves']),
      followersGained: serializer.fromJson<int>(json['followersGained']),
      performanceNotes: serializer.fromJson<String?>(json['performanceNotes']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'contentId': serializer.toJson<String>(contentId),
      'views': serializer.toJson<int>(views),
      'likes': serializer.toJson<int>(likes),
      'comments': serializer.toJson<int>(comments),
      'shares': serializer.toJson<int>(shares),
      'saves': serializer.toJson<int>(saves),
      'followersGained': serializer.toJson<int>(followersGained),
      'performanceNotes': serializer.toJson<String?>(performanceNotes),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  ContentMetric copyWith(
          {String? id,
          String? contentId,
          int? views,
          int? likes,
          int? comments,
          int? shares,
          int? saves,
          int? followersGained,
          Value<String?> performanceNotes = const Value.absent(),
          DateTime? recordedAt}) =>
      ContentMetric(
        id: id ?? this.id,
        contentId: contentId ?? this.contentId,
        views: views ?? this.views,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        shares: shares ?? this.shares,
        saves: saves ?? this.saves,
        followersGained: followersGained ?? this.followersGained,
        performanceNotes: performanceNotes.present
            ? performanceNotes.value
            : this.performanceNotes,
        recordedAt: recordedAt ?? this.recordedAt,
      );
  ContentMetric copyWithCompanion(ContentMetricsCompanion data) {
    return ContentMetric(
      id: data.id.present ? data.id.value : this.id,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      views: data.views.present ? data.views.value : this.views,
      likes: data.likes.present ? data.likes.value : this.likes,
      comments: data.comments.present ? data.comments.value : this.comments,
      shares: data.shares.present ? data.shares.value : this.shares,
      saves: data.saves.present ? data.saves.value : this.saves,
      followersGained: data.followersGained.present
          ? data.followersGained.value
          : this.followersGained,
      performanceNotes: data.performanceNotes.present
          ? data.performanceNotes.value
          : this.performanceNotes,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetric(')
          ..write('id: $id, ')
          ..write('contentId: $contentId, ')
          ..write('views: $views, ')
          ..write('likes: $likes, ')
          ..write('comments: $comments, ')
          ..write('shares: $shares, ')
          ..write('saves: $saves, ')
          ..write('followersGained: $followersGained, ')
          ..write('performanceNotes: $performanceNotes, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, contentId, views, likes, comments, shares,
      saves, followersGained, performanceNotes, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentMetric &&
          other.id == this.id &&
          other.contentId == this.contentId &&
          other.views == this.views &&
          other.likes == this.likes &&
          other.comments == this.comments &&
          other.shares == this.shares &&
          other.saves == this.saves &&
          other.followersGained == this.followersGained &&
          other.performanceNotes == this.performanceNotes &&
          other.recordedAt == this.recordedAt);
}

class ContentMetricsCompanion extends UpdateCompanion<ContentMetric> {
  final Value<String> id;
  final Value<String> contentId;
  final Value<int> views;
  final Value<int> likes;
  final Value<int> comments;
  final Value<int> shares;
  final Value<int> saves;
  final Value<int> followersGained;
  final Value<String?> performanceNotes;
  final Value<DateTime> recordedAt;
  final Value<int> rowid;
  const ContentMetricsCompanion({
    this.id = const Value.absent(),
    this.contentId = const Value.absent(),
    this.views = const Value.absent(),
    this.likes = const Value.absent(),
    this.comments = const Value.absent(),
    this.shares = const Value.absent(),
    this.saves = const Value.absent(),
    this.followersGained = const Value.absent(),
    this.performanceNotes = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentMetricsCompanion.insert({
    required String id,
    required String contentId,
    this.views = const Value.absent(),
    this.likes = const Value.absent(),
    this.comments = const Value.absent(),
    this.shares = const Value.absent(),
    this.saves = const Value.absent(),
    this.followersGained = const Value.absent(),
    this.performanceNotes = const Value.absent(),
    required DateTime recordedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        contentId = Value(contentId),
        recordedAt = Value(recordedAt);
  static Insertable<ContentMetric> custom({
    Expression<String>? id,
    Expression<String>? contentId,
    Expression<int>? views,
    Expression<int>? likes,
    Expression<int>? comments,
    Expression<int>? shares,
    Expression<int>? saves,
    Expression<int>? followersGained,
    Expression<String>? performanceNotes,
    Expression<DateTime>? recordedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contentId != null) 'content_id': contentId,
      if (views != null) 'views': views,
      if (likes != null) 'likes': likes,
      if (comments != null) 'comments': comments,
      if (shares != null) 'shares': shares,
      if (saves != null) 'saves': saves,
      if (followersGained != null) 'followers_gained': followersGained,
      if (performanceNotes != null) 'performance_notes': performanceNotes,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentMetricsCompanion copyWith(
      {Value<String>? id,
      Value<String>? contentId,
      Value<int>? views,
      Value<int>? likes,
      Value<int>? comments,
      Value<int>? shares,
      Value<int>? saves,
      Value<int>? followersGained,
      Value<String?>? performanceNotes,
      Value<DateTime>? recordedAt,
      Value<int>? rowid}) {
    return ContentMetricsCompanion(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      saves: saves ?? this.saves,
      followersGained: followersGained ?? this.followersGained,
      performanceNotes: performanceNotes ?? this.performanceNotes,
      recordedAt: recordedAt ?? this.recordedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (views.present) {
      map['views'] = Variable<int>(views.value);
    }
    if (likes.present) {
      map['likes'] = Variable<int>(likes.value);
    }
    if (comments.present) {
      map['comments'] = Variable<int>(comments.value);
    }
    if (shares.present) {
      map['shares'] = Variable<int>(shares.value);
    }
    if (saves.present) {
      map['saves'] = Variable<int>(saves.value);
    }
    if (followersGained.present) {
      map['followers_gained'] = Variable<int>(followersGained.value);
    }
    if (performanceNotes.present) {
      map['performance_notes'] = Variable<String>(performanceNotes.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetricsCompanion(')
          ..write('id: $id, ')
          ..write('contentId: $contentId, ')
          ..write('views: $views, ')
          ..write('likes: $likes, ')
          ..write('comments: $comments, ')
          ..write('shares: $shares, ')
          ..write('saves: $saves, ')
          ..write('followersGained: $followersGained, ')
          ..write('performanceNotes: $performanceNotes, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $TreasuresTable treasures = $TreasuresTable(this);
  late final $TreasureTagsTable treasureTags = $TreasureTagsTable(this);
  late final $SourcesTable sources = $SourcesTable(this);
  late final $TestRecordsTable testRecords = $TestRecordsTable(this);
  late final $ContentsTable contents = $ContentsTable(this);
  late final $ContentMetricsTable contentMetrics = $ContentMetricsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        tags,
        treasures,
        treasureTags,
        sources,
        testRecords,
        contents,
        contentMetrics
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('treasures',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('treasure_tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('tags',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('treasure_tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('treasures',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('sources', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('treasures',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('test_records', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('treasures',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('contents', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('contents',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('content_metrics', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  required String icon,
  Value<bool> isDefault,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String> icon,
  Value<bool> isDefault,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoriesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            description: description,
            icon: icon,
            isDefault: isDefault,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            required String icon,
            Value<bool> isDefault = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            description: description,
            icon: icon,
            isDefault: isDefault,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$CategoriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDefault => $state.composableBuilder(
      column: $state.table.isDefault,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter treasuresRefs(
      ComposableFilter Function($$TreasuresTableFilterComposer f) f) {
    final $$TreasuresTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.treasures,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) =>
            $$TreasuresTableFilterComposer(ComposerState(
                $state.db, $state.db.treasures, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDefault => $state.composableBuilder(
      column: $state.table.isDefault,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  required String id,
  required String name,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$TagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder> {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TagsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TagsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$TagsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter treasureTagsRefs(
      ComposableFilter Function($$TreasureTagsTableFilterComposer f) f) {
    final $$TreasureTagsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.treasureTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder, parentComposers) =>
            $$TreasureTagsTableFilterComposer(ComposerState($state.db,
                $state.db.treasureTags, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$TagsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TreasuresTableCreateCompanionBuilder = TreasuresCompanion Function({
  required String id,
  required String title,
  required String shortDescription,
  Value<String?> problem,
  Value<String?> solution,
  Value<String?> whyUseful,
  required String categoryId,
  Value<String> status,
  Value<String?> device,
  Value<String?> platform,
  Value<String?> osVersion,
  Value<String?> requirements,
  Value<String?> stepsJson,
  Value<String?> limitations,
  Value<String?> securityNotes,
  Value<String> researchStatus,
  Value<bool> isVerified,
  Value<bool> isFavorite,
  Value<bool> noAppNeeded,
  Value<int> contentPotential,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TreasuresTableUpdateCompanionBuilder = TreasuresCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> shortDescription,
  Value<String?> problem,
  Value<String?> solution,
  Value<String?> whyUseful,
  Value<String> categoryId,
  Value<String> status,
  Value<String?> device,
  Value<String?> platform,
  Value<String?> osVersion,
  Value<String?> requirements,
  Value<String?> stepsJson,
  Value<String?> limitations,
  Value<String?> securityNotes,
  Value<String> researchStatus,
  Value<bool> isVerified,
  Value<bool> isFavorite,
  Value<bool> noAppNeeded,
  Value<int> contentPotential,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TreasuresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TreasuresTable,
    Treasure,
    $$TreasuresTableFilterComposer,
    $$TreasuresTableOrderingComposer,
    $$TreasuresTableCreateCompanionBuilder,
    $$TreasuresTableUpdateCompanionBuilder> {
  $$TreasuresTableTableManager(_$AppDatabase db, $TreasuresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TreasuresTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TreasuresTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> shortDescription = const Value.absent(),
            Value<String?> problem = const Value.absent(),
            Value<String?> solution = const Value.absent(),
            Value<String?> whyUseful = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> device = const Value.absent(),
            Value<String?> platform = const Value.absent(),
            Value<String?> osVersion = const Value.absent(),
            Value<String?> requirements = const Value.absent(),
            Value<String?> stepsJson = const Value.absent(),
            Value<String?> limitations = const Value.absent(),
            Value<String?> securityNotes = const Value.absent(),
            Value<String> researchStatus = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> noAppNeeded = const Value.absent(),
            Value<int> contentPotential = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TreasuresCompanion(
            id: id,
            title: title,
            shortDescription: shortDescription,
            problem: problem,
            solution: solution,
            whyUseful: whyUseful,
            categoryId: categoryId,
            status: status,
            device: device,
            platform: platform,
            osVersion: osVersion,
            requirements: requirements,
            stepsJson: stepsJson,
            limitations: limitations,
            securityNotes: securityNotes,
            researchStatus: researchStatus,
            isVerified: isVerified,
            isFavorite: isFavorite,
            noAppNeeded: noAppNeeded,
            contentPotential: contentPotential,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String shortDescription,
            Value<String?> problem = const Value.absent(),
            Value<String?> solution = const Value.absent(),
            Value<String?> whyUseful = const Value.absent(),
            required String categoryId,
            Value<String> status = const Value.absent(),
            Value<String?> device = const Value.absent(),
            Value<String?> platform = const Value.absent(),
            Value<String?> osVersion = const Value.absent(),
            Value<String?> requirements = const Value.absent(),
            Value<String?> stepsJson = const Value.absent(),
            Value<String?> limitations = const Value.absent(),
            Value<String?> securityNotes = const Value.absent(),
            Value<String> researchStatus = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> noAppNeeded = const Value.absent(),
            Value<int> contentPotential = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TreasuresCompanion.insert(
            id: id,
            title: title,
            shortDescription: shortDescription,
            problem: problem,
            solution: solution,
            whyUseful: whyUseful,
            categoryId: categoryId,
            status: status,
            device: device,
            platform: platform,
            osVersion: osVersion,
            requirements: requirements,
            stepsJson: stepsJson,
            limitations: limitations,
            securityNotes: securityNotes,
            researchStatus: researchStatus,
            isVerified: isVerified,
            isFavorite: isFavorite,
            noAppNeeded: noAppNeeded,
            contentPotential: contentPotential,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$TreasuresTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TreasuresTable> {
  $$TreasuresTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get shortDescription => $state.composableBuilder(
      column: $state.table.shortDescription,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get problem => $state.composableBuilder(
      column: $state.table.problem,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get solution => $state.composableBuilder(
      column: $state.table.solution,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get whyUseful => $state.composableBuilder(
      column: $state.table.whyUseful,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get device => $state.composableBuilder(
      column: $state.table.device,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get platform => $state.composableBuilder(
      column: $state.table.platform,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get osVersion => $state.composableBuilder(
      column: $state.table.osVersion,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get requirements => $state.composableBuilder(
      column: $state.table.requirements,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get stepsJson => $state.composableBuilder(
      column: $state.table.stepsJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get limitations => $state.composableBuilder(
      column: $state.table.limitations,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get securityNotes => $state.composableBuilder(
      column: $state.table.securityNotes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get researchStatus => $state.composableBuilder(
      column: $state.table.researchStatus,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isVerified => $state.composableBuilder(
      column: $state.table.isVerified,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get noAppNeeded => $state.composableBuilder(
      column: $state.table.noAppNeeded,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get contentPotential => $state.composableBuilder(
      column: $state.table.contentPotential,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoriesTableFilterComposer(ComposerState($state.db,
                $state.db.categories, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter treasureTagsRefs(
      ComposableFilter Function($$TreasureTagsTableFilterComposer f) f) {
    final $$TreasureTagsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.treasureTags,
        getReferencedColumn: (t) => t.treasureId,
        builder: (joinBuilder, parentComposers) =>
            $$TreasureTagsTableFilterComposer(ComposerState($state.db,
                $state.db.treasureTags, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter sourcesRefs(
      ComposableFilter Function($$SourcesTableFilterComposer f) f) {
    final $$SourcesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.sources,
        getReferencedColumn: (t) => t.treasureId,
        builder: (joinBuilder, parentComposers) => $$SourcesTableFilterComposer(
            ComposerState(
                $state.db, $state.db.sources, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter testRecordsRefs(
      ComposableFilter Function($$TestRecordsTableFilterComposer f) f) {
    final $$TestRecordsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.testRecords,
        getReferencedColumn: (t) => t.treasureId,
        builder: (joinBuilder, parentComposers) =>
            $$TestRecordsTableFilterComposer(ComposerState($state.db,
                $state.db.testRecords, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter contentsRefs(
      ComposableFilter Function($$ContentsTableFilterComposer f) f) {
    final $$ContentsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.contents,
        getReferencedColumn: (t) => t.treasureId,
        builder: (joinBuilder, parentComposers) =>
            $$ContentsTableFilterComposer(ComposerState(
                $state.db, $state.db.contents, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$TreasuresTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TreasuresTable> {
  $$TreasuresTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get shortDescription => $state.composableBuilder(
      column: $state.table.shortDescription,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get problem => $state.composableBuilder(
      column: $state.table.problem,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get solution => $state.composableBuilder(
      column: $state.table.solution,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get whyUseful => $state.composableBuilder(
      column: $state.table.whyUseful,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get device => $state.composableBuilder(
      column: $state.table.device,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get platform => $state.composableBuilder(
      column: $state.table.platform,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get osVersion => $state.composableBuilder(
      column: $state.table.osVersion,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get requirements => $state.composableBuilder(
      column: $state.table.requirements,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get stepsJson => $state.composableBuilder(
      column: $state.table.stepsJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get limitations => $state.composableBuilder(
      column: $state.table.limitations,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get securityNotes => $state.composableBuilder(
      column: $state.table.securityNotes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get researchStatus => $state.composableBuilder(
      column: $state.table.researchStatus,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isVerified => $state.composableBuilder(
      column: $state.table.isVerified,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get noAppNeeded => $state.composableBuilder(
      column: $state.table.noAppNeeded,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get contentPotential => $state.composableBuilder(
      column: $state.table.contentPotential,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $state.db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoriesTableOrderingComposer(ComposerState($state.db,
                $state.db.categories, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$TreasureTagsTableCreateCompanionBuilder = TreasureTagsCompanion
    Function({
  required String treasureId,
  required String tagId,
  Value<int> rowid,
});
typedef $$TreasureTagsTableUpdateCompanionBuilder = TreasureTagsCompanion
    Function({
  Value<String> treasureId,
  Value<String> tagId,
  Value<int> rowid,
});

class $$TreasureTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TreasureTagsTable,
    TreasureTag,
    $$TreasureTagsTableFilterComposer,
    $$TreasureTagsTableOrderingComposer,
    $$TreasureTagsTableCreateCompanionBuilder,
    $$TreasureTagsTableUpdateCompanionBuilder> {
  $$TreasureTagsTableTableManager(_$AppDatabase db, $TreasureTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TreasureTagsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TreasureTagsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> treasureId = const Value.absent(),
            Value<String> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TreasureTagsCompanion(
            treasureId: treasureId,
            tagId: tagId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String treasureId,
            required String tagId,
            Value<int> rowid = const Value.absent(),
          }) =>
              TreasureTagsCompanion.insert(
            treasureId: treasureId,
            tagId: tagId,
            rowid: rowid,
          ),
        ));
}

class $$TreasureTagsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TreasureTagsTable> {
  $$TreasureTagsTableFilterComposer(super.$state);
  $$TreasuresTableFilterComposer get treasureId {
    final $$TreasuresTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.treasureId,
        referencedTable: $state.db.treasures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TreasuresTableFilterComposer(ComposerState(
                $state.db, $state.db.treasures, joinBuilder, parentComposers)));
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $state.db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$TagsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.tags, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$TreasureTagsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TreasureTagsTable> {
  $$TreasureTagsTableOrderingComposer(super.$state);
  $$TreasuresTableOrderingComposer get treasureId {
    final $$TreasuresTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.treasureId,
        referencedTable: $state.db.treasures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TreasuresTableOrderingComposer(ComposerState(
                $state.db, $state.db.treasures, joinBuilder, parentComposers)));
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $state.db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$TagsTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.tags, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$SourcesTableCreateCompanionBuilder = SourcesCompanion Function({
  required String id,
  required String treasureId,
  required String title,
  Value<String?> url,
  required String sourceType,
  Value<String?> notes,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SourcesTableUpdateCompanionBuilder = SourcesCompanion Function({
  Value<String> id,
  Value<String> treasureId,
  Value<String> title,
  Value<String?> url,
  Value<String> sourceType,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SourcesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SourcesTable,
    Source,
    $$SourcesTableFilterComposer,
    $$SourcesTableOrderingComposer,
    $$SourcesTableCreateCompanionBuilder,
    $$SourcesTableUpdateCompanionBuilder> {
  $$SourcesTableTableManager(_$AppDatabase db, $SourcesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SourcesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SourcesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> treasureId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> url = const Value.absent(),
            Value<String> sourceType = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SourcesCompanion(
            id: id,
            treasureId: treasureId,
            title: title,
            url: url,
            sourceType: sourceType,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String treasureId,
            required String title,
            Value<String?> url = const Value.absent(),
            required String sourceType,
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SourcesCompanion.insert(
            id: id,
            treasureId: treasureId,
            title: title,
            url: url,
            sourceType: sourceType,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$SourcesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get sourceType => $state.composableBuilder(
      column: $state.table.sourceType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$TreasuresTableFilterComposer get treasureId {
    final $$TreasuresTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.treasureId,
        referencedTable: $state.db.treasures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TreasuresTableFilterComposer(ComposerState(
                $state.db, $state.db.treasures, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$SourcesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SourcesTable> {
  $$SourcesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get sourceType => $state.composableBuilder(
      column: $state.table.sourceType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$TreasuresTableOrderingComposer get treasureId {
    final $$TreasuresTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.treasureId,
        referencedTable: $state.db.treasures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TreasuresTableOrderingComposer(ComposerState(
                $state.db, $state.db.treasures, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$TestRecordsTableCreateCompanionBuilder = TestRecordsCompanion
    Function({
  required String id,
  required String treasureId,
  required String device,
  required String osVersion,
  Value<String?> environment,
  required String result,
  Value<String?> notes,
  required DateTime testedAt,
  Value<int> rowid,
});
typedef $$TestRecordsTableUpdateCompanionBuilder = TestRecordsCompanion
    Function({
  Value<String> id,
  Value<String> treasureId,
  Value<String> device,
  Value<String> osVersion,
  Value<String?> environment,
  Value<String> result,
  Value<String?> notes,
  Value<DateTime> testedAt,
  Value<int> rowid,
});

class $$TestRecordsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TestRecordsTable,
    TestRecord,
    $$TestRecordsTableFilterComposer,
    $$TestRecordsTableOrderingComposer,
    $$TestRecordsTableCreateCompanionBuilder,
    $$TestRecordsTableUpdateCompanionBuilder> {
  $$TestRecordsTableTableManager(_$AppDatabase db, $TestRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TestRecordsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TestRecordsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> treasureId = const Value.absent(),
            Value<String> device = const Value.absent(),
            Value<String> osVersion = const Value.absent(),
            Value<String?> environment = const Value.absent(),
            Value<String> result = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> testedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TestRecordsCompanion(
            id: id,
            treasureId: treasureId,
            device: device,
            osVersion: osVersion,
            environment: environment,
            result: result,
            notes: notes,
            testedAt: testedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String treasureId,
            required String device,
            required String osVersion,
            Value<String?> environment = const Value.absent(),
            required String result,
            Value<String?> notes = const Value.absent(),
            required DateTime testedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TestRecordsCompanion.insert(
            id: id,
            treasureId: treasureId,
            device: device,
            osVersion: osVersion,
            environment: environment,
            result: result,
            notes: notes,
            testedAt: testedAt,
            rowid: rowid,
          ),
        ));
}

class $$TestRecordsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TestRecordsTable> {
  $$TestRecordsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get device => $state.composableBuilder(
      column: $state.table.device,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get osVersion => $state.composableBuilder(
      column: $state.table.osVersion,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get environment => $state.composableBuilder(
      column: $state.table.environment,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get result => $state.composableBuilder(
      column: $state.table.result,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get testedAt => $state.composableBuilder(
      column: $state.table.testedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$TreasuresTableFilterComposer get treasureId {
    final $$TreasuresTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.treasureId,
        referencedTable: $state.db.treasures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TreasuresTableFilterComposer(ComposerState(
                $state.db, $state.db.treasures, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$TestRecordsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TestRecordsTable> {
  $$TestRecordsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get device => $state.composableBuilder(
      column: $state.table.device,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get osVersion => $state.composableBuilder(
      column: $state.table.osVersion,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get environment => $state.composableBuilder(
      column: $state.table.environment,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get result => $state.composableBuilder(
      column: $state.table.result,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get testedAt => $state.composableBuilder(
      column: $state.table.testedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$TreasuresTableOrderingComposer get treasureId {
    final $$TreasuresTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.treasureId,
        referencedTable: $state.db.treasures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TreasuresTableOrderingComposer(ComposerState(
                $state.db, $state.db.treasures, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ContentsTableCreateCompanionBuilder = ContentsCompanion Function({
  required String id,
  required String treasureId,
  required String contentType,
  Value<String?> hook,
  Value<String?> problem,
  Value<String?> demonstration,
  Value<String?> script,
  Value<String?> cta,
  Value<String> status,
  Value<String?> platformUrl,
  Value<DateTime?> publishedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ContentsTableUpdateCompanionBuilder = ContentsCompanion Function({
  Value<String> id,
  Value<String> treasureId,
  Value<String> contentType,
  Value<String?> hook,
  Value<String?> problem,
  Value<String?> demonstration,
  Value<String?> script,
  Value<String?> cta,
  Value<String> status,
  Value<String?> platformUrl,
  Value<DateTime?> publishedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ContentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContentsTable,
    Content,
    $$ContentsTableFilterComposer,
    $$ContentsTableOrderingComposer,
    $$ContentsTableCreateCompanionBuilder,
    $$ContentsTableUpdateCompanionBuilder> {
  $$ContentsTableTableManager(_$AppDatabase db, $ContentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ContentsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ContentsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> treasureId = const Value.absent(),
            Value<String> contentType = const Value.absent(),
            Value<String?> hook = const Value.absent(),
            Value<String?> problem = const Value.absent(),
            Value<String?> demonstration = const Value.absent(),
            Value<String?> script = const Value.absent(),
            Value<String?> cta = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> platformUrl = const Value.absent(),
            Value<DateTime?> publishedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentsCompanion(
            id: id,
            treasureId: treasureId,
            contentType: contentType,
            hook: hook,
            problem: problem,
            demonstration: demonstration,
            script: script,
            cta: cta,
            status: status,
            platformUrl: platformUrl,
            publishedAt: publishedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String treasureId,
            required String contentType,
            Value<String?> hook = const Value.absent(),
            Value<String?> problem = const Value.absent(),
            Value<String?> demonstration = const Value.absent(),
            Value<String?> script = const Value.absent(),
            Value<String?> cta = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> platformUrl = const Value.absent(),
            Value<DateTime?> publishedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentsCompanion.insert(
            id: id,
            treasureId: treasureId,
            contentType: contentType,
            hook: hook,
            problem: problem,
            demonstration: demonstration,
            script: script,
            cta: cta,
            status: status,
            platformUrl: platformUrl,
            publishedAt: publishedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
        ));
}

class $$ContentsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ContentsTable> {
  $$ContentsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get contentType => $state.composableBuilder(
      column: $state.table.contentType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get hook => $state.composableBuilder(
      column: $state.table.hook,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get problem => $state.composableBuilder(
      column: $state.table.problem,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get demonstration => $state.composableBuilder(
      column: $state.table.demonstration,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get script => $state.composableBuilder(
      column: $state.table.script,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cta => $state.composableBuilder(
      column: $state.table.cta,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get platformUrl => $state.composableBuilder(
      column: $state.table.platformUrl,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get publishedAt => $state.composableBuilder(
      column: $state.table.publishedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$TreasuresTableFilterComposer get treasureId {
    final $$TreasuresTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.treasureId,
        referencedTable: $state.db.treasures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TreasuresTableFilterComposer(ComposerState(
                $state.db, $state.db.treasures, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter contentMetricsRefs(
      ComposableFilter Function($$ContentMetricsTableFilterComposer f) f) {
    final $$ContentMetricsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.contentMetrics,
        getReferencedColumn: (t) => t.contentId,
        builder: (joinBuilder, parentComposers) =>
            $$ContentMetricsTableFilterComposer(ComposerState($state.db,
                $state.db.contentMetrics, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ContentsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ContentsTable> {
  $$ContentsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get contentType => $state.composableBuilder(
      column: $state.table.contentType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get hook => $state.composableBuilder(
      column: $state.table.hook,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get problem => $state.composableBuilder(
      column: $state.table.problem,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get demonstration => $state.composableBuilder(
      column: $state.table.demonstration,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get script => $state.composableBuilder(
      column: $state.table.script,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cta => $state.composableBuilder(
      column: $state.table.cta,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get platformUrl => $state.composableBuilder(
      column: $state.table.platformUrl,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get publishedAt => $state.composableBuilder(
      column: $state.table.publishedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$TreasuresTableOrderingComposer get treasureId {
    final $$TreasuresTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.treasureId,
        referencedTable: $state.db.treasures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TreasuresTableOrderingComposer(ComposerState(
                $state.db, $state.db.treasures, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ContentMetricsTableCreateCompanionBuilder = ContentMetricsCompanion
    Function({
  required String id,
  required String contentId,
  Value<int> views,
  Value<int> likes,
  Value<int> comments,
  Value<int> shares,
  Value<int> saves,
  Value<int> followersGained,
  Value<String?> performanceNotes,
  required DateTime recordedAt,
  Value<int> rowid,
});
typedef $$ContentMetricsTableUpdateCompanionBuilder = ContentMetricsCompanion
    Function({
  Value<String> id,
  Value<String> contentId,
  Value<int> views,
  Value<int> likes,
  Value<int> comments,
  Value<int> shares,
  Value<int> saves,
  Value<int> followersGained,
  Value<String?> performanceNotes,
  Value<DateTime> recordedAt,
  Value<int> rowid,
});

class $$ContentMetricsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContentMetricsTable,
    ContentMetric,
    $$ContentMetricsTableFilterComposer,
    $$ContentMetricsTableOrderingComposer,
    $$ContentMetricsTableCreateCompanionBuilder,
    $$ContentMetricsTableUpdateCompanionBuilder> {
  $$ContentMetricsTableTableManager(
      _$AppDatabase db, $ContentMetricsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ContentMetricsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ContentMetricsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> contentId = const Value.absent(),
            Value<int> views = const Value.absent(),
            Value<int> likes = const Value.absent(),
            Value<int> comments = const Value.absent(),
            Value<int> shares = const Value.absent(),
            Value<int> saves = const Value.absent(),
            Value<int> followersGained = const Value.absent(),
            Value<String?> performanceNotes = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentMetricsCompanion(
            id: id,
            contentId: contentId,
            views: views,
            likes: likes,
            comments: comments,
            shares: shares,
            saves: saves,
            followersGained: followersGained,
            performanceNotes: performanceNotes,
            recordedAt: recordedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String contentId,
            Value<int> views = const Value.absent(),
            Value<int> likes = const Value.absent(),
            Value<int> comments = const Value.absent(),
            Value<int> shares = const Value.absent(),
            Value<int> saves = const Value.absent(),
            Value<int> followersGained = const Value.absent(),
            Value<String?> performanceNotes = const Value.absent(),
            required DateTime recordedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentMetricsCompanion.insert(
            id: id,
            contentId: contentId,
            views: views,
            likes: likes,
            comments: comments,
            shares: shares,
            saves: saves,
            followersGained: followersGained,
            performanceNotes: performanceNotes,
            recordedAt: recordedAt,
            rowid: rowid,
          ),
        ));
}

class $$ContentMetricsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ContentMetricsTable> {
  $$ContentMetricsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get views => $state.composableBuilder(
      column: $state.table.views,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get likes => $state.composableBuilder(
      column: $state.table.likes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get comments => $state.composableBuilder(
      column: $state.table.comments,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get shares => $state.composableBuilder(
      column: $state.table.shares,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get saves => $state.composableBuilder(
      column: $state.table.saves,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get followersGained => $state.composableBuilder(
      column: $state.table.followersGained,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get performanceNotes => $state.composableBuilder(
      column: $state.table.performanceNotes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get recordedAt => $state.composableBuilder(
      column: $state.table.recordedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ContentsTableFilterComposer get contentId {
    final $$ContentsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contentId,
        referencedTable: $state.db.contents,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ContentsTableFilterComposer(ComposerState(
                $state.db, $state.db.contents, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ContentMetricsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ContentMetricsTable> {
  $$ContentMetricsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get views => $state.composableBuilder(
      column: $state.table.views,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get likes => $state.composableBuilder(
      column: $state.table.likes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get comments => $state.composableBuilder(
      column: $state.table.comments,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get shares => $state.composableBuilder(
      column: $state.table.shares,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get saves => $state.composableBuilder(
      column: $state.table.saves,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get followersGained => $state.composableBuilder(
      column: $state.table.followersGained,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get performanceNotes => $state.composableBuilder(
      column: $state.table.performanceNotes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get recordedAt => $state.composableBuilder(
      column: $state.table.recordedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ContentsTableOrderingComposer get contentId {
    final $$ContentsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contentId,
        referencedTable: $state.db.contents,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ContentsTableOrderingComposer(ComposerState(
                $state.db, $state.db.contents, joinBuilder, parentComposers)));
    return composer;
  }
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$TreasuresTableTableManager get treasures =>
      $$TreasuresTableTableManager(_db, _db.treasures);
  $$TreasureTagsTableTableManager get treasureTags =>
      $$TreasureTagsTableTableManager(_db, _db.treasureTags);
  $$SourcesTableTableManager get sources =>
      $$SourcesTableTableManager(_db, _db.sources);
  $$TestRecordsTableTableManager get testRecords =>
      $$TestRecordsTableTableManager(_db, _db.testRecords);
  $$ContentsTableTableManager get contents =>
      $$ContentsTableTableManager(_db, _db.contents);
  $$ContentMetricsTableTableManager get contentMetrics =>
      $$ContentMetricsTableTableManager(_db, _db.contentMetrics);
}
