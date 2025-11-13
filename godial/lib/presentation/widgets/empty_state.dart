import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.frostBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: AppTheme.skyBlue,
              ),
            ),
            const SizedBox(height: AppTheme.space6),
            Text(
              title,
              style: AppTheme.h2.copyWith(
                color: AppTheme.midnightGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.space2),
            Text(
              description,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.stormGray,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppTheme.space6),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.royalBlue,
                  foregroundColor: AppTheme.pureWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space6,
                    vertical: AppTheme.space3,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}