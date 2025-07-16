import 'package:flutter/material.dart';
import 'my_path_model.dart';
import 'path_detail_screen.dart';
import 'generating_path_screen.dart';

class HomeScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final TextEditingController promptController = TextEditingController();

    void generatePath() {
      final prompt = promptController.text;
      if (prompt.isNotEmpty) {
        // Navigate to the generating screen and wait for a result (the new path ID)
        Navigator.push<int>(
          context,
          MaterialPageRoute(
            builder: (context) => GeneratingPathScreen(prompt: prompt),
          ),
        ).then((newPathId) {
          // This block runs after the GeneratingPathScreen pops
          if (newPathId != null) {
            // First, refresh the main list in the background
            onPathAction();
            
            // Then, navigate to the new detail screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PathDetailScreen(pathId: newPathId),
              ),
            ).then((_) {
              // This block runs when the user returns from the new detail screen,
              // ensuring the progress is updated.
              onPathAction();
            });
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a topic to generate a path.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }

    final displayedPaths = recentPaths.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tutti Learny',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'What will you master today?',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: promptController,
              focusNode: homeFocusNode,
              decoration: InputDecoration(
                hintText: 'e.g., Learn Python for data analysis...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              ),
              onSubmitted: (_) => generatePath(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: generatePath,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Generate Path',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              const Center(child: Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text('No recent paths found.'),
              ))
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
                      title: Text(path.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PathDetailScreen(pathId: path.id),
                          ),
                        ).then((_) => onPathAction());
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
