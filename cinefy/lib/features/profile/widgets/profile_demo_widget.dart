import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'profile_avatar.dart';
import 'profile_info_card.dart';

/// Demo widget to showcase profile components
/// This can be used for testing and development
class ProfileDemoWidget extends StatelessWidget {
  const ProfileDemoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample user profile data
    final sampleProfile = UserProfile(
      id: 'demo_user_123',
      email: 'demo.user@cinefy.com',
      name: 'Demo User',
      phone: '+91 98765 43210',
      profileImageUrl: 'https://i.pravatar.cc/300',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar Demo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Profile Avatar Components',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Regular avatar
                    const ProfileAvatar(
                      imageUrl: 'https://i.pravatar.cc/300',
                      name: 'Demo User',
                      radius: 50,
                    ),
                    const SizedBox(height: 16),
                    const Text('Regular Avatar'),
                    
                    const SizedBox(height: 24),
                    
                    // Editable avatar
                    ProfileAvatar(
                      imageUrl: 'https://i.pravatar.cc/300',
                      name: 'Demo User',
                      radius: 50,
                      isEditable: true,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Avatar edit tapped!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Editable Avatar'),
                    
                    const SizedBox(height: 24),
                    
                    // Avatar with initials fallback
                    const ProfileAvatar(
                      name: 'John Doe',
                      radius: 50,
                    ),
                    const SizedBox(height: 16),
                    const Text('Avatar with Initials'),
                    
                    const SizedBox(height: 24),
                    
                    // Loading placeholder
                    const ProfileAvatarPlaceholder(radius: 50),
                    const SizedBox(height: 16),
                    const Text('Loading Placeholder'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Profile Info Card Demo
            ProfileInfoCard(
              profile: sampleProfile,
              onEdit: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit profile tapped!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons Demo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Action Buttons',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit Profile clicked!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    OutlinedButton.icon(
                      onPressed: () {
                        _showDemoDialog(context, 'Settings');
                      },
                      icon: const Icon(Icons.settings_outlined),
                      label: const Text('Settings'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    OutlinedButton.icon(
                      onPressed: () {
                        _showDemoDialog(context, 'Logout');
                      },
                      icon: const Icon(Icons.logout_outlined),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(color: Theme.of(context).colorScheme.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Usage Instructions
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Components Usage',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• ProfileAvatar: Displays user profile picture with fallbacks\n'
                      '• ProfileInfoCard: Shows user information in a styled card\n'
                      '• ProfileAvatarPlaceholder: Loading state for avatar\n'
                      '• All components follow Material Design principles\n'
                      '• Ready for API integration when backend is available',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDemoDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(action),
        content: Text('$action functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}