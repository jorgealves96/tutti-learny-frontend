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
    final bool hasPaths = myPaths.isNotEmpty;

    return Scaffold(
      // Remove the appBar entirely
      // appBar: AppBar(...),
      body: SafeArea( // Use SafeArea to avoid status bar overlap
        child: hasPaths
            ? ListView.builder(
                // Add top padding to create the space at the top
                // Combined with the existing horizontal padding
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0), // Example: 16.0 top padding
                // itemCount will be myPaths.length + 1 to include the add button
                itemCount: myPaths.length + 1,
                itemBuilder: (context, index) {
                  if (index == myPaths.length) {
                    // This is the last item: the Add Path button
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Add some spacing
                      child: Center(
                        child: SizedBox(
                          child: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: onAddPath,
                            iconSize: 80, // Larger icon size
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // These are the regular path items
                    final path = myPaths[index];
                    return GestureDetector(
                      onTap: () => _navigateToDetail(context, path.userPathId),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Icon(
                                      path.icon,
                                      color: Theme.of(context).colorScheme.secondary,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          path.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          path.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
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
                                  Text(
                                    '${(path.progress * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add a SizedBox at the top for spacing when no paths exist
                  const SizedBox(height: 16.0), // Initial top spacing

                  // You might also want a title here if there's no AppBar
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Match ListView padding
                      child: Text(
                        'My Paths', // Add title when no AppBar is present
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), // Spacing between title and message
                  const Center(child: Text('No paths created yet.')),
                  const SizedBox(height: 40), // Add spacing
                  Center(
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: onAddPath,
                        iconSize: 60,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}