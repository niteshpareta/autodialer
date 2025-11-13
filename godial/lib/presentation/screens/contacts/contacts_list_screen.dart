import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/database/app_database.dart';
import '../../providers/contacts_provider.dart';
import '../../widgets/contact_list_tile.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shimmer_loading.dart';

class ContactsListScreen extends ConsumerStatefulWidget {
  const ContactsListScreen({super.key});

  @override
  ConsumerState<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends ConsumerState<ContactsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.all(AppTheme.space4),
              color: AppTheme.pureWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contacts',
                            style: AppTheme.h2.copyWith(
                              color: AppTheme.midnightGray,
                            ),
                          ),
                          const SizedBox(height: AppTheme.space1),
                          contactsAsync.when(
                            data: (contacts) => Text(
                              '${contacts.length} contacts',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.stormGray,
                              ),
                            ),
                            loading: () => Text(
                              'Loading...',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.stormGray,
                              ),
                            ),
                            error: (_, __) => Text(
                              'Error loading contacts',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.errorRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Import Button
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.frostBlue,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.upload_file_rounded,
                                color: AppTheme.royalBlue,
                              ),
                              onPressed: _handleImport,
                              tooltip: 'Import Contacts',
                            ),
                          ),
                          const SizedBox(width: AppTheme.space2),
                          // Filter Button
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.frostBlue,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.filter_list_rounded,
                                color: AppTheme.royalBlue,
                              ),
                              onPressed: _showFilterDialog,
                              tooltip: 'Filter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.space4),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.pearlWhite,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      border: Border.all(
                        color: AppTheme.silverWhite,
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search contacts...',
                        hintStyle: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.cloudGray,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppTheme.stormGray,
                        ),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  color: AppTheme.stormGray,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  ref.read(searchQueryProvider.notifier).state = '';
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.space4,
                          vertical: AppTheme.space3,
                        ),
                      ),
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.charcoalGray,
                      ),
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).state = value;
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Contact List
            Expanded(
              child: contactsAsync.when(
                data: (contacts) {
                  if (contacts.isEmpty) {
                    return EmptyState(
                      icon: Icons.people_outline_rounded,
                      title: 'No Contacts Yet',
                      description: 'Add your first contact or import from Excel',
                      actionLabel: 'Add Contact',
                      onAction: () => context.go('/contacts/add'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(contactsProvider);
                    },
                    color: AppTheme.royalBlue,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.space2,
                      ),
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return ContactListTile(
                          contact: contact,
                          onTap: () => context.go('/contacts/${contact.id}'),
                          onCall: () => _makeCall(contact.phonePrimary),
                          onMessage: () => _sendMessage(contact.phonePrimary),
                        );
                      },
                    ),
                  );
                },
                loading: () => const ShimmerLoading(),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 64,
                        color: AppTheme.errorRed,
                      ),
                      const SizedBox(height: AppTheme.space4),
                      Text(
                        'Error loading contacts',
                        style: AppTheme.h3.copyWith(
                          color: AppTheme.midnightGray,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space2),
                      Text(
                        error.toString(),
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.stormGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.space6),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(contactsProvider);
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/contacts/add'),
        backgroundColor: AppTheme.royalBlue,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Contact'),
      ),
    );
  }

  void _handleImport() {
    HapticFeedback.lightImpact();
    // TODO: Implement Excel import
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Import feature coming soon'),
        backgroundColor: AppTheme.royalBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    HapticFeedback.lightImpact();
    // TODO: Implement filter dialog
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXLarge),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppTheme.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.silverWhite,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.space4),
              Text(
                'Filter Contacts',
                style: AppTheme.h3.copyWith(
                  color: AppTheme.midnightGray,
                ),
              ),
              const SizedBox(height: AppTheme.space4),
              Text(
                'Filter options coming soon',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.stormGray,
                ),
              ),
              const SizedBox(height: AppTheme.space8),
            ],
          ),
        );
      },
    );
  }

  void _makeCall(String phoneNumber) {
    HapticFeedback.mediumImpact();
    // TODO: Implement calling
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $phoneNumber'),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }

  void _sendMessage(String phoneNumber) {
    HapticFeedback.lightImpact();
    // TODO: Implement messaging
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message to $phoneNumber'),
        backgroundColor: AppTheme.skyBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }
}