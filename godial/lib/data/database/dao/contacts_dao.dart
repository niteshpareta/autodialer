import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../tables/contacts_table.dart';

part 'contacts_dao.g.dart';

@DriftAccessor(tables: [Contacts])
class ContactsDao extends DatabaseAccessor<AppDatabase> with _$ContactsDaoMixin {
  ContactsDao(AppDatabase db) : super(db);

  // Get all contacts
  Future<List<Contact>> getAllContacts() => select(contacts).get();

  // Get contacts with pagination
  Future<List<Contact>> getContactsPaginated(int limit, int offset) {
    return (select(contacts)
          ..orderBy([
            (c) => OrderingTerm(expression: c.updatedAt, mode: OrderingMode.desc),
          ])
          ..limit(limit, offset: offset))
        .get();
  }

  // Watch all contacts (reactive)
  Stream<List<Contact>> watchAllContacts() {
    return (select(contacts)
          ..orderBy([
            (c) => OrderingTerm(expression: c.updatedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  // Get single contact by ID
  Future<Contact?> getContact(String id) {
    return (select(contacts)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  // Search contacts
  Future<List<Contact>> searchContacts(String query) {
    return (select(contacts)
          ..where((c) =>
              c.firstName.contains(query) |
              c.lastName.contains(query) |
              c.phonePrimary.contains(query) |
              c.email.contains(query) |
              c.company.contains(query)))
        .get();
  }

  // Insert new contact
  Future<String> insertContact(ContactsCompanion contact) async {
    final id = const Uuid().v4();
    final now = DateTime.now();

    await into(contacts).insert(
      contact.copyWith(
        id: Value(id),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(0), // Mark as pending sync
      ),
    );

    // Add to sync queue
    await _addToSyncQueue('contact', id, 'create', contact);

    return id;
  }

  // Update existing contact
  Future<bool> updateContact(Contact contact) async {
    final updated = await (update(contacts)
          ..where((c) => c.id.equals(contact.id)))
        .write(
      ContactsCompanion(
        firstName: Value(contact.firstName),
        lastName: Value(contact.lastName),
        phonePrimary: Value(contact.phonePrimary),
        phoneSecondary: Value(contact.phoneSecondary),
        email: Value(contact.email),
        company: Value(contact.company),
        designation: Value(contact.designation),
        address: Value(contact.address),
        dob: Value(contact.dob),
        leadScore: Value(contact.leadScore),
        stage: Value(contact.stage),
        dealValue: Value(contact.dealValue),
        source: Value(contact.source),
        tags: Value(contact.tags),
        customFields: Value(contact.customFields),
        notes: Value(contact.notes),
        extraField: Value(contact.extraField),
        remarks: Value(contact.remarks),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(2), // Mark as modified
        version: Value(contact.version + 1),
      ),
    );

    if (updated > 0) {
      await _addToSyncQueue('contact', contact.id, 'update', contact);
    }

    return updated > 0;
  }

  // Delete contact (soft delete)
  Future<bool> deleteContact(String id) async {
    final updated = await (update(contacts)
          ..where((c) => c.id.equals(id)))
        .write(
      ContactsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(2), // Mark as modified
      ),
    );

    if (updated > 0) {
      await _addToSyncQueue('contact', id, 'delete', null);
    }

    return updated > 0;
  }

  // Get contacts by lead score
  Future<List<Contact>> getContactsByLeadScore(int minScore) {
    return (select(contacts)
          ..where((c) => c.leadScore.isBiggerOrEqualValue(minScore))
          ..orderBy([
            (c) => OrderingTerm(expression: c.leadScore, mode: OrderingMode.desc),
          ]))
        .get();
  }

  // Get contacts by stage
  Future<List<Contact>> getContactsByStage(String stage) {
    return (select(contacts)..where((c) => c.stage.equals(stage))).get();
  }

  // Get contacts that need sync
  Future<List<Contact>> getContactsToSync() {
    return (select(contacts)
          ..where((c) => c.syncStatus.isNotValue(1))) // Not synced
        .get();
  }

  // Bulk insert contacts (for import)
  Future<void> bulkInsertContacts(List<ContactsCompanion> contactsList) async {
    await batch((batch) {
      for (final contact in contactsList) {
        final id = const Uuid().v4();
        final now = DateTime.now();

        batch.insert(
          contacts,
          contact.copyWith(
            id: Value(id),
            createdAt: Value(now),
            updatedAt: Value(now),
            syncStatus: const Value(0),
          ),
        );
      }
    });
  }

  // Update lead score
  Future<bool> updateLeadScore(String id, int score) async {
    final updated = await (update(contacts)
          ..where((c) => c.id.equals(id)))
        .write(
      ContactsCompanion(
        leadScore: Value(score),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(2),
      ),
    );

    return updated > 0;
  }

  // Helper method to add to sync queue
  Future<void> _addToSyncQueue(String entityType, String entityId, String action, dynamic data) async {
    // This will be implemented in sync_queue_dao
    // For now, we'll just print
    print('Adding to sync queue: $entityType - $action');
  }
}