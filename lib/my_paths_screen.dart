import 'package:flutter/material.dart';
import 'models/my_path_model.dart';
import 'path_detail_screen.dart';
import 'l10n/app_localizations.dart';
import 'models/subscription_status_model.dart';
import 'package:shimmer/shimmer.dart';

class MyPathsScreen extends StatelessWidget {
  final List<MyPath>? myPaths;
  final VoidCallback onRefresh;
  final VoidCallback onAddPath;
  final SubscriptionStatus? subscriptionStatus;

  const MyPathsScreen({
    super.key,
    required this.myPaths,
    required this.onRefresh,
    required this.onAddPath,
    this.subscriptionStatus,
  });

  Future<void> _navigateToDetail(BuildContext context, int userPathId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PathDetailScreen(
          pathId: userPathId,
          subscriptionStatus: subscriptionStatus,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Determine the content based on the state of 'myPaths'
    Widget bodyContent;

    if (myPaths == null) {
      // Case 1: Data is still loading
      bodyContent = const MyPathsSkeleton();
    } else if (myPaths!.isEmpty) {
      // Case 2: Data has loaded, but the list is empty
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.myPathsScreen_noPathsCreatedYet,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              _AddPathButton(onPressed: onAddPath),
            ],
          ),
        ),
      );
    } else {
      // Case 3: Data has loaded and there are paths
      bodyContent = ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: myPaths!.length + 1,
        itemBuilder: (context, index) {
          if (index < myPaths!.length) {
            final path = myPaths![index];
            // Path Item Card
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _navigateToDetail(context, path.userPathId),
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
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(0.1),
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
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
          } else {
            // The "Add Path" button at the end of the list
            return Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
              child: _AddPathButton(onPressed: onAddPath),
            );
          }
        },
      );
    }

    return Scaffold(body: SafeArea(child: bodyContent));
  }
}

class _AddPathButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddPathButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) {
      // Return a temporary widget or an empty container while localizations load
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          foregroundColor: Theme.of(context).colorScheme.secondary,
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: Text(l10n.myPathsScreen_createANewPath),
      ),
    );
  }
}

class MyPathsSkeleton extends StatelessWidget {
  const MyPathsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5, // Show 5 placeholder items
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4,
            shadowColor: Colors.transparent,
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 16,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
