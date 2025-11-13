import 'package:drift/drift.dart';

class SyncQueue extends Table {
  // Primary key - auto incrementing
  IntColumn get id => integer().autoIncrement()();

  // Sync Information
  TextColumn get entityType => text()(); // contact, task, call_log, etc.
  TextColumn get entityId => text()();
  TextColumn get action => text()(); // create, update, delete
  TextColumn get payload => text()(); // JSON data
  IntColumn get priority => integer().withDefault(const Constant(5))(); // 1-10, 1 is highest
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  IntColumn get maxRetries => integer().withDefault(const Constant(3))();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, processing, completed, failed
  TextColumn get errorMessage => text().nullable()();

  // Metadata
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();

  @override
  String get tableName => 'sync_queue';
}