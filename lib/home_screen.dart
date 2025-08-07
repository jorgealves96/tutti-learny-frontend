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

class HomeScreen extends StatefulWidget {
  final List<MyPath> recentPaths;
  final VoidCallback onPathAction;
  final FocusNode homeFocusNode;
  final SubscriptionStatus subscriptionStatus; // Add this

  const HomeScreen({
    super.key,
    required this.recentPaths,
    required this.onPathAction,
    required this.homeFocusNode,
    required this.subscriptionStatus,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isCheckingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _user = AuthService.currentUser;
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _startPathCreationFlow(AppLocalizations l10n) async {
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
        _handlePathCreationResult(result);
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
          _showUpgradeDialog(e.toString(), widget.subscriptionStatus);
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

  void _handlePathCreationResult(dynamic result) {
    if (result is int) {
      _navigateToDetailAndRefresh(result);
    } else if (result is Map && result.containsKey('limit_error')) {
      _showUpgradeDialog(result['limit_error'], widget.subscriptionStatus);
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
    _handlePathCreationResult(result);
  }

  void _navigateToDetailAndRefresh(int pathId) {
    final l10n = AppLocalizations.of(context)!;

    showSuccessSnackBar(context, l10n.homeScreen_pathCreatedSuccess);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PathDetailScreen(pathId: pathId)),
    ).then((_) => widget.onPathAction());
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

  void _showUpgradeDialog(String errorMessage, SubscriptionStatus? status) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Usage Limit Reached"),
          content: Text(errorMessage.replaceFirst("Exception: ", "")),
          actions: <Widget>[
            TextButton(
              child: const Text("Maybe Later"),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: const Text("Upgrade"),
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
    final displayedPaths = widget.recentPaths.take(3).toList();
    var firstName = _user?.displayName?.split(' ').first;

    // If it's null OR empty, fall back to 'there'
    if (firstName == null || firstName.isEmpty) {
      firstName = 'there';
    }
    final userName = firstName;

    final l10n = AppLocalizations.of(context)!;

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final tuttiColor = isDarkMode ? Colors.white : const Color(0xFF141443);
    final learniColor =
        theme.colorScheme.secondary; // This works for both modes
    final defaultTextColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
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
                    style: TextStyle(
                      color: tuttiColor, // Hex color for #141443
                    ),
                  ),
                  TextSpan(
                    text: ' Learni',
                    style: TextStyle(
                      color: learniColor, // Hex color for #0067f9
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // This line removes focus from the text field and hides the keyboard.
          FocusScope.of(context).unfocus();
        },
        // This ensures the GestureDetector captures taps even on empty space.
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
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
                                ? tuttiColor // First half
                                : learniColor, // Second half
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
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCheckingSuggestions
                      ? null
                      : () => _startPathCreationFlow(l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              if (displayedPaths.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      l10n.homeScreen_recentlyCreatedPaths,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
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
                          elevation: 2,
                          shadowColor: Colors.black.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            title: Text(
                              path.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: CircularPercentIndicator(
                              radius: 15.0,
                              lineWidth: 3.5,
                              percent: path.progress,
                              progressColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
