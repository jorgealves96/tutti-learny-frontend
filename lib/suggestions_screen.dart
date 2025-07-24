import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/path_suggestion_model.dart';
import 'generating_path_screen.dart';
import 'path_detail_screen.dart';

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

  Future<void> _assignPath(BuildContext context, int templateId) async {
    final apiService = ApiService();
    try {
      final newPath = await apiService.assignPath(templateId);
      if (context.mounted) {
        // Pop this screen and return the new UserPath ID to the HomeScreen
        Navigator.pop(context, newPath.userPathId);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error assigning path: $e')));
      }
    }
  }

  // This method now correctly navigates to the generating screen and then
  // passes the result back up to the HomeScreen.
  Future<void> _generateNewPath(BuildContext context) async {
    final newPathId = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => GeneratingPathScreen(prompt: prompt),
      ),
    );

    if (newPathId != null && context.mounted) {
      // After the generating screen is done, pop this suggestions screen
      // and pass the new ID back to the HomeScreen that is waiting for it.
      Navigator.pop(context, newPathId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suggestions')),
      // Wrap the Column with a SafeArea widget
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'We found some existing paths for "$prompt". Start with one of these or generate your own.',
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
                      onTap: () => _assignPath(context, suggestion.id),
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
                  child: const Text(
                    'Generate My Own Path',
                    style: TextStyle(fontSize: 16),
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
