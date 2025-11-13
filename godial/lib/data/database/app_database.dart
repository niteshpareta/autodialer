import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables/contacts_table.dart';
import 'tables/call_logs_table.dart';
import 'tables/tasks_table.dart';
import 'tables/sync_queue_table.dart';
import 'dao/contacts_dao.dart';
import 'dao/call_logs_dao.dart';
import 'dao/tasks_dao.dart';
import 'dao/sync_queue_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Contacts, CallLogs, Tasks, SyncQueue],
  daos: [ContactsDao, CallLogsDao, TasksDao, SyncQueueDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();

        // Create indexes for better performance
        await customStatement(
          'CREATE INDEX idx_contacts_phone ON contacts(phone_primary)',
        );
        await customStatement(
          'CREATE INDEX idx_contacts_lead_score ON contacts(lead_score)',
        );
        await customStatement(
          'CREATE INDEX idx_contacts_sync_status ON contacts(sync_status)',
        );
        await customStatement(
          'CREATE INDEX idx_call_logs_contact_id ON call_logs(contact_id)',
        );
        await customStatement(
          'CREATE INDEX idx_call_logs_created_at ON call_logs(created_at)',
        );
        await customStatement(
          'CREATE INDEX idx_tasks_contact_id ON tasks(contact_id)',
        );
        await customStatement(
          'CREATE INDEX idx_tasks_due_date ON tasks(due_date)',
        );
        await customStatement(
          'CREATE INDEX idx_sync_queue_status ON sync_queue(status)',
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
      },
    );
  }

  // Initialize database
  Future<void> initializeDatabase() async {
    // Perform any initialization logic here
    print('Database initialized successfully');
  }

  // Clear all data (for testing or reset)
  Future<void> clearAllData() async {
    await delete(contacts).go();
    await delete(callLogs).go();
    await delete(tasks).go();
    await delete(syncQueue).go();
  }

  // Get database size
  Future<int> getDatabaseSize() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'godial.db'));
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }

  // Backup database
  Future<void> backupDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'godial.db'));
    final backupFile = File(p.join(dbFolder.path, 'godial_backup.db'));

    if (await dbFile.exists()) {
      await dbFile.copy(backupFile.path);
    }
  }

  // Restore database from backup
  Future<void> restoreDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'godial.db'));
    final backupFile = File(p.join(dbFolder.path, 'godial_backup.db'));

    if (await backupFile.exists()) {
      await backupFile.copy(dbFile.path);
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'godial.db'));

    return NativeDatabase.createInBackground(file);
  });
}