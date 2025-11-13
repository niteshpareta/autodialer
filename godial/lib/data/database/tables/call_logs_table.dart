import 'package:drift/drift.dart';

class CallLogs extends Table {
  // Primary key
  TextColumn get id => text()();

  // Call Information
  TextColumn get contactId => text().nullable()();
  TextColumn get phoneNumber => text()();
  TextColumn get direction => text()(); // incoming, outgoing, missed
  IntColumn get duration => integer().nullable()(); // in seconds
  TextColumn get status => text()(); // answered, missed, rejected, busy, no_answer
  TextColumn get notes => text().nullable()();
  TextColumn get recordingPath => text().nullable()();

  // Metadata
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'call_logs';
}