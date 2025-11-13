import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../widgets/empty_state.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

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
                    'Tasks',
                    style: AppTheme.h2.copyWith(
                      color: AppTheme.midnightGray,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.filter_list_rounded,
                      color: AppTheme.royalBlue,
                    ),
                    onPressed: () {
                      // TODO: Filter tasks
                    },
                  ),
                ],
              ),
            ),

            // Content
            const Expanded(
              child: EmptyState(
                icon: Icons.task_alt_rounded,
                title: 'No Tasks',
                description: 'Create tasks to track your activities',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new task
        },
        backgroundColor: AppTheme.royalBlue,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}