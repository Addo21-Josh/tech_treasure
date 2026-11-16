import 'package:drift/drift.dart';

/// Categories table
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tags table
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Core Treasures table
class Treasures extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get shortDescription => text()();
  TextColumn get problem => text().nullable()();
  TextColumn get solution => text().nullable()();
  TextColumn get whyUseful => text().nullable()();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get status => text().withDefault(const Constant('idea'))();
  TextColumn get device => text().nullable()();
  TextColumn get platform => text().nullable()();
  TextColumn get osVersion => text().nullable()();
  TextColumn get requirements => text().nullable()();
  TextColumn get stepsJson => text().nullable()();
  TextColumn get limitations => text().nullable()();
  TextColumn get securityNotes => text().nullable()();
  TextColumn get researchStatus =>
      text().withDefault(const Constant('notResearched'))();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get noAppNeeded => boolean().withDefault(const Constant(false))();
  IntColumn get contentPotential => integer().withDefault(const Constant(3))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Many-to-many junction table between Treasures and Tags
class TreasureTags extends Table {
  TextColumn get treasureId =>
      text().references(Treasures, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {treasureId, tagId};
}

/// Research citations and evidence sources
class Sources extends Table {
  TextColumn get id => text()();
  TextColumn get treasureId =>
      text().references(Treasures, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get url => text().nullable()();
  TextColumn get sourceType => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Multi-device empirical test logs
class TestRecords extends Table {
  TextColumn get id => text()();
  TextColumn get treasureId =>
      text().references(Treasures, #id, onDelete: KeyAction.cascade)();
  TextColumn get device => text()();
  TextColumn get osVersion => text()();
  TextColumn get environment => text().nullable()();
  TextColumn get result => text()(); // works, partiallyWorks, doesNotWork
  TextColumn get notes => text().nullable()();
  DateTimeColumn get testedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Scripting and production deliverables
class Contents extends Table {
  TextColumn get id => text()();
  TextColumn get treasureId =>
      text().references(Treasures, #id, onDelete: KeyAction.cascade)();
  TextColumn get contentType => text()();
  TextColumn get hook => text().nullable()();
  TextColumn get problem => text().nullable()();
  TextColumn get demonstration => text().nullable()();
  TextColumn get script => text().nullable()();
  TextColumn get cta => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('idea'))();
  TextColumn get platformUrl => text().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Performance analytics snapshots
class ContentMetrics extends Table {
  TextColumn get id => text()();
  TextColumn get contentId =>
      text().references(Contents, #id, onDelete: KeyAction.cascade)();
  IntColumn get views => integer().withDefault(const Constant(0))();
  IntColumn get likes => integer().withDefault(const Constant(0))();
  IntColumn get comments => integer().withDefault(const Constant(0))();
  IntColumn get shares => integer().withDefault(const Constant(0))();
  IntColumn get saves => integer().withDefault(const Constant(0))();
  IntColumn get followersGained => integer().withDefault(const Constant(0))();
  TextColumn get performanceNotes => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
