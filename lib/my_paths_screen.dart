import 'package:flutter/material.dart';
import 'my_path_model.dart';
import 'path_detail_screen.dart';

class MyPathsScreen extends StatelessWidget {
  final List<MyPath> myPaths;
  final VoidCallback onRefresh;
  final VoidCallback onAddPath;

  const MyPathsScreen({
    super.key,
    required this.myPaths,
    required this.onRefresh,
    required this.onAddPath,
  });

  // Handles navigation and tells the parent to refresh when the user returns
  Future<void> _navigateToDetail(BuildContext context, int userPathId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PathDetailScreen(pathId: userPathId),
      ),
    );
    // After returning from the detail screen, call the parent's refresh callback.
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Paths',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Theme.of(
              context,
            ).colorScheme.secondary, // Use the secondary color
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: onAddPath,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: myPaths.isEmpty
          ? const Center(child: Text('No paths created yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: myPaths.length,
              itemBuilder: (context, index) {
                final path = myPaths[index];
                return GestureDetector(
                  // Use the correct userPathId property here
                  onTap: () => _navigateToDetail(context, path.userPathId),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Icon(path.icon, color: Theme.of(context).colorScheme.secondary, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(path.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(path.description, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: path.progress,
                                  backgroundColor: Colors.grey.shade300,
                                  color: Theme.of(context).colorScheme.secondary,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('${(path.progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
