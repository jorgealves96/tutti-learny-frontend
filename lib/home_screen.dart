import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'auth_service.dart';
import 'my_path_model.dart';
import 'path_detail_screen.dart';
import 'generating_path_screen.dart';
import 'suggestions_screen.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  final List<MyPath> recentPaths;
  final VoidCallback onPathAction;
  final FocusNode homeFocusNode;

  const HomeScreen({
    super.key,
    required this.recentPaths,
    required this.onPathAction,
    required this.homeFocusNode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isCheckingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _user = AuthService.currentUser;
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _startPathCreationFlow() async {
    final prompt = _promptController.text;
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a topic to generate a path.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCheckingSuggestions = true;
    });

    try {
      final suggestions = await _apiService.fetchSuggestions(prompt);

      if (!mounted) return;

      if (suggestions.isNotEmpty) {
        // Navigate to suggestions and wait for an ID to be returned
        final newPathId = await Navigator.push<int>(
          context,
          MaterialPageRoute(
            builder: (context) => SuggestionsScreen(
              prompt: prompt,
              suggestions: suggestions,
              onPathCreated: widget.onPathAction,
            ),
          ),
        );
        if (newPathId != null) {
          _navigateToDetailAndRefresh(newPathId);
        }
      } else {
        // If no suggestions, go directly to generation
        _generateNewPath();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error finding suggestions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingSuggestions = false;
        });
      }
    }
  }

  Future<void> _generateNewPath() async {
    final newPathId = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GeneratingPathScreen(prompt: _promptController.text),
      ),
    );
    if (newPathId != null) {
      _navigateToDetailAndRefresh(newPathId);
    }
  }

  void _navigateToDetailAndRefresh(int pathId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PathDetailScreen(pathId: pathId)),
    ).then((_) => widget.onPathAction());
  }

  @override
  Widget build(BuildContext context) {
    final displayedPaths = widget.recentPaths.take(3).toList();
    var firstName = _user?.displayName?.split(' ').first;

    // If it's null OR empty, fall back to 'there'
    if (firstName == null || firstName.isEmpty) {
      firstName = 'there';
    }
    final userName = firstName;

    final List<Color> tuttiFruttiColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow.shade700,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo_original_size.png',
              height: 45, // Adjust the height as needed
            ),
            const SizedBox(
              width: 35,
            ), // Add some space between the logo and text
            // Use RichText to apply different colors to each letter
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40, // Adjusted font size to fit
                  fontFamily: 'Inter', // Make sure to use the same font
                ),
                children: List.generate(
                  'Tutti Learni'.length,
                  (index) => TextSpan(
                    text: 'Tutti Learni'[index],
                    style: TextStyle(
                      // Cycle through the colors for each letter
                      color: tuttiFruttiColors[index % tuttiFruttiColors.length]
                          .withAlpha((255 * 0.9).round()),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'Hi '),
                  ...List.generate(
                    userName.length,
                    (index) => TextSpan(
                      text: userName[index],
                      style: TextStyle(
                        color:
                            tuttiFruttiColors[index % tuttiFruttiColors.length]
                                .withAlpha((255 * 0.7).round()),
                      ),
                    ),
                  ),
                  const TextSpan(text: ',\nwhat do you want to learn today?'),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _promptController,
              focusNode: widget.homeFocusNode,
              decoration: InputDecoration(
                hintText: 'e.g., Learn Python for data analysis...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
              ),
              onSubmitted: (_) => _startPathCreationFlow(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCheckingSuggestions
                    ? null
                    : _startPathCreationFlow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                child: _isCheckingSuggestions
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Generate Path',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Recently Created Paths',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (displayedPaths.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text('No recent paths found.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedPaths.length,
                itemBuilder: (context, index) {
                  final path = displayedPaths[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        path.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: CircularPercentIndicator(
                        radius: 22.0,
                        lineWidth: 5.0,
                        percent: path.progress,
                        center: Text(
                          "${(path.progress * 100).toInt()}%",
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        progressColor: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Colors.grey.shade300,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PathDetailScreen(pathId: path.userPathId),
                          ),
                        ).then((_) => widget.onPathAction());
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
