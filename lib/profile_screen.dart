import 'package:flutter/material.dart';
import 'auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            _ProfileHeader(),
            const SizedBox(height: 30),
            _SectionTitle(title: 'Learning Statistics'),
            const SizedBox(height: 16),
            const _LearningStats(),
            const SizedBox(height: 30),
            _SectionTitle(title: 'Achievements'),
            const SizedBox(height: 16),
            const _Achievements(),
            const SizedBox(height: 30),
            _SectionTitle(title: 'Account Management'),
            const SizedBox(height: 16),
            const _AccountManagement(),
            const SizedBox(height: 30),
            // Logout Button
            TextButton.icon(
              onPressed: () async {
                await AuthService.logout();
                onLogout();
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- Reusable Widgets for Sections ---

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('https://placehold.co/100x100/E0E0E0/0A192F?text=A'),
          backgroundColor: Colors.grey,
        ),
        const SizedBox(height: 16),
        const Text(
          'Alex Doe',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Joined March 2023',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _LearningStats extends StatelessWidget {
  const _LearningStats();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatCard(value: '12', label: 'Paths Started'),
        _StatCard(value: '5', label: 'Paths Completed'),
        _StatCard(value: '152', label: 'Items Completed'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Achievements extends StatelessWidget {
  const _Achievements();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _AchievementBadge(icon: Icons.lightbulb_outline, label: 'First Path', isUnlocked: true),
        _AchievementBadge(icon: Icons.star_border, label: '5 Paths Done', isUnlocked: true),
        _AchievementBadge(icon: Icons.school_outlined, label: 'Path Master', isUnlocked: true),
        _AchievementBadge(icon: Icons.lock_outline, label: 'Locked', isUnlocked: false),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isUnlocked;

  const _AchievementBadge({required this.icon, required this.label, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    final color = isUnlocked ? Theme.of(context).colorScheme.secondary : Colors.grey.shade400;
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: isUnlocked ? Colors.black87 : Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _AccountManagement extends StatefulWidget {
  const _AccountManagement();

  @override
  State<_AccountManagement> createState() => _AccountManagementState();
}

class _AccountManagementState extends State<_AccountManagement> {
  bool _appearanceSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Appearance'),
            trailing: Switch(
              value: _appearanceSwitch,
              onChanged: (value) {
                setState(() {
                  _appearanceSwitch = value;
                });
              },
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
