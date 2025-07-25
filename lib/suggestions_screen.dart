import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/path_suggestion_model.dart';
import 'generating_path_screen.dart';
import 'l10n/app_localizations.dart';

class SuggestionsScreen extends StatelessWidget {
  final String prompt;
  final List<PathSuggestion> suggestions;
  final VoidCallback onPathCreated;

  const SuggestionsScreen({
    super.key,
    required this.prompt,
    required this.suggestions,
    required this.onPathCreated,
  });

  Future<void> _assignPath(BuildContext context, int templateId, AppLocalizations l10n) async {
    final apiService = ApiService();
    try {
      final newPath = await apiService.assignPath(templateId);
      if (context.mounted) {
        Navigator.pop(context, newPath.userPathId);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(
          // Use translated string with placeholder
          content: Text(l10n.suggestionsScreen_errorAssigningPath(e.toString())),
        ));
      }
    }
  }

  Future<void> _generateNewPath(BuildContext context) async {
    final newPathId = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => GeneratingPathScreen(prompt: prompt),
      ),
    );

    if (newPathId != null && context.mounted) {
      Navigator.pop(context, newPathId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the l10n object
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      // Return a loading state if localizations are not yet available
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        // Use translated string
        title: Text(l10n.suggestionsScreen_title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                // Use translated string with placeholder
                l10n.suggestionsScreen_header(prompt),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: Icon(
                        suggestion.icon,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(
                        suggestion.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(suggestion.description),
                      // Pass the l10n object to the handler
                      onTap: () => _assignPath(context, suggestion.id, l10n),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _generateNewPath(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    // Use translated string
                    l10n.suggestionsScreen_generateMyOwnPath,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}