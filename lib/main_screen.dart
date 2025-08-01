import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'home_screen.dart';
import 'models/my_path_model.dart';
import 'my_paths_screen.dart';
import 'profile_screen.dart';
import 'models/profile_stats_model.dart';
import 'models/subscription_status_model.dart';
import 'l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainScreen({super.key, required this.onLogout});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 1;
  final ApiService _apiService = ApiService();
  late Future<List<MyPath>> _pathsFuture;
  late Future<ProfileStats?> _profileStatsFuture;
  late Future<SubscriptionStatus> _subscriptionStatusFuture;
  final FocusNode _homeScreenFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _reloadData();

    // Listen for any updates to the user's profile (like name changes).
    AuthService.currentUserNotifier.addListener(_onUserChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _homeScreenFocusNode.dispose();

    // Clean up the listener to prevent memory leaks.
    AuthService.currentUserNotifier.removeListener(_onUserChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // If the app is resumed from the background, call syncUser
    if (state == AppLifecycleState.resumed) {
      ApiService().syncUser();
    }
  }

  // This method is called when the user data changes, triggering a rebuild.
  void _onUserChanged() {
    if (mounted) {
      setState(() {
        // The only purpose of this is to rebuild the widget tree.
        // The children widgets will get the updated user data from
        // AuthService.currentUser when they rebuild.
      });
    }
  }

  void _reloadData() {
    setState(() {
      _pathsFuture = _apiService.fetchMyPaths();
      _profileStatsFuture = _apiService.fetchProfileStats();
      _subscriptionStatusFuture = _apiService.fetchSubscriptionStatus();
    });
  }

  void _onItemTapped(int index) {
    // Only rebuild if a different tab is tapped
    if (_selectedIndex == index) return;

    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _navigateAndFocusHome() {
    _onItemTapped(1);
    Future.delayed(const Duration(milliseconds: 50), () {
      _homeScreenFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) {
      // Return a temporary widget or an empty container while localizations load
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          _pathsFuture,
          _profileStatsFuture,
          _subscriptionStatusFuture,
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return ErrorDisplay(
              errorMessage: snapshot.error.toString().replaceFirst(
                "Exception: ",
                "",
              ),
              onRetry: _reloadData,
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final paths = snapshot.data![0] as List<MyPath>;
          final stats = snapshot.data![1] as ProfileStats?;
          final subscriptionStatus = snapshot.data![2] as SubscriptionStatus;

          final List<Widget> widgetOptions = <Widget>[
            MyPathsScreen(
              key: const PageStorageKey('MyPathsScreen'),
              myPaths: paths,
              onAddPath: _navigateAndFocusHome,
              onRefresh: _reloadData,
            ),
            HomeScreen(
              key: const PageStorageKey('HomeScreen'),
              recentPaths: paths,
              onPathAction: _reloadData,
              homeFocusNode: _homeScreenFocusNode,
              subscriptionStatus: subscriptionStatus,
            ),
            ProfileScreen(
              key: const PageStorageKey('ProfileScreen'),
              onLogout: widget.onLogout,
              onRefresh: _reloadData,
              stats: stats,
              subscriptionStatus: subscriptionStatus,
            ),
          ];

          return IndexedStack(index: _selectedIndex, children: widgetOptions);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: l10n.mainScreen_labelMyPaths,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: l10n.mainScreen_labelHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: l10n.mainScreen_labelProfile,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class ErrorDisplay extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorDisplay({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 60, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
