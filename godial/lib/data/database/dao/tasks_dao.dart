import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../tables/tasks_table.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(AppDatabase db) : super(db);

  // Get all tasks
  Future<List<Task>> getAllTasks() {
    return (select(tasks)
          ..orderBy([
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.asc),
            (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  // Get pending tasks
  Future<List<Task>> getPendingTasks() {
    return (select(tasks)
          ..where((t) => t.status.equals('pending'))
          ..orderBy([
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.asc),
            (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  // Watch today's tasks
  Stream<List<Task>> watchTodaysTasks() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(tasks)
          ..where((t) =>
              t.dueDate.isBiggerOrEqualValue(startOfDay) &
              t.dueDate.isSmallerThanValue(endOfDay) &
              t.status.equals('pending'))
          ..orderBy([
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  // Insert new task
  Future<String> insertTask(TasksCompanion task) async {
    final id = const Uuid().v4();
    final now = DateTime.now();

    await into(tasks).insert(
      task.copyWith(
        id: Value(id),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(0),
      ),
    );

    return id;
  }

  // Update task
  Future<bool> updateTask(Task task) async {
    final updated = await (update(tasks)
          ..where((t) => t.id.equals(task.id)))
        .write(
      TasksCompanion(
        title: Value(task.title),
        description: Value(task.description),
        dueDate: Value(task.dueDate),
        status: Value(task.status),
        priority: Value(task.priority),
        reminderTime: Value(task.reminderTime),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(2),
      ),
    );

    return updated > 0;
  }

  // Complete task
  Future<bool> completeTask(String id) async {
    final updated = await (update(tasks)
          ..where((t) => t.id.equals(id)))
        .write(
      TasksCompanion(
        status: const Value('completed'),
        completedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(2),
      ),
    );

    return updated > 0;
  }

  // Get tasks for contact
  Future<List<Task>> getTasksForContact(String contactId) {
    return (select(tasks)
          ..where((t) => t.contactId.equals(contactId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.status, mode: OrderingMode.asc),
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.asc),
          ]))
        .get();
  }

  // Get overdue tasks
  Future<List<Task>> getOverdueTasks() {
    final now = DateTime.now();

    return (select(tasks)
          ..where((t) =>
              t.dueDate.isSmallerThanValue(now) &
              t.status.equals('pending'))
          ..orderBy([
            (t) => OrderingTerm(expression: t.priority, mode: OrderingMode.asc),
          ]))
        .get();
  }
}