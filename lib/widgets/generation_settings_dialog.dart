import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user_settings_model.dart';

class GenerationSettingsDialog extends StatefulWidget {
  final LearningLevel currentLevel;

  const GenerationSettingsDialog({
    super.key,
    required this.currentLevel,
  });

  @override
  State<GenerationSettingsDialog> createState() => _GenerationSettingsDialogState();
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
          const SizedBox(height: 8),
          // Use RadioListTile for the options
          RadioListTile<LearningLevel>(
            title: Text(l10n.generationSettingsDialog_levelBeginner),
            value: LearningLevel.beginner,
            groupValue: _selectedLevel,
            onChanged: (value) {
              if (value != null) setState(() => _selectedLevel = value);
            },
          ),
          RadioListTile<LearningLevel>(
            title: Text(l10n.generationSettingsDialog_levelIntermediate),
            value: LearningLevel.intermediate,
            groupValue: _selectedLevel,
            onChanged: (value) {
              if (value != null) setState(() => _selectedLevel = value);
            },
          ),
          RadioListTile<LearningLevel>(
            title: Text(l10n.generationSettingsDialog_levelAdvanced),
            value: LearningLevel.advanced,
            groupValue: _selectedLevel,
            onChanged: (value) {
              if (value != null) setState(() => _selectedLevel = value);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Return null on cancel
          child: Text(l10n.generationSettingsDialog_cancel),
        ),
        ElevatedButton(
          onPressed: () {
            // Return the selected level when saving
            Navigator.of(context).pop(_selectedLevel);
          },
          child: Text(l10n.generationSettingsDialog_save),
        ),
      ],
    );
  }
}