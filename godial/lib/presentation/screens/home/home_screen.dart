import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../contacts/contacts_list_screen.dart';
import '../dialer/dialer_screen.dart';
import '../pipeline/pipeline_screen.dart';
import '../tasks/tasks_screen.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    final screens = [
      const ContactsListScreen(),
      const DialerScreen(),
      const PipelineScreen(),
      const TasksScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          boxShadow: AppTheme.bottomNavShadow,
        ),
        child: SafeArea(
          child: SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.people_rounded,
                  label: 'Contacts',
                  isActive: currentIndex == 0,
                  onTap: () => ref.read(currentIndexProvider.notifier).state = 0,
                ),
                _NavItem(
                  icon: Icons.phone_rounded,
                  label: 'Dialer',
                  isActive: currentIndex == 1,
                  onTap: () => ref.read(currentIndexProvider.notifier).state = 1,
                ),
                _NavItem(
                  icon: Icons.analytics_rounded,
                  label: 'Pipeline',
                  isActive: currentIndex == 2,
                  onTap: () => ref.read(currentIndexProvider.notifier).state = 2,
                ),
                _NavItem(
                  icon: Icons.task_alt_rounded,
                  label: 'Tasks',
                  isActive: currentIndex == 3,
                  onTap: () => ref.read(currentIndexProvider.notifier).state = 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space3,
          vertical: AppTheme.space2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isActive ? AppTheme.space4 : AppTheme.space2,
                vertical: AppTheme.space2,
              ),
              decoration: isActive
                  ? BoxDecoration(
                      color: AppTheme.frostBlue,
                      borderRadius: BorderRadius.circular(20),
                    )
                  : null,
              child: Icon(
                icon,
                color: isActive ? AppTheme.royalBlue : AppTheme.cloudGray,
                size: 24,
              ),
            ),
            const SizedBox(height: AppTheme.space1),
            Text(
              label,
              style: AppTheme.caption.copyWith(
                color: isActive ? AppTheme.royalBlue : AppTheme.stormGray,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}