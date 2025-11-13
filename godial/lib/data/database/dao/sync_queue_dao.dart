import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase> with _$SyncQueueDaoMixin {
  SyncQueueDao(AppDatabase db) : super(db);

  // Get all pending items
  Future<List<SyncQueueData>> getPendingItems() {
    return (select(syncQueue)
          ..where((s) => s.status.equals('pending'))
          ..orderBy([
            (s) => OrderingTerm(expression: s.priority, mode: OrderingMode.asc),
            (s) => OrderingTerm(expression: s.createdAt, mode: OrderingMode.asc),
          ]))
        .get();
  }

  // Watch pending items
  Stream<List<SyncQueueData>> watchPendingItems() {
    return (select(syncQueue)
          ..where((s) => s.status.equals('pending'))
          ..orderBy([
            (s) => OrderingTerm(expression: s.priority, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  // Add item to sync queue
  Future<int> addToQueue({
    required String entityType,
    required String entityId,
    required String action,
    required String payload,
    int priority = 5,
  }) {
    return into(syncQueue).insert(
      SyncQueueCompanion(
        entityType: Value(entityType),
        entityId: Value(entityId),
        action: Value(action),
        payload: Value(payload),
        priority: Value(priority),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  // Update item status
  Future<bool> updateItemStatus(int id, String status, {String? errorMessage}) async {
    final updated = await (update(syncQueue)
          ..where((s) => s.id.equals(id)))
        .write(
      SyncQueueCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        processedAt: status == 'completed' || status == 'failed'
            ? Value(DateTime.now())
            : const Value.absent(),
      ),
    );

    return updated > 0;
  }

  // Increment retry count
  Future<bool> incrementRetryCount(int id) async {
    final item = await (select(syncQueue)
          ..where((s) => s.id.equals(id)))
        .getSingleOrNull();

    if (item != null) {
      final newRetryCount = item.retryCount + 1;
      final status = newRetryCount >= item.maxRetries ? 'failed' : 'pending';

      final updated = await (update(syncQueue)
            ..where((s) => s.id.equals(id)))
          .write(
        SyncQueueCompanion(
          retryCount: Value(newRetryCount),
          status: Value(status),
        ),
      );

      return updated > 0;
    }

    return false;
  }

  // Clear completed items older than 7 days
  Future<int> clearOldCompletedItems() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    return (delete(syncQueue)
          ..where((s) =>
              s.status.equals('completed') &
              s.processedAt.isSmallerThanValue(sevenDaysAgo)))
        .go();
  }

  // Get failed items
  Future<List<SyncQueueData>> getFailedItems() {
    return (select(syncQueue)
          ..where((s) => s.status.equals('failed'))
          ..orderBy([
            (s) => OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  // Retry failed items
  Future<void> retryFailedItems() async {
    await (update(syncQueue)
          ..where((s) => s.status.equals('failed')))
        .write(
      const SyncQueueCompanion(
        status: Value('pending'),
        retryCount: Value(0),
      ),
    );
  }

  // Get sync statistics
  Future<Map<String, int>> getSyncStatistics() async {
    final pending = await (select(syncQueue)
          ..where((s) => s.status.equals('pending')))
        .get();

    final completed = await (select(syncQueue)
          ..where((s) => s.status.equals('completed')))
        .get();

    final failed = await (select(syncQueue)
          ..where((s) => s.status.equals('failed')))
        .get();

    return {
      'pending': pending.length,
      'completed': completed.length,
      'failed': failed.length,
    };
  }
}