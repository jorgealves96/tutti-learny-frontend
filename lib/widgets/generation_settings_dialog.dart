import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user_settings_model.dart';
import '../models/subscription_status_model.dart';

class GenerationSettingsDialog extends StatefulWidget {
  final UserSettings currentSettings;
  final SubscriptionStatus? subscriptionStatus;

  const GenerationSettingsDialog({
    super.key,
    required this.currentSettings,
    required this.subscriptionStatus,
  });

  @override
  State<GenerationSettingsDialog> createState() =>
      _GenerationSettingsDialogState();
}

class _GenerationSettingsDialogState extends State<GenerationSettingsDialog> {
  late LearningLevel _selectedLevel;
  late PathLength _selectedLength;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.currentSettings.learningLevel;
    _selectedLength = widget.currentSettings.pathLength;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Determine if the user is on the Free tier
    final bool isFreeTier = widget.subscriptionStatus?.tier == 'Free';

    final Map<LearningLevel, String> levelOptions = {
      LearningLevel.beginner: 
          l10n.generationSettingsDialog_levelBeginner,
      LearningLevel.intermediate:
          l10n.generationSettingsDialog_levelIntermediate,
      LearningLevel.advanced: 
          l10n.generationSettingsDialog_levelAdvanced,
    };

    final Map<LearningLevel, String> levelSubtitles = {
      LearningLevel.beginner:
          l10n.generationSettingsDialog_levelBeginner_subtitle,
      LearningLevel.intermediate:
          l10n.generationSettingsDialog_levelIntermediate_subtitle,
      LearningLevel.advanced:
          l10n.generationSettingsDialog_levelAdvanced_subtitle,
    };

    final Map<PathLength, String> lengthOptions = {
      PathLength.quick: 
          l10n.generationSettingsDialog_lengthQuick,
      PathLength.standard: 
          l10n.generationSettingsDialog_lengthStandard,
      PathLength.inDepth: 
          l10n.generationSettingsDialog_lengthInDepth,
    };

    final Map<PathLength, String> lengthSubtitles = {
      PathLength.quick: 
          l10n.generationSettingsDialog_lengthQuick_subtitle,
      PathLength.standard: 
          l10n.generationSettingsDialog_lengthStandard_subtitle,
      PathLength.inDepth: 
          l10n.generationSettingsDialog_lengthInDepth_subtitle,
    };

    return AlertDialog(
      title: Text(l10n.generationSettingsDialog_title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Learning Level Section ---
            Text(
              l10n.generationSettingsDialog_learningLevel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<LearningLevel>(
              value: _selectedLevel,
              borderRadius: BorderRadius.circular(12.0),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              selectedItemBuilder: (context) {
                return levelOptions.values.map((String value) {
                  return Text(value);
                }).toList();
              },
              items: levelOptions.entries.map((entry) {
                return DropdownMenuItem<LearningLevel>(
                  value: entry.key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(entry.value, style: const TextStyle(fontSize: 16.0)),
                      Text(
                        levelSubtitles[entry.key]!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (LearningLevel? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLevel = newValue;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            // --- Path Length Section ---
            Text(
              l10n.generationSettingsDialog_pathLength,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PathLength>(
              value: _selectedLength,
              borderRadius: BorderRadius.circular(12.0),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              selectedItemBuilder: (context) {
                return lengthOptions.entries.map((entry) {
                  final isProFeature = entry.key == PathLength.inDepth;
                  // Add a lock icon to the selected item if it's a locked feature
                  if (isProFeature && isFreeTier) {
                    return Row(
                      children: [
                        Text(
                          entry.value,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.lock, size: 16, color: Colors.grey.shade500),
                      ],
                    );
                  }
                  return Text(entry.value);
                }).toList();
              },
              items: lengthOptions.entries.map((entry) {
                final isProFeature = entry.key == PathLength.inDepth;

                // --- THIS IS THE FIX ---
                if (isProFeature && isFreeTier) {
                  // Return a disabled item with a lock icon
                  return DropdownMenuItem<PathLength>(
                    value: entry.key,
                    enabled: false, // This makes it unselectable
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              entry.value,
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                            Text(l10n.generationSettingsDialog_unavailableInFreeTier, // Using the recommended text
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.lock_outline,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                      ],
                    ),
                  );
                }

                // Otherwise, return the normal, enabled item
                return DropdownMenuItem<PathLength>(
                  value: entry.key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(entry.value, style: const TextStyle(fontSize: 16.0)),
                      Text(
                        lengthSubtitles[entry.key]!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (PathLength? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLength = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.generationSettingsDialog_cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(
              UserSettings(
                learningLevel: _selectedLevel,
                pathLength: _selectedLength,
              ),
            );
          },
          child: Text(l10n.generationSettingsDialog_save),
        ),
      ],
    );
  }
}