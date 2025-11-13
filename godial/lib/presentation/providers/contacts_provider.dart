import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../main.dart';

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Contacts provider
final contactsProvider = StreamProvider<List<Contact>>((ref) {
  final database = ref.watch(databaseProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  if (searchQuery.isEmpty) {
    return database.contactsDao.watchAllContacts();
  } else {
    // For search, we'll use a future and convert to stream
    return Stream.fromFuture(
      database.contactsDao.searchContacts(searchQuery),
    );
  }
});

// Selected contacts provider (for bulk operations)
final selectedContactsProvider = StateProvider<List<String>>((ref) => []);

// Contact detail provider
final contactDetailProvider = FutureProvider.family<Contact?, String>((ref, id) {
  final database = ref.watch(databaseProvider);
  return database.contactsDao.getContact(id);
});

// Contact stats provider
final contactStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final database = ref.watch(databaseProvider);
  final contacts = await database.contactsDao.getAllContacts();

  return {
    'total': contacts.length,
    'withEmail': contacts.where((c) => c.email != null && c.email!.isNotEmpty).length,
    'withCompany': contacts.where((c) => c.company != null && c.company!.isNotEmpty).length,
    'averageLeadScore': contacts.isEmpty
        ? 0
        : contacts.map((c) => c.leadScore).reduce((a, b) => a + b) / contacts.length,
  };
});