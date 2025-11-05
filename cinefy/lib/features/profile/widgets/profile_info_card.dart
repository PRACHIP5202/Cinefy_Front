import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileInfoCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onEdit;
  
  const ProfileInfoCard({
    super.key,
    required this.profile,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    iconSize: 20,
                    style: IconButton.styleFrom(
                      foregroundColor: cs.primary,
                      backgroundColor: cs.primaryContainer.withValues(alpha: 0.3),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            ProfileInfoRow(
              icon: Icons.person_outline,
              label: 'Full Name',
              value: profile.name ?? 'Not provided',
            ),
            const SizedBox(height: 12),
            
            ProfileInfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: profile.email,
            ),
            const SizedBox(height: 12),
            
            ProfileInfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: profile.phone ?? 'Not provided',
            ),
            const SizedBox(height: 12),
            
                        
            if (profile.createdAt != null) ...[
              const SizedBox(height: 12),
              ProfileInfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'Member Since',
                value: _formatDate(profile.createdAt!),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEditable;
  final VoidCallback? onTap;
  
  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isEditable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: isEditable ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (isEditable)
              Icon(
                Icons.chevron_right,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}