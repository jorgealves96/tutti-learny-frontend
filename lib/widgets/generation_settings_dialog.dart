import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user_settings_model.dart';

class GenerationSettingsDialog extends StatefulWidget {
  final UserSettings currentSettings;

  const GenerationSettingsDialog({super.key, required this.currentSettings});

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

    // Create maps for the dropdown options
    final Map<LearningLevel, String> levelOptions = {
      LearningLevel.beginner: l10n.generationSettingsDialog_levelBeginner,
      LearningLevel.intermediate:
          l10n.generationSettingsDialog_levelIntermediate,
      LearningLevel.advanced: l10n.generationSettingsDialog_levelAdvanced,
    };

    final Map<PathLength, String> lengthOptions = {
      PathLength.quick: l10n.generationSettingsDialog_lengthQuick,
      PathLength.standard: l10n.generationSettingsDialog_lengthStandard,
      PathLength.inDepth: l10n.generationSettingsDialog_lengthInDepth,
    };

    return AlertDialog(
      title: Text(l10n.generationSettingsDialog_title),
      content: SingleChildScrollView( // Wrap in a scroll view for smaller screens
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
              items: levelOptions.entries.map((entry) {
                return DropdownMenuItem<LearningLevel>(
                  value: entry.key,
                  child: Text(entry.value),
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
              items: lengthOptions.entries.map((entry) {
                return DropdownMenuItem<PathLength>(
                  value: entry.key,
                  child: Text(entry.value),
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
            // Return a new UserSettings object with the updated values
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