import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const ContactListTile({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = _getDisplayName();
    final initials = _getInitials(displayName);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space2,
      ),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.space3),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.skyBlue.withOpacity(0.8),
                        AppTheme.royalBlue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.pureWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.space3),

                // Contact Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayName,
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.midnightGray,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (contact.leadScore > 70) ...[
                            const SizedBox(width: AppTheme.space2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.space2,
                                vertical: AppTheme.space1,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                              ),
                              child: Text(
                                'Hot',
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.successGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppTheme.space1),
                      Text(
                        contact.phonePrimary,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.stormGray,
                        ),
                      ),
                      if (contact.company != null && contact.company!.isNotEmpty) ...[
                        const SizedBox(height: AppTheme.space1),
                        Row(
                          children: [
                            Icon(
                              Icons.business_rounded,
                              size: 14,
                              color: AppTheme.cloudGray,
                            ),
                            const SizedBox(width: AppTheme.space1),
                            Expanded(
                              child: Text(
                                contact.company!,
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.stormGray,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.space2),

                // Action Buttons
                Row(
                  children: [
                    // Call Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.frostBlue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          onCall();
                        },
                        icon: const Icon(
                          Icons.phone_rounded,
                          color: AppTheme.royalBlue,
                          size: 20,
                        ),
                        tooltip: 'Call',
                      ),
                    ),
                    const SizedBox(width: AppTheme.space2),
                    // Message Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cloudBlue.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onMessage();
                        },
                        icon: const Icon(
                          Icons.message_rounded,
                          color: AppTheme.skyBlue,
                          size: 20,
                        ),
                        tooltip: 'Message',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDisplayName() {
    if (contact.firstName != null || contact.lastName != null) {
      final parts = [
        if (contact.firstName != null) contact.firstName!,
        if (contact.lastName != null) contact.lastName!,
      ];
      return parts.join(' ');
    }
    return contact.phonePrimary;
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';

    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return name[0].toUpperCase();

    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length.clamp(0, 2)).toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}