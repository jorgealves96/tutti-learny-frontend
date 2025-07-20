import 'package:flutter/material.dart';
import 'api_service.dart';
import 'path_suggestion_model.dart';
import 'generating_path_screen.dart';

class SuggestionsScreen extends StatefulWidget {
  final String prompt;
  final VoidCallback onPathCreated;

  const SuggestionsScreen({super.key, required this.prompt, required this.onPathCreated});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<PathSuggestion>> _suggestionsFuture;

  @override
  void initState() {
    super.initState();
    _suggestionsFuture = _apiService.fetchSuggestions(widget.prompt);
  }

  Future<void> _assignPath(int templateId) async {
    try {
      final newPath = await _apiService.assignPath(templateId);
      if (mounted) {
        // Pop this screen and return the new UserPath ID to the HomeScreen
        Navigator.pop(context, newPath.userPathId);
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error assigning path: $e')));
      }
    }
  }

  Future<void> _generateNewPath() async {
    final newPathId = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => GeneratingPathScreen(prompt: widget.prompt),
      ),
    );

    if (newPathId != null && mounted) {
      // Pop this screen and return the new UserPath ID to the HomeScreen
      Navigator.pop(context, newPathId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions'),
      ),
      body: FutureBuilder<List<PathSuggestion>>(
        future: _suggestionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _generateNewPath,
                    child: const Text('Generate a New Path Instead'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _generateNewPath();
            });
            return const Center(child: Text('No suggestions found. Generating a new path...'));
          }

          final suggestions = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'We found some existing paths for "${widget.prompt}". Start with one of these or generate your own.',
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
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Icon(suggestion.icon, color: Theme.of(context).colorScheme.secondary),
                        title: Text(suggestion.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(suggestion.description),
                        onTap: () => _assignPath(suggestion.id),
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
                    onPressed: _generateNewPath,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)
                    ),
                    child: const Text('Generate My Own Path', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
