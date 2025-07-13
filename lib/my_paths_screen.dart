import 'package:flutter/material.dart';
import 'my_path_model.dart';
import 'api_service.dart';
import 'path_detail_screen.dart';

class MyPathsScreen extends StatefulWidget {
  const MyPathsScreen({super.key});

  @override
  State<MyPathsScreen> createState() => _MyPathsScreenState();
}

class _MyPathsScreenState extends State<MyPathsScreen> {
  late Future<List<MyPath>> _myPathsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchPaths(); // Initial data fetch
  }

  // Helper method to fetch or re-fetch the list of paths
  void _fetchPaths() {
    setState(() {
      _myPathsFuture = _apiService.fetchMyPaths();
    });
  }

  // Handles navigation and refreshes the data when the user returns
  Future<void> _navigateToDetail(int pathId) async {
    // Wait for the detail screen to be "popped" (i.e., when the user presses the back arrow)
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PathDetailScreen(pathId: pathId),
      ),
    );

    // After returning from the detail screen, refresh the list of paths
    _fetchPaths();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Paths', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<MyPath>>(
        future: _myPathsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No paths created yet.'));
          } else {
            final paths = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: paths.length,
              itemBuilder: (context, index) {
                final path = paths[index];
                return GestureDetector(
                  onTap: () => _navigateToDetail(path.id), // Call the new navigation method
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
            );
          }
        },
      ),
    );
  }
}
