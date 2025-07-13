import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'path_detail_model.dart';
import 'api_service.dart';

class PathDetailScreen extends StatefulWidget {
  final int pathId;

  const PathDetailScreen({super.key, required this.pathId});

  @override
  State<PathDetailScreen> createState() => _PathDetailScreenState();
}

class _PathDetailScreenState extends State<PathDetailScreen> {
  late Future<LearningPathDetail> _pathDetailFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _pathDetailFuture = _apiService.fetchPathDetails(widget.pathId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Learning Path", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Extend Path', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.auto_awesome),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<LearningPathDetail>(
        future: _pathDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Path not found."));
          }

          final pathDetail = snapshot.data!;
          return _PathDetailView(pathDetail: pathDetail);
        },
      ),
    );
  }
}

class _PathDetailView extends StatefulWidget {
  final LearningPathDetail pathDetail;
  const _PathDetailView({required this.pathDetail});

  @override
  State<_PathDetailView> createState() => _PathDetailViewState();
}

class _PathDetailViewState extends State<_PathDetailView> {
  late List<PathItemDetail> _items;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _items = widget.pathDetail.pathItems;
  }

  double get _completionPercent {
    if (_items.isEmpty) return 0.0;
    final completedCount = _items.where((item) => item.isCompleted).length;
    return completedCount / _items.length;
  }

  // Method to handle toggling the completion status
  Future<void> _toggleCompletion(PathItemDetail item) async {
    // Optimistically update the UI
    setState(() {
      item.isCompleted = !item.isCompleted;
    });

    try {
      // Call the API to update the backend
      await _apiService.togglePathItemCompletion(item.id);
    } catch (e) {
      // If the API call fails, revert the change and show an error
      setState(() {
        item.isCompleted = !item.isCompleted;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update task: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircularPercentIndicator(
                radius: 45.0,
                lineWidth: 8.0,
                percent: _completionPercent,
                center: Text(
                  "${(_completionPercent * 100).toInt()}%",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                progressColor: Theme.of(context).colorScheme.secondary,
                backgroundColor: Colors.grey.shade300,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pathDetail.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.pathDetail.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: ListTile(
                  leading: Checkbox(
                    value: item.isCompleted,
                    onChanged: (bool? value) {
                      // Call the handler method when the checkbox is tapped
                      _toggleCompletion(item);
                    },
                    activeColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: Icon(item.icon, color: Colors.grey.shade700),
                  onTap: () {},
                ),
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
