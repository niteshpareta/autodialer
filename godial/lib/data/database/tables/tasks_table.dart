import 'package:drift/drift.dart';

class Tasks extends Table {
  // Primary key
  TextColumn get id => text()();

  // Task Information
  TextColumn get contactId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, completed, cancelled
  IntColumn get priority => integer().withDefault(const Constant(3))(); // 1-5, 1 is highest
  DateTimeColumn get reminderTime => dateTime().nullable()();
  TextColumn get recurringPattern => text().nullable()(); // JSON for recurring pattern

  // Metadata
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'tasks';
}