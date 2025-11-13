import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../widgets/empty_state.dart';

class DialerScreen extends ConsumerWidget {
  const DialerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.snowWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppTheme.space4),
              color: AppTheme.pureWhite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Auto Dialer',
                    style: AppTheme.h2.copyWith(
                      color: AppTheme.midnightGray,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings_rounded,
                      color: AppTheme.royalBlue,
                    ),
                    onPressed: () {
                      // TODO: Open dialer settings
                    },
                  ),
                ],
              ),
            ),

            // Content
            const Expanded(
              child: EmptyState(
                icon: Icons.phone_in_talk_rounded,
                title: 'Auto Dialer',
                description: 'Start making calls automatically to your contacts',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Start auto dialer
        },
        backgroundColor: AppTheme.royalBlue,
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text('Start Calling'),
      ),
    );
  }
}