import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'models/profile_stats_model.dart';
import 'subscription_screen.dart';
import 'models/subscription_status_model.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final ProfileStats? stats;
  final SubscriptionStatus? subscriptionStatus;

  const ProfileScreen({
    super.key,
    required this.onLogout,
    this.stats,
    this.subscriptionStatus,
  });

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

  Future<void> _showEditNameDialog(AppLocalizations l10n) async {
    final nameController = TextEditingController(text: _user?.displayName);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileScreen_editName),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.profileScreen_enterYourName,
            counterText: "", // Hide the default counter
          ),
          maxLength: 50, // Set the max length
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.profileScreen_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, nameController.text);
            },
            child: Text(l10n.profileScreen_save),
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

  Future<void> _showLogoutConfirmation(AppLocalizations l10n) async {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.profileScreen_logout),
          content: Text(l10n.profileScreen_logoutConfirm),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.profileScreen_cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                l10n.profileScreen_logout,
                style: TextStyle(color: Colors.red),
              ),
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

  void _showSubscriptionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to be taller
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const SubscriptionScreen(),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      await _apiService.deleteAccount();
      // After successful deletion, force a logout on the client.
      await AuthService.logout();
      if (mounted) {
        widget.onLogout();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst("Exception: ", "")),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog(AppLocalizations l10n) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.profileScreen_deleteAccount),
          content: Text(l10n.profileScreen_deleteAccountConfirm),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.profileScreen_cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                l10n.profileScreen_delete,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                onEdit: () => _showEditNameDialog(l10n),
              ),
              const SizedBox(height: 30),
              _SectionTitle(
                title: l10n.profileScreen_sectionLearningStatistics,
              ),
              const SizedBox(height: 16),
              _LearningStats(stats: widget.stats),
              const SizedBox(height: 30),
              _SectionTitle(title: l10n.profileScreen_sectionSubscription),
              const SizedBox(height: 16),
              _SubscriptionDetails(
                status: widget.subscriptionStatus,
                onUpgrade: _showSubscriptionSheet,
              ),
              const SizedBox(height: 30),
              _SectionTitle(title: l10n.profileScreen_sectionMonthlyUsage),
              const SizedBox(height: 16),
              _MonthlyUsage(stats: widget.subscriptionStatus),
              const SizedBox(height: 30),
              _SectionTitle(title: l10n.profileScreen_sectionAccountManagement),
              const SizedBox(height: 16),
              const _LanguageSwitcher(),
              const SizedBox(height: 30),
              const _AccountManagement(),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _showLogoutConfirmation(l10n),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(
                  l10n.profileScreen_logout,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showDeleteConfirmationDialog(l10n),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(l10n.profileScreen_deleteAccount),
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
    // First, get the l10n object from the context
    final l10n = AppLocalizations.of(context)!;

    // Format the date into a string
    final formattedDate = DateFormat.yMMMM(l10n.localeName).format(joinedDate!);
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
            // --- Wrap the Text widget with Flexible ---
            Flexible(
              child: Text(
                user?.displayName ?? 'User',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                // --- Add these properties for graceful handling of long text ---
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
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
            l10n.profileScreen_joined(formattedDate),
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
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatCard(
          value: stats?.pathsStarted.toString() ?? '0',
          label: l10n.profileScreen_statPathsStarted,
        ),
        _StatCard(
          value: stats?.pathsCompleted.toString() ?? '0',
          label: l10n.profileScreen_statPathsCompleted,
        ),
        _StatCard(
          value: stats?.itemsCompleted.toString() ?? '0',
          label: l10n.profileScreen_statResourcesCompleted,
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

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher();

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    // Create a map of language codes to display names
    final Map<String, String> languages = {
      'en': 'English',
      'pt': 'Português',
      'es': 'Español',
      'fr': 'Français',
    };

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.profileScreen_manageLanguage,
              style: const TextStyle(fontSize: 16),
            ),
            DropdownButton<Locale>(
              value: localeProvider.locale ?? Localizations.localeOf(context),
              underline: const SizedBox.shrink(),
              items: AppLocalizations.supportedLocales.map((Locale locale) {
                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(
                    languages[locale.languageCode] ?? locale.languageCode,
                  ),
                );
              }).toList(),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  localeProvider.setLocale(newLocale);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountManagementState extends State<_AccountManagement> {
  bool _appearanceSwitch = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l10n.profileScreen_manageEditProfile),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.profileScreen_manageNotifications),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l10n.profileScreen_manageAppearance),
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

class _MonthlyUsage extends StatelessWidget {
  final SubscriptionStatus? stats;
  const _MonthlyUsage({this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats == null) {
      // Don't show anything if stats aren't loaded
      return const SizedBox.shrink();
    }

    final generationsUsed = stats!.pathsGeneratedThisMonth;
    final generationLimit = stats!.pathGenerationLimit;
    final extensionsUsed = stats!.pathsExtendedThisMonth;
    final extensionLimit = stats!.pathExtensionLimit;

    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: Text(l10n.profileScreen_usagePathsGenerated),
            trailing: Text(
              generationLimit == null
                  ? l10n.profileScreen_usageUnlimited
                  : '$generationsUsed / $generationLimit',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.add_road),
            title: Text(l10n.profileScreen_usagePathsExtended),
            trailing: Text(
              extensionLimit == null
                  ? l10n.profileScreen_usageUnlimited
                  : '$extensionsUsed / $extensionLimit',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionDetails extends StatelessWidget {
  final SubscriptionStatus? status;
  final VoidCallback onUpgrade;
  const _SubscriptionDetails({this.status, required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tier = status?.tier ?? 'Free';

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profileScreen_currentPlan,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  tier,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: onUpgrade,
              child: Text(l10n.profileScreen_upgrade),
            ),
          ],
        ),
      ),
    );
  }
}
