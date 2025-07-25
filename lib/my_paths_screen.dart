import 'package:flutter/material.dart';
import 'models/my_path_model.dart';
import 'path_detail_screen.dart';
import 'l10n/app_localizations.dart';

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

  Future<void> _navigateToDetail(BuildContext context, int userPathId) async {
    Future.delayed(const Duration(milliseconds: 50), () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PathDetailScreen(pathId: userPathId),
        ),
      );
      onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: myPaths.isEmpty
            // --- Empty State View ---
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.myPathsScreen_noPathsCreatedYet,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      _AddPathButton(onPressed: onAddPath),
                    ],
                  ),
                ),
              )
            // --- List View with Paths ---
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: myPaths.length + 1,
                itemBuilder: (context, index) {
                  if (index < myPaths.length) {
                    final path = myPaths[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () =>
                            _navigateToDetail(context, path.userPathId),
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                      child: _AddPathButton(onPressed: onAddPath),
                    );
                  }
                },
              ),
      ),
    );
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
