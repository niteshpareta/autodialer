import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_theme.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.space4),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.space3),
          padding: const EdgeInsets.all(AppTheme.space3),
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppTheme.royalBlue.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: AppTheme.silverWhite,
            highlightColor: AppTheme.pureWhite,
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppTheme.silverWhite,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppTheme.space3),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.silverWhite,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                      ),
                      const SizedBox(height: AppTheme.space2),
                      Container(
                        width: 140,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppTheme.silverWhite,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                      ),
                      const SizedBox(height: AppTheme.space1),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppTheme.silverWhite,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                      ),
                    ],
                  ),
                ),
                // Action buttons
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppTheme.silverWhite,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppTheme.space2),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppTheme.silverWhite,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}