import 'package:drift/drift.dart';

class Contacts extends Table {
  // Primary key
  TextColumn get id => text()();

  // Basic Information
  TextColumn get firstName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  TextColumn get phonePrimary => text()();
  TextColumn get phoneSecondary => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get company => text().nullable()();
  TextColumn get designation => text().nullable()();
  TextColumn get address => text().nullable()();
  DateTimeColumn get dob => dateTime().nullable()();

  // Sales Information
  IntColumn get leadScore => integer().withDefault(const Constant(0))();
  TextColumn get stage => text().nullable()();
  RealColumn get dealValue => real().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get tags => text().nullable()(); // JSON array stored as string
  TextColumn get customFields => text().nullable()(); // JSON object stored as string

  // Notes and Additional Info
  TextColumn get notes => text().nullable()();
  TextColumn get extraField => text().nullable()();
  TextColumn get remarks => text().nullable()();

  // Metadata
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // Sync Information
  IntColumn get syncStatus => integer().withDefault(const Constant(0))(); // 0: pending, 1: synced, 2: modified
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'contacts';
}