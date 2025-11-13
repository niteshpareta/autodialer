import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../widgets/empty_state.dart';

class PipelineScreen extends ConsumerWidget {
  const PipelineScreen({super.key});

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
                    'Sales Pipeline',
                    style: AppTheme.h2.copyWith(
                      color: AppTheme.midnightGray,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_rounded,
                      color: AppTheme.royalBlue,
                    ),
                    onPressed: () {
                      // TODO: Add new stage
                    },
                  ),
                ],
              ),
            ),

            // Content
            const Expanded(
              child: EmptyState(
                icon: Icons.analytics_rounded,
                title: 'Sales Pipeline',
                description: 'Track your deals through different stages',
              ),
            ),
          ],
        ),
      ),
    );
  }
}