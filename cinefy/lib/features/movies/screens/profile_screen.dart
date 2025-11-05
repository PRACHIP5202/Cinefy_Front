import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    // Responsive scaling
    final avatarSize = width > 600 ? 120.0 : 90.0;
    final fontSize = width > 600 ? 22.0 : 18.0;
    final padding = width > 600 ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🧑‍🎤 Avatar
              CircleAvatar(
                radius: avatarSize / 2,
                backgroundImage: const NetworkImage(
                  "https://i.pravatar.cc/300?img=12", // Dummy profile pic
                ),
              ),
              const SizedBox(height: 20),

              // 🎬 User Info
              Text(
                "Prachi Patel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "cinefy_user@example.com",
                style: TextStyle(
                  color: cs.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 30),

              // 🎟 Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStat("Favorites", "12", cs),
                  Container(
                    width: 1,
                    height: 20,
                    color: cs.outlineVariant,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  _buildStat("Watched", "34", cs),
                ],
              ),

              const SizedBox(height: 40),

              // ⚙️ Dummy Buttons
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: cs.primary,
                  side: BorderSide(color: cs.primary),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, ColorScheme cs) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: cs.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
