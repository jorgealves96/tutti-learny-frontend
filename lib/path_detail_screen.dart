import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'models/path_detail_model.dart';
import 'services/api_service.dart';
import 'content_viewer_screen.dart';
import 'subscription_screen.dart';
import 'l10n/app_localizations.dart';
import 'rating_screen.dart';
import 'utils/snackbar_helper.dart';
import 'models/subscription_status_model.dart';
import 'report_problem_screen.dart';
import 'report_status_screen.dart';
import 'quiz_history_screen.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PathDetailScreen extends StatefulWidget {
  final int? pathId;
  final LearningPathDetail? initialPathData;
  final SubscriptionStatus? subscriptionStatus;

  const PathDetailScreen({
    super.key,
    this.pathId,
    this.initialPathData,
    this.subscriptionStatus,
  }) : assert(
         pathId != null || initialPathData != null,
         'Either pathId or initialPathData must be provided.',
       );

  @override
  State<PathDetailScreen> createState() => _PathDetailScreenState();
}

class _PathDetailScreenState extends State<PathDetailScreen> {
  LearningPathDetail? _pathDetail;
  bool _isLoading = true;
  String? _error;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    if (widget.initialPathData != null) {
      // If data was passed in, use it directly.
      setState(() {
        _pathDetail = widget.initialPathData;
        _isLoading = false;
      });
    } else {
      // Otherwise, fetch from the API.
      _fetchPathDetails();
    }
  }

  Future<void> _fetchPathDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final path = await _apiService.fetchPathDetails(widget.pathId!);
      if (mounted) {
        setState(() {
          _pathDetail = path;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text("Error: $_error")));
    }

    if (_pathDetail == null) {
      return const Scaffold(body: Center(child: Text("Path not found.")));
    }

    // Once loaded, build the main view
    return _PathDetailView(
      pathDetail: _pathDetail!,
      subscriptionStatus: widget.subscriptionStatus,
      onRefresh:
          _fetchPathDetails, // The refresh callback now calls _fetchPathDetails
    );
  }
}

class _PathDetailView extends StatefulWidget {
  final LearningPathDetail pathDetail;
  final SubscriptionStatus? subscriptionStatus;
  final VoidCallback onRefresh;

  const _PathDetailView({
    required this.pathDetail,
    this.subscriptionStatus,
    required this.onRefresh,
  });

  @override
  State<_PathDetailView> createState() => _PathDetailViewState();
}

class _PathDetailViewState extends State<_PathDetailView> {
  late List<PathItemDetail> _items;
  final ApiService _apiService = ApiService();
  bool _isExtending = false;
  bool _isPathComplete = false;
  // --- 1. State variable to track new item IDs ---
  final Set<int> _newlyAddedItemIds = <int>{};

  // Showcase keys
  final GlobalKey _progressKey = GlobalKey();
  final GlobalKey _checkboxKey = GlobalKey();
  final GlobalKey _resourceKey = GlobalKey();
  final GlobalKey _extendPathKey = GlobalKey();
  final GlobalKey _moreMenuKey = GlobalKey();

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

  void _showSubscriptionSheet(SubscriptionStatus? status) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SubscriptionScreen(currentStatus: status),
    ).then((needsRefresh) {
      if (needsRefresh == true) {
        widget.onRefresh(); // Call the refresh callback passed to this screen
      }
    });
  }

  void _showUpgradeDialog(
    AppLocalizations l10n,
    errorMessage,
    SubscriptionStatus? status,
  ) {
    String nextResetDateText = '';
    if (status != null) {
      final nextResetDate = status.lastUsageResetDate.add(
        const Duration(days: 30),
      );
      // Format the date into a user-friendly string (e.g., "August 10, 2025")
      final formattedDate = DateFormat.yMMMMd(
        l10n.localeName,
      ).format(nextResetDate);
      nextResetDateText = l10n.homeScreen_limitResetsOn(formattedDate);
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.homeScreen_usageLimitReached),
          // Use a Column to display multiple lines of text
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(errorMessage.replaceFirst("Exception: ", "")),
              if (nextResetDateText.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  nextResetDateText,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.homeScreen_maybeLater),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: Text(l10n.homeScreen_upgrade),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                _showSubscriptionSheet(status); // Open the subscription sheet
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _extendPath(AppLocalizations l10n) async {
    setState(() {
      _isExtending = true;
      // Clear previous highlights when extending again
      _newlyAddedItemIds.clear();
    });
    try {
      final newItems = await _apiService.extendLearningPath(
        widget.pathDetail.userPathId,
      );

      if (!mounted) return;

      if (newItems.isEmpty) {
        setState(() {
          _isPathComplete = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.pathDetailScreen_pathCompleted)),
          );
        }
      } else {
        setState(() {
          _items.addAll(newItems);
          // --- 2. Store the new item IDs after extending the path ---
          _newlyAddedItemIds.addAll(newItems.map((item) => item.id));
        });
        showSuccessSnackBar(context, l10n.pathDetailScreen_pathExtendedSuccess);
      }
    } catch (e) {
      // --- 3. Update the catch block to check the error message ---
      if (e.toString().toLowerCase().contains('limit')) {
        // If the user hit their usage limit, show the upgrade dialog
        _showUpgradeDialog(
          l10n,
          l10n.pathDetailScreen_extensionLimitExceeded,
          widget.subscriptionStatus,
        );
      } else {
        // Otherwise, show the normal error snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to extend path: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExtending = false;
        });
      }
    }
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

      final allResources = _items.expand((item) => item.resources);
      final bool isNowPathComplete = allResources.every(
        (res) => res.isCompleted,
      );

      if (isNowPathComplete && !widget.pathDetail.hasBeenRated && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RatingScreen(
              pathTemplateId: widget.pathDetail.pathTemplateId,
              pathTitle: widget.pathDetail.title,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        item.isCompleted = originalState;
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

  Future<void> _toggleResource(
    ResourceDetail resource,
    PathItemDetail parentItem,
  ) async {
    final originalResourceState = resource.isCompleted;
    final originalParentState = parentItem.isCompleted;
    setState(() {
      resource.isCompleted = !originalResourceState;
      parentItem.isCompleted = parentItem.resources.every((r) => r.isCompleted);
    });

    try {
      await _apiService.toggleResourceCompletion(resource.id);

      final allResources = _items.expand((item) => item.resources);
      // Check if every single resource is now complete
      final bool isNowPathComplete = allResources.every(
        (res) => res.isCompleted,
      );

      if (isNowPathComplete && !widget.pathDetail.hasBeenRated && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RatingScreen(
              pathTemplateId: widget.pathDetail.pathTemplateId,
              pathTitle: widget.pathDetail.title,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        resource.isCompleted = originalResourceState;
        parentItem.isCompleted = originalParentState;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update resource: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openContent(ResourceDetail resource, AppLocalizations l10n) {
    if (resource.url.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ContentViewerScreen(url: resource.url, title: resource.title),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pathDetailScreen_noLinkAvailable)),
      );
    }
  }

  Future<void> _showDeleteConfirmation(AppLocalizations l10n) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.pathDetailScreen_deletePathTitle),
          content: Text(l10n.pathDetailScreen_deletePathConfirm),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.pathDetailScreen_cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                l10n.pathDetailScreen_delete,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deletePath(); // Call the delete method
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePath() async {
    try {
      await _apiService.deletePath(widget.pathDetail.userPathId);
      if (mounted) {
        // Pop back to the previous screen (My Paths) after successful deletion
        // Pass a value to indicate a refresh is needed
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete path: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showOnboarding(BuildContext context) async {
    // Use a unique key for this screen's tour
    const String tourKey = 'hasSeenPathDetailTour';
    final showCase = ShowCaseWidget.of(context);

    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenTour = prefs.getBool(tourKey) ?? false;

    if (!hasSeenTour) {
      // Use a post-frame callback to ensure the showcase starts after the build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCase.startShowCase([
          _progressKey,
          _checkboxKey,
          _resourceKey,
          _extendPathKey,
          _moreMenuKey,
        ]);
      });

      await prefs.setBool(tourKey, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ShowCaseWidget(
      builder: (context) {
        // Schedule the onboarding to run after the screen is built.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showOnboarding(context);
        });

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(_completionPercent),
            ),
            actions: [
              // --- Showcase for the 3-dot menu ---
              Showcase(
                key: _moreMenuKey,
                title: l10n.pathDetailScreen_onboarding_menu_title,
                description: l10n.pathDetailScreen_onboarding_menu_description,
                targetBorderRadius: BorderRadius.circular(48.0),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz),
                  iconSize: 35.0,
                  onSelected: (value) async {
                    if (value == 'delete') {
                      _showDeleteConfirmation(l10n);
                    } else if (value == 'report') {
                      final bool? reportSubmitted = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportProblemScreen(
                            pathTemplateId: widget.pathDetail.pathTemplateId,
                          ),
                        ),
                      );
                      if (reportSubmitted == true && mounted) {
                        widget.onRefresh();
                      }
                    } else if (value == 'check_status') {
                      final bool? acknowledged = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportStatusScreen(
                            pathTemplateId: widget.pathDetail.pathTemplateId,
                          ),
                        ),
                      );
                      if (acknowledged == true) {
                        widget.onRefresh();
                      }
                    } else if (value == 'quiz') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizHistoryScreen(
                            pathTemplateId: widget.pathDetail.pathTemplateId,
                            pathTitle: widget.pathDetail.title,
                            subscriptionStatus: widget.subscriptionStatus,
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'quiz',
                          child: ListTile(
                            leading: const Icon(Icons.quiz_outlined),
                            title: Text(
                              l10n.pathDetailScreen_testYourKnowledge,
                            ),
                          ),
                        ),
                        if (widget.pathDetail.hasOpenReport)
                          PopupMenuItem<String>(
                            value: 'check_status',
                            child: ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(
                                l10n.pathDetailScreen_checkReportStatus,
                              ),
                            ),
                          )
                        else
                          PopupMenuItem<String>(
                            value: 'report',
                            child: ListTile(
                              leading: const Icon(
                                Icons.report_problem_outlined,
                              ),
                              title: Text(l10n.pathDetailScreen_reportProblem),
                            ),
                          ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            title: Text(
                              l10n.pathDetailScreen_deletePathTitle,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Showcase(
            key: _extendPathKey,
            title: l10n.pathDetailScreen_onboarding_extend_title,
            description: l10n.pathDetailScreen_onboarding_extend_description,
            targetBorderRadius: BorderRadius.circular(100.0),
            child: _isPathComplete
                ? FloatingActionButton.extended(
                    onPressed: null, // Disabled button
                    label: Text(l10n.pathDetailScreen_pathIsComplete),
                    icon: const Icon(Icons.check_circle),
                    backgroundColor: Colors.green,
                  )
                : FloatingActionButton.extended(
                    onPressed: _isExtending ? null : () => _extendPath(l10n),
                    label: Text(
                      _isExtending
                          ? l10n.pathDetailScreen_generating
                          : l10n.pathDetailScreen_extendPath,
                    ),
                    icon: _isExtending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.add_road),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Showcase(
                  key: _progressKey,
                  title: l10n.pathDetailScreen_onboarding_main_title,
                  description:
                      l10n.pathDetailScreen_onboarding_main_description,
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 8.0,
                        percent: _completionPercent,
                        center: Text(
                          "${(_completionPercent * 100).toInt()}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
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
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.pathDetail.description,
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
                ),
                const SizedBox(height: 30),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final bool isNew = _newlyAddedItemIds.contains(item.id);

                    // For the first item in the list, wrap it for the showcase.
                    if (index == 0) {
                      return Showcase(
                        key: _checkboxKey,
                        title: l10n.pathDetailScreen_onboarding_checkbox_title,
                        description: l10n
                            .pathDetailScreen_onboarding_checkbox_description,
                        child: _buildPathItemCard(item, isNew, l10n),
                      );
                    }
                    // For all other items, build the card normally.
                    return _buildPathItemCard(item, isNew, l10n);
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPathItemCard(
    PathItemDetail item,
    bool isNew,
    AppLocalizations l10n,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: isNew
            ? const BorderSide(color: Colors.green, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Transform.scale(
                  scale: 1.4,
                  child: Checkbox(
                    value: item.isCompleted,
                    tristate:
                        !item.resources.every((r) => r.isCompleted) &&
                        item.resources.any((r) => r.isCompleted),
                    onChanged: (bool? value) {
                      _togglePathItem(item);
                    },
                    activeColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 1),
            ...item.resources.asMap().entries.map((entry) {
              int resourceIndex = entry.key;
              ResourceDetail resource = entry.value;

              // This is the ListTile for the resource
              Widget resourceTile = ListTile(
                leading: Checkbox(
                  value: resource.isCompleted,
                  onChanged: (bool? value) {
                    _toggleResource(resource, item);
                  },
                  activeColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                title: Text(resource.title),
                trailing: Icon(resource.icon, color: Colors.grey.shade700),
                onTap: () => _openContent(resource, l10n),
                contentPadding: EdgeInsets.zero,
              );

              // If this is the FIRST path item AND the FIRST resource, wrap it for the showcase.
              // We check item.order == 1 because the list index might not match the order number.
              if (item.order == 1 && resourceIndex == 0) {
                return Showcase(
                  key: _resourceKey,
                  title: l10n.pathDetailScreen_onboarding_resource_title,
                  description:
                      l10n.pathDetailScreen_onboarding_resource_description,
                  child: resourceTile,
                );
              }

              // Otherwise, return the normal ListTile.
              return resourceTile;
            }).toList(),
          ],
        ),
      ),
    );
  }
}
