import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/notification_settings_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Use Consumer to rebuild the switch when the value changes
    return Consumer<NotificationSettingsProvider>(
      builder: (context, settingsProvider, child) {
        if (settingsProvider.state == ProviderState.Loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(l10n.profileScreen_manageNotifications)),
          body: ListView(
            children: [
              SwitchListTile(
                title: Text(l10n.notificationsScreen_learningReminders),
                subtitle: Text(l10n.notificationsScreen_learningRemindersDesc),
                value: settingsProvider.learningRemindersEnabled,
                onChanged: (bool value) {
                  settingsProvider.setLearningReminders(value);
                },
                secondary: const Icon(Icons.school_outlined),
              ),
              SwitchListTile(
                title: Text(l10n.notificationsScreen_generalAnnouncements),
                subtitle: Text(
                  l10n.notificationsScreen_generalAnnouncementsSubtitle,
                ),
                value: settingsProvider.announcementsEnabled,
                onChanged: (bool value) {
                  settingsProvider.setAnnouncements(value);
                },
                secondary: const Icon(Icons.announcement_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
