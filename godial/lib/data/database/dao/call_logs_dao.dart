import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../tables/call_logs_table.dart';

part 'call_logs_dao.g.dart';

@DriftAccessor(tables: [CallLogs])
class CallLogsDao extends DatabaseAccessor<AppDatabase> with _$CallLogsDaoMixin {
  CallLogsDao(AppDatabase db) : super(db);

  // Get all call logs
  Future<List<CallLog>> getAllCallLogs() {
    return (select(callLogs)
          ..orderBy([
            (c) => OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  // Get call logs for a contact
  Future<List<CallLog>> getCallLogsForContact(String contactId) {
    return (select(callLogs)
          ..where((c) => c.contactId.equals(contactId))
          ..orderBy([
            (c) => OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  // Watch call logs (reactive)
  Stream<List<CallLog>> watchCallLogs() {
    return (select(callLogs)
          ..orderBy([
            (c) => OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  // Insert new call log
  Future<String> insertCallLog(CallLogsCompanion log) async {
    final id = const Uuid().v4();

    await into(callLogs).insert(
      log.copyWith(
        id: Value(id),
        createdAt: Value(DateTime.now()),
        syncStatus: const Value(0),
      ),
    );

    return id;
  }

  // Get today's calls
  Future<List<CallLog>> getTodaysCalls() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(callLogs)
          ..where((c) =>
              c.createdAt.isBiggerOrEqualValue(startOfDay) &
              c.createdAt.isSmallerThanValue(endOfDay))
          ..orderBy([
            (c) => OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  // Get call statistics
  Future<Map<String, int>> getCallStatistics() async {
    final allCalls = await getAllCallLogs();

    final stats = <String, int>{
      'total': allCalls.length,
      'outgoing': 0,
      'incoming': 0,
      'missed': 0,
      'answered': 0,
    };

    for (final call in allCalls) {
      if (call.direction == 'outgoing') stats['outgoing'] = stats['outgoing']! + 1;
      if (call.direction == 'incoming') stats['incoming'] = stats['incoming']! + 1;
      if (call.status == 'missed') stats['missed'] = stats['missed']! + 1;
      if (call.status == 'answered') stats['answered'] = stats['answered']! + 1;
    }

    return stats;
  }

  // Get calls to sync
  Future<List<CallLog>> getCallLogsToSync() {
    return (select(callLogs)
          ..where((c) => c.syncStatus.isNotValue(1)))
        .get();
  }
}