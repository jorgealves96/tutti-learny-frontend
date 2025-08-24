import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user_settings_model.dart';

class GenerationSettingsDialog extends StatefulWidget {
  final LearningLevel currentLevel;

  const GenerationSettingsDialog({super.key, required this.currentLevel});

  @override
  State<GenerationSettingsDialog> createState() =>
      _GenerationSettingsDialogState();
}

class _GenerationSettingsDialogState extends State<GenerationSettingsDialog> {
  late LearningLevel _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.currentLevel;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Create a map of the enum values to their display strings
    final Map<LearningLevel, String> levelOptions = {
      LearningLevel.beginner: l10n.generationSettingsDialog_levelBeginner,
      LearningLevel.intermediate:
          l10n.generationSettingsDialog_levelIntermediate,
      LearningLevel.advanced: l10n.generationSettingsDialog_levelAdvanced,
    };

    return AlertDialog(
      title: Text(l10n.generationSettingsDialog_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.generationSettingsDialog_learningLevel,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<LearningLevel>(
            value: _selectedLevel,
            // This creates the rounded border
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
            // This creates the list of items for the dropdown menu
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.generationSettingsDialog_cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedLevel);
          },
          child: Text(l10n.generationSettingsDialog_save),
        ),
      ],
    );
  }
}
