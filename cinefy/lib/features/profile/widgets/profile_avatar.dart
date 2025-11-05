import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final bool isEditable;
  final VoidCallback? onTap;
  
  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.radius = 60,
    this.isEditable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: isEditable ? onTap : null,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: cs.primaryContainer,
              backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                  ? NetworkImage(imageUrl!)
                  : null,
              onBackgroundImageError: imageUrl != null ? (_, __) {} : null,
              child: imageUrl == null || imageUrl!.isEmpty
                  ? _buildFallbackAvatar(context)
                  : null,
            ),
          ),
          if (isEditable)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: cs.surface,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: cs.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildFallbackAvatar(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    if (name != null && name!.isNotEmpty) {
      // Show initials if name is available
      final initials = _getInitials(name!);
      return Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.4,
          fontWeight: FontWeight.bold,
          color: cs.onPrimaryContainer,
        ),
      );
    }
    
    // Show person icon as fallback
    return Icon(
      Icons.person,
      size: radius * 0.8,
      color: cs.onPrimaryContainer,
    );
  }
  
  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '';
    
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }
    
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'.toUpperCase();
  }
}

class ProfileAvatarPlaceholder extends StatelessWidget {
  final double radius;
  
  const ProfileAvatarPlaceholder({
    super.key,
    this.radius = 60,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: cs.surfaceContainerHighest,
        child: SizedBox(
          width: radius * 0.8,
          height: radius * 0.8,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: cs.primary,
          ),
        ),
      ),
    );
  }
}