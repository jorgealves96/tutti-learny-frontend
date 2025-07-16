import 'package:flutter/material.dart';
import 'my_path_model.dart';
import 'path_detail_screen.dart';

class MyPathsScreen extends StatefulWidget {
  final List<MyPath> myPaths; // Corrected from initialPaths
  final VoidCallback onAddPath;
  final VoidCallback onRefresh;

  const MyPathsScreen({
    super.key,
    required this.myPaths, // Corrected from initialPaths
    required this.onAddPath,
    required this.onRefresh,
  });

  @override
  State<MyPathsScreen> createState() => _MyPathsScreenState();
}

class _MyPathsScreenState extends State<MyPathsScreen> {
  late List<MyPath> _currentPaths;

  @override
  void initState() {
    super.initState();
    _currentPaths = List.from(widget.myPaths); // Corrected from initialPaths
  }

  @override
  void didUpdateWidget(covariant MyPathsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Use the correct property name to check for updates
    if (widget.myPaths != oldWidget.myPaths) {
      setState(() {
        _currentPaths = List.from(widget.myPaths);
      });
    }
  }

  Future<void> _navigateToDetail(BuildContext context, int pathId, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PathDetailScreen(pathId: pathId),
      ),
    );

    if (result is double) { // It's a progress update
      setState(() {
        final oldPath = _currentPaths[index];
        _currentPaths[index] = MyPath(
          id: oldPath.id,
          title: oldPath.title,
          description: oldPath.description,
          category: oldPath.category,
          progress: result,
        );
      });
    } else if (result == true) { // It's a delete confirmation
      widget.onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Paths', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: widget.onAddPath,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _currentPaths.isEmpty
          ? const Center(child: Text('No paths created yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _currentPaths.length,
              itemBuilder: (context, index) {
                final path = _currentPaths[index];
                return GestureDetector(
                  onTap: () => _navigateToDetail(context, path.id, index),
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
