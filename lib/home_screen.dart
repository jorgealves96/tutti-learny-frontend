import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'services/auth_service.dart';
import 'models/my_path_model.dart';
import 'path_detail_screen.dart';
import 'generating_path_screen.dart';
import 'suggestions_screen.dart';
import 'services/api_service.dart';
import 'widgets/rotating_hint_text_field.dart';
import 'subscription_screen.dart';
import 'models/subscription_status_model.dart';
import 'l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/snackbar_helper.dart';
import 'package:shimmer/shimmer.dart';
import 'models/path_detail_model.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'models/user_settings_model.dart';
import 'widgets/generation_settings_dialog.dart';

class HomeScreen extends StatefulWidget {
  final List<MyPath>? recentPaths;
  final VoidCallback onPathAction;
  final FocusNode homeFocusNode;
  final SubscriptionStatus? subscriptionStatus;
  final UserSettings? userSettings;
  final void Function(UserSettings) onSettingsChanged;

  const HomeScreen({
    super.key,
    required this.recentPaths,
    required this.onPathAction,
    required this.homeFocusNode,
    required this.subscriptionStatus,
    required this.userSettings,
    required this.onSettingsChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isCheckingSuggestions = false;

  // Showcase things
  final GlobalKey _welcomeKey = GlobalKey();
  final GlobalKey _promptKey = GlobalKey();
  final GlobalKey _createPathKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _showOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    const String homeScreenTourKey = 'hasSeenHomeScreenTour';
    final bool hasSeenTour = prefs.getBool(homeScreenTourKey) ?? false;

    if (hasSeenTour) return;

    final route = ModalRoute.of(context);
    if (route == null) return;

    // This is the function that will start the showcase
    void startShowcase() {
      final showCase = ShowCaseWidget.of(context);
      showCase.startShowCase([
        _welcomeKey,
        _promptKey,
        _createPathKey,
        _settingsKey,
      ]);
      prefs.setBool(homeScreenTourKey, true);
    }

    // Check if the animation is already complete
    if (route.animation?.status == AnimationStatus.completed) {
      startShowcase();
    } else {
      // Otherwise, add a listener to wait for it to complete
      route.animation?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          startShowcase();
        }
      });
    }
  }

  Future<void> _showSettingsDialog() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final currentSettings =
        widget.userSettings ??
        UserSettings(
          learningLevel: LearningLevel.beginner,
          pathLength: PathLength.standard,
        );

    // Show the dialog and wait for the full UserSettings object back.
    final newSettings = await showDialog<UserSettings>(
      context: context,
      builder: (context) => GenerationSettingsDialog(
        currentSettings: currentSettings,
        subscriptionStatus: widget.subscriptionStatus,
      ),
    );

    // After the dialog closes, check if the widget is still on screen.
    if (!mounted) return;

    // Only proceed if the user selected a new level.
    if (newSettings != null) {
      try {
        // The API call is now in the onSettingsChanged callback.
        widget.onSettingsChanged(newSettings);

        showSuccessSnackBar(context, l10n.homeScreen_settingsSaved);
      } catch (e) {
        // If the API call fails, show a generic error message.
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Failed to save settings.')),
        );
      }
    }
  }

  Future<void> _startPathCreationFlow(AppLocalizations l10n) async {
    if (widget.subscriptionStatus == null) return;

    final prompt = _promptController.text;
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.homeScreen_pleaseEnterATopic),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCheckingSuggestions = true;
    });

    try {
      // This API call is now protected by the backend limit check
      final suggestions = await _apiService.fetchSuggestions(prompt);
      if (!mounted) return;

      if (suggestions.isNotEmpty) {
        // If there are suggestions, show the suggestions screen and await a result
        final result = await Navigator.push<dynamic>(
          context,
          MaterialPageRoute(
            builder: (context) => SuggestionsScreen(
              prompt: prompt,
              suggestions: suggestions,
              onPathCreated: widget.onPathAction,
            ),
          ),
        );

        _handlePathCreationResult(l10n, result);
      } else {
        // If no suggestions are returned (or if the limit was reached on the backend),
        // go directly to generation. This will correctly trigger the 429 error
        // if the limit was the reason for the empty list.
        _generateNewPath();
      }
    } catch (e) {
      // This will now catch the "limit reached" error from fetchSuggestions
      if (mounted) {
        if (e.toString().toLowerCase().contains('limit')) {
          _showUpgradeDialog(
            l10n,
            l10n.homeScreen_generationLimitExceeded,
            widget.subscriptionStatus,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error finding suggestions: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingSuggestions = false;
        });
      }
    }
  }

  void _handlePathCreationResult(AppLocalizations l10n, dynamic result) {
    // Handle the user backing out of a screen
    if (result == null) return;

    // Case 1: A suggestion was chosen, and we received the full path object.
    if (result is LearningPathDetail) {
      showSuccessSnackBar(context, l10n.homeScreen_pathCreatedSuccess);

      // Navigate to the detail screen, passing the data we already have.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PathDetailScreen(
            initialPathData: result,
            subscriptionStatus: widget.subscriptionStatus,
          ),
        ),
      ).then((_) {
        // THIS IS THE FIX:
        // Refresh the main list only AFTER returning from the detail screen.
        widget.onPathAction();
        widget.homeFocusNode.unfocus();
      });
      _promptController.clear();
    }
    // Case 2: A new path was generated from scratch.
    else if (result is int) {
      _navigateToDetailAndRefresh(result);
      _promptController.clear();
    }
    // Case 3: Handle errors from the generation process.
    else if (result is Map && result.containsKey('limit_error')) {
      _showUpgradeDialog(
        l10n,
        l10n.homeScreen_generationLimitExceeded,
        widget.subscriptionStatus,
      );
    } else if (result is Map && result.containsKey('error')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['error'].toString().replaceFirst("Exception: ", ""),
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _generateNewPath() async {
    final l10n = AppLocalizations.of(context)!;

    if (widget.subscriptionStatus == null) return;

    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (context) => GeneratingPathScreen(
          prompt: _promptController.text,
          subscriptionStatus: widget.subscriptionStatus,
        ),
      ),
    );
    // Use the new helper to handle the result
    _handlePathCreationResult(l10n, result);
  }

  void _navigateToDetailAndRefresh(int pathId) {
    final l10n = AppLocalizations.of(context)!;

    showSuccessSnackBar(context, l10n.homeScreen_pathCreatedSuccess);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PathDetailScreen(pathId: pathId)),
    ).then((_) {
      widget.onPathAction();
      widget.homeFocusNode.unfocus();
    });
  }

  void _showSubscriptionSheet(SubscriptionStatus? status) {
    showModalBottomSheet<bool>(
      // Specify the return type
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          SubscriptionScreen(currentStatus: widget.subscriptionStatus),
    ).then((needsRefresh) {
      // This code runs AFTER the sheet is closed.
      if (needsRefresh == true) {
        widget.onPathAction(); // This is the refresh callback from MainScreen
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

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    var firstName = user?.displayName?.split(' ').first;

    if (firstName == null || firstName.isEmpty) {
      firstName = 'there';
    }
    final userName = firstName;

    final l10n = AppLocalizations.of(context)!;

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final tuttiColor = isDarkMode ? Colors.white : const Color(0xFF141443);
    final learniColor = theme.colorScheme.secondary;
    final defaultTextColor = isDarkMode ? Colors.white : Colors.black;

    return ShowCaseWidget(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.lora(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                  children: [
                    TextSpan(
                      text: 'Tutti',
                      style: TextStyle(color: tuttiColor),
                    ),
                    TextSpan(
                      text: ' Learni',
                      style: TextStyle(color: learniColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Showcase(
              key: _settingsKey,
              title: l10n.homeScreen_onboarding_settings_title,
              description: l10n.homeScreen_onboarding_settings_description,
              targetShapeBorder: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: _showSettingsDialog,
                iconSize: 28,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 8), // Add a little padding
          ],
        ),
        body: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showOnboarding(context);
            });

            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.opaque,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Stack(
                  // Use a Stack to overlay the invisible anchor
                  alignment: Alignment.center,
                  children: [
                    Showcase(
                      key: _welcomeKey,
                      showArrow: false,
                      tooltipBorderRadius: BorderRadius.circular(12.0),

                      title: l10n.homeScreen_onboarding_welcome_title,

                      // Apply a single style to the entire title
                      titleTextStyle: GoogleFonts.lora(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: learniColor,
                      ),

                      description:
                          l10n.homeScreen_onboarding_welcome_description,

                      child: const SizedBox.shrink(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: defaultTextColor,
                                ),
                            children: <TextSpan>[
                              TextSpan(text: l10n.homeScreen_hi),
                              ...[
                                for (int i = 0; i < userName.length; i++)
                                  TextSpan(
                                    text: userName[i],
                                    style: TextStyle(
                                      color: i < userName.length / 2
                                          ? tuttiColor
                                          : learniColor,
                                    ),
                                  ),
                              ],
                              TextSpan(text: l10n.homeScreen_callToActionMsg),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        RotatingHintTextField(
                          controller: _promptController,
                          focusNode: widget.homeFocusNode,
                          onSubmitted: () => _startPathCreationFlow(l10n),
                          subscriptionStatus: widget.subscriptionStatus,
                          showcaseKey: _promptKey,
                          showcaseTitle:
                              l10n.homeScreen_onboarding_prompt_title,
                          showcaseDescription:
                              l10n.homeScreen_onboarding_prompt_description,
                        ),
                        const SizedBox(height: 20),
                        Showcase(
                          key: _createPathKey,
                          title: l10n.homeScreen_onboarding_createButton_title,
                          description: l10n
                              .homeScreen_onboarding_createButton_description,
                          targetBorderRadius: BorderRadius.circular(12.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isCheckingSuggestions
                                  ? null
                                  : () => _startPathCreationFlow(l10n),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 5,
                              ),
                              child: _isCheckingSuggestions
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      l10n.homeScreen_createLearningPath,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        _buildRecentPathsSection(context, l10n),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecentPathsSection(BuildContext context, AppLocalizations l10n) {
    // Case 1: Data is loading, show skeleton
    if (widget.recentPaths == null) {
      return const _RecentPathsSkeleton();
    }

    // Case 2: Data loaded, but no paths exist, show nothing
    if (widget.recentPaths!.isEmpty) {
      return const SizedBox.shrink(); // Takes up no space
    }

    // Case 3: Data loaded and paths exist
    final displayedPaths = widget.recentPaths!.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Text(
          l10n.homeScreen_recentlyCreatedPaths,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedPaths.length,
          itemBuilder: (context, index) {
            final path = displayedPaths[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                title: Text(
                  path.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: CircularPercentIndicator(
                  radius: 15.0,
                  lineWidth: 3.5,
                  percent: path.progress,
                  progressColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Colors.grey.shade300,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PathDetailScreen(pathId: path.userPathId),
                    ),
                  ).then((_) => widget.onPathAction());
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// --- NEW: Skeleton widget for the recent paths section ---
class _RecentPathsSkeleton extends StatelessWidget {
  const _RecentPathsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Title placeholder
          Container(
            height: 24,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),
          // List item placeholders
          _buildSkeletonListItem(),
          const SizedBox(height: 12),
          _buildSkeletonListItem(),
          const SizedBox(height: 12),
          _buildSkeletonListItem(),
        ],
      ),
    );
  }

  Widget _buildSkeletonListItem() {
    return Container(
      height: 56, // Approx height of a ListTile in a Card
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
