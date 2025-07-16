import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'path_detail_model.dart';
import 'api_service.dart';
import 'content_viewer_screen.dart';

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
    return FutureBuilder<LearningPathDetail>(
      future: _pathDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
        } else if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text("Path not found.")));
        }

        final pathDetail = snapshot.data!;
        return _PathDetailView(pathDetail: pathDetail);
      },
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
    final allResources = _items.expand((item) => item.resources).toList();
    if (allResources.isEmpty) return 0.0;
    final completedCount = allResources.where((r) => r.isCompleted).length;
    return completedCount / allResources.length;
  }

  Future<void> _togglePathItem(PathItemDetail item) async {
    final originalState = item.isCompleted;
    setState(() {
      item.isCompleted = !originalState;
      for (var resource in item.resources) {
        resource.isCompleted = item.isCompleted;
      }
    });

    try {
      await _apiService.togglePathItemCompletion(item.id);
    } catch (e) {
      setState(() {
        item.isCompleted = originalState;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update task: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _toggleResource(ResourceDetail resource, PathItemDetail parentItem) async {
    final originalResourceState = resource.isCompleted;
    final originalParentState = parentItem.isCompleted;
    setState(() {
      resource.isCompleted = !originalResourceState;
      parentItem.isCompleted = parentItem.resources.every((r) => r.isCompleted);
    });

    try {
      await _apiService.toggleResourceCompletion(resource.id);
    } catch (e) {
      setState(() {
        resource.isCompleted = originalResourceState;
        parentItem.isCompleted = originalParentState;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update resource: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _openContent(ResourceDetail resource) {
    if (resource.url.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContentViewerScreen(url: resource.url, title: resource.title),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This resource has no link available.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // When the back button is pressed, pop with the current progress value
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(_completionPercent),
        ),
        title: Text(widget.pathDetail.title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
      body: SingleChildScrollView(
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
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: item.isCompleted,
                                tristate: !item.resources.every((r) => r.isCompleted) && item.resources.any((r) => r.isCompleted),
                                onChanged: (bool? value) {
                                  _togglePathItem(item);
                                },
                                activeColor: Theme.of(context).colorScheme.secondary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 1),
                        ...item.resources.map((resource) {
                          return ListTile(
                            leading: Checkbox(
                              value: resource.isCompleted,
                              onChanged: (bool? value) {
                                _toggleResource(resource, item);
                              },
                              activeColor: Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            title: Text(resource.title),
                            trailing: Icon(resource.icon, color: Colors.grey.shade700),
                            onTap: () => _openContent(resource),
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
