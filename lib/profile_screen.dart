import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'auth_service.dart';
import 'api_service.dart';
import 'profile_stats_model.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  final User? _user = AuthService.currentUser;
  late Future<ProfileStats?> _profileStatsFuture;

  @override
  void initState() {
    super.initState();
    _profileStatsFuture = _apiService.fetchProfileStats();
  }

  // --- NEW: Method to show the logout confirmation dialog ---
  Future<void> _showLogoutConfirmation() async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close the dialog
                await AuthService.logout();
                if (mounted) {
                  widget.onLogout();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<ProfileStats?>(
        future: _profileStatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading profile: ${snapshot.error}'));
          }
          
          final profileStats = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                _ProfileHeader(user: _user, joinedDate: profileStats?.joinedDate),
                const SizedBox(height: 30),
                _SectionTitle(title: 'Learning Statistics'),
                const SizedBox(height: 16),
                _LearningStats(stats: profileStats),
                const SizedBox(height: 30),
                _SectionTitle(title: 'Achievements'),
                const SizedBox(height: 16),
                const _Achievements(),
                const SizedBox(height: 30),
                _SectionTitle(title: 'Account Management'),
                const SizedBox(height: 16),
                const _AccountManagement(),
                const SizedBox(height: 30),
                TextButton.icon(
                  // Call the confirmation method instead of logging out directly
                  onPressed: _showLogoutConfirmation,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text('Logout', style: TextStyle(color: Colors.red)),
                )
              ],
            ),
          );
        },
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
  final User? user;
  final DateTime? joinedDate;

  const _ProfileHeader({this.user, this.joinedDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
          child: user?.photoURL == null ? const Icon(Icons.person, size: 50) : null,
        ),
        const SizedBox(height: 16),
        Text(
          user?.displayName ?? 'User',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        if (joinedDate != null)
          Text(
            'Joined ${DateFormat.yMMMM().format(joinedDate!)}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
      ],
    );
  }
}

class _LearningStats extends StatelessWidget {
  final ProfileStats? stats;
  const _LearningStats({this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatCard(value: stats?.pathsStarted.toString() ?? '0', label: 'Paths Started'),
        _StatCard(value: stats?.pathsCompleted.toString() ?? '0', label: 'Paths Completed'),
        _StatCard(value: stats?.itemsCompleted.toString() ?? '0', label: 'Resources Completed'),
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
