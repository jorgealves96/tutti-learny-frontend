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
import '../providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'notifications_screen.dart';
import 'utils/snackbar_helper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback onRefresh;
  final ProfileStats? stats;
  final SubscriptionStatus? subscriptionStatus;

  const ProfileScreen({
    super.key,
    required this.onLogout,
    required this.onRefresh,
    this.stats,
    this.subscriptionStatus,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  late User? _user;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _user = AuthService.currentUser;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          _user = AuthService.firebaseAuth.currentUser;
        });

        widget.onRefresh();

        if (mounted) {
          showSuccessSnackBar(context, l10n.profileScreen_nameUpdateSuccess);
        }
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

  void _showSubscriptionSheet(
    SubscriptionStatus? status,
    VoidCallback onRefresh,
  ) async {
    final needsRefresh = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Pass the status down to the SubscriptionScreen
      builder: (context) => SubscriptionScreen(currentStatus: status),
    );

    if (needsRefresh == true) {
      onRefresh();
    }
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
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Prevents the column from expanding
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.profileScreen_deleteAccountConfirm),
              const SizedBox(height: 16),
              Text(
                l10n.profileScreen_deleteAccountDisclaimer, // Your new disclaimer text
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.profileScreen_cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                l10n.profileScreen_delete,
                style: const TextStyle(color: Colors.red),
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

  void _manageSubscription() async {
    final url = Platform.isIOS
        ? 'https://apps.apple.com/account/subscriptions'
        : 'https://play.google.com/store/account/subscriptions';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
          controller: _scrollController,
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
                onUpgrade: () => _showSubscriptionSheet(
                  widget.subscriptionStatus,
                  widget.onRefresh,
                ),
                onManage: _manageSubscription,
              ),
              const SizedBox(height: 30),
              _SectionTitle(title: l10n.profileScreen_sectionMonthlyUsage),
              const SizedBox(height: 16),
              _MonthlyUsage(stats: widget.subscriptionStatus),
              const SizedBox(height: 30),
              _SectionTitle(title: l10n.profileScreen_sectionAccountManagement),
              const SizedBox(height: 16),
              const _AccountManagement(),
              const SizedBox(height: 30),
              _SectionTitle(title: l10n.profileScreen_support),
              const SizedBox(height: 16),
              const _SupportSection(),
              const SizedBox(height: 30),

              // Legal Section
              _SectionTitle(title: l10n.profileScreen_legal),
              const SizedBox(height: 16),
              const _LegalSection(),
              const SizedBox(height: 24),
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
    if (user == null || joinedDate == null) {
      return const _ProfileHeaderSkeleton(); // NEW
    }

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
              ? const Icon(Icons.person_outline, size: 50)
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
    if (stats == null) {
      return const _LearningStatsSkeleton(); // NEW
    }

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
        _StatCard(
          value: stats?.quizzesCompleted.toString() ?? '0',
          label: l10n.profileScreen_statQuizzesCompleted,
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
        shadowColor: Colors.black.withValues(alpha: 0.1),
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
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    // Create a map of language codes to display names
    final Map<String, String> languages = {
      'en': 'English',
      'pt': 'Português',
      'es': 'Español',
      'fr': 'Français',
    };

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // --- Language Switcher is now the first item ---
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(l10n.profileScreen_manageLanguage),
            trailing: DropdownButton<Locale>(
              value: localeProvider.locale ?? Localizations.localeOf(context),
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(24.0),
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
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.profileScreen_manageNotifications),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              FocusScope.of(context).unfocus();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l10n.profileScreen_manageAppearance),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
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
      // This can share the same skeleton as the subscription details.
      return const _SubscriptionSkeleton(); // NEW
    }

    final generationsUsed = stats!.pathsGeneratedThisMonth;
    final generationLimit = stats!.pathGenerationLimit;
    final extensionsUsed = stats!.pathsExtendedThisMonth;
    final extensionLimit = stats!.pathExtensionLimit;
    final quizzesUsed = stats!.quizzesCreatedThisMonth;
    final quizLimit = stats!.quizCreationLimit;

    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
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
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.quiz_outlined),
            title: Text(l10n.profileScreen_usageQuizzesCreated),
            trailing: Text(
              quizLimit == null
                  ? l10n.profileScreen_usageUnlimited
                  : '$quizzesUsed / $quizLimit',
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
  final VoidCallback onManage;

  const _SubscriptionDetails({
    this.status,
    required this.onUpgrade,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return const _SubscriptionSkeleton(); // NEW
    }

    final l10n = AppLocalizations.of(context)!;

    String? daysLeftText;
    if (status?.daysLeftInSubscription != null &&
        status!.daysLeftInSubscription! >= 0) {
      final formattedDate = DateFormat.yMMMMd(
        l10n.localeName,
      ).format(status!.subscriptionExpiryDate!);
      daysLeftText = l10n.profileScreen_daysLeft(
        formattedDate,
        status!.daysLeftInSubscription!,
      );
    }

    final rawTier = status?.tier;

    final String displayTier;
    switch (rawTier) {
      case 'Pro':
        displayTier = l10n.subscriptionScreen_tierPro_title;
        break;
      case 'Unlimited':
        displayTier = l10n.subscriptionScreen_tierUnlimited_title;
        break;
      default:
        displayTier = l10n.profileScreen_tierFree;
    }

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.profileScreen_currentPlan,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayTier,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (daysLeftText != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      daysLeftText,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (rawTier == 'Free' || rawTier == null)
              OutlinedButton(
                onPressed: onUpgrade,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Text(l10n.profileScreen_upgrade),
              )
            else if (rawTier == 'Pro')
              Row(
                children: [
                  TextButton(
                    onPressed: onManage,
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Text(l10n.profileScreen_manageSubscription),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onUpgrade,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: Text(l10n.profileScreen_upgrade),
                  ),
                ],
              )
            else // Unlimited Tier
              OutlinedButton(
                onPressed: onManage,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Text(l10n.profileScreen_manageSubscription),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderSkeleton extends StatelessWidget {
  const _ProfileHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          const CircleAvatar(radius: 50, backgroundColor: Colors.white),
          const SizedBox(height: 16),
          Container(
            height: 28,
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 16,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningStatsSkeleton extends StatelessWidget {
  const _LearningStatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          4,
          (_) => const Expanded(child: _SkeletonStatCard()),
        ),
      ),
    );
  }
}

class _SkeletonStatCard extends StatelessWidget {
  const _SkeletonStatCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Container(height: 28, width: 30, color: Colors.white),
            const SizedBox(height: 4),
            Container(height: 12, width: 50, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionSkeleton extends StatelessWidget {
  const _SubscriptionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 80, // Approximate height of the Card
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _SupportSection extends StatelessWidget {
  const _SupportSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const String email = 'tuttilearni@gmail.com';
    const String twitterHandle = 'tuttilearni';

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(l10n.profileScreen_contactViaEmail),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl('mailto:$email'),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.xTwitter),
            title: Text(l10n.profileScreen_followOnX),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl('https://x.com/$twitterHandle'),
          ),
        ],
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  const _LegalSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const String termsUrl = 'https://tuttilearni.com/terms.html';
    const String privacyUrl = 'https://tuttilearni.com/privacy.html';

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.profileScreen_termsOfUse),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl(termsUrl),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: Text(l10n.profileScreen_privacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _launchUrl(privacyUrl),
          ),
        ],
      ),
    );
  }
}

/// Helper function to launch a URL.
Future<void> _launchUrl(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url)) {
    debugPrint('Could not launch $urlString');
  }
}