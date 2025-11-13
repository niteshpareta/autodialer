import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class ContactDetailScreen extends ConsumerWidget {
  final String contactId;

  const ContactDetailScreen({
    super.key,
    required this.contactId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.pureWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Contact Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Contact Details - Coming Soon'),
      ),
    );
  }
}