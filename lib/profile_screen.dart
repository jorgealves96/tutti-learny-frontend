import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'auth_service.dart';
import 'api_service.dart';
import 'profile_stats_model.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final ProfileStats? stats;

  const ProfileScreen({super.key, required this.onLogout, this.stats});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = AuthService.currentUser;
  }

  Future<void> _showEditNameDialog() async {
    final nameController = TextEditingController(text: _user?.displayName);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
            counterText: "", // Hide the default counter
          ),
          maxLength: 50, // Set the max length
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, nameController.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && mounted) {
      try {
        await _apiService.updateUserName(newName);
        await _user?.updateDisplayName(newName);
        setState(() {
          _user = AuthService.currentUser;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update name: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showLogoutConfirmation() async {
    if (!mounted) return;
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
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
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
      // Wrap the body with a SafeArea widget
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              _ProfileHeader(
                user: _user,
                joinedDate: widget.stats?.joinedDate,
                onEdit: _showEditNameDialog,
              ),
              const SizedBox(height: 30),
              _SectionTitle(title: 'Learning Statistics'),
              const SizedBox(height: 16),
              _LearningStats(stats: widget.stats),
              const SizedBox(height: 30),
              _SectionTitle(title: 'Account Management'),
              const SizedBox(height: 16),
              const _AccountManagement(),
              const SizedBox(height: 30),
              TextButton.icon(
                onPressed: _showLogoutConfirmation,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
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
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User? user;
  final DateTime? joinedDate;
  final VoidCallback onEdit;

  const _ProfileHeader({this.user, this.joinedDate, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null,
          child: user?.photoURL == null
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              user?.displayName ?? 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                size: 22,
                color: Colors.grey,
              ),
              onPressed: onEdit,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
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
        _StatCard(
          value: stats?.pathsStarted.toString() ?? '0',
          label: 'Paths Started',
        ),
        _StatCard(
          value: stats?.pathsCompleted.toString() ?? '0',
          label: 'Paths Completed',
        ),
        _StatCard(
          value: stats?.itemsCompleted.toString() ?? '0',
          label: 'Resources Completed',
        ),
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
