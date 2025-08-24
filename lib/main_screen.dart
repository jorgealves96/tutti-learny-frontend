import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'home_screen.dart';
import 'models/my_path_model.dart';
import 'my_paths_screen.dart';
import 'profile_screen.dart';
import 'models/profile_stats_model.dart';
import 'models/subscription_status_model.dart';
import 'models/user_settings_model.dart';
import 'l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final Future<void> setupFuture;

  const MainScreen({
    super.key,
    required this.onLogout,
    required this.setupFuture,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 1;
  final ApiService _apiService = ApiService();
  final FocusNode _homeScreenFocusNode = FocusNode();

  List<MyPath>? _myPaths;
  ProfileStats? _profileStats;
  SubscriptionStatus? _subscriptionStatus;
  UserSettings? _userSettings;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _homeScreenFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ApiService().syncUser();
    }
  }

  Future<void> _initializeData() async {
    // 1. Wait for the setup future from the parent screen to complete.
    await widget.setupFuture;

    // 2. Now that setup is guaranteed to be done, load the data.
    _reloadData();
    AuthService.updateFcmTokenInBackground();
  }

  void _reloadData() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _myPaths = null;
      _profileStats = null;
      _subscriptionStatus = null;
      _userSettings = null;
    });

    Future.wait([
      _fetchMyPaths(),
      _fetchProfileStats(),
      _fetchSubscriptionStatus(),
      _fetchUserSettings(),
    ]).whenComplete(() {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchMyPaths() async {
    try {
      final paths = await _apiService.fetchMyPaths();
      if (mounted) setState(() => _myPaths = paths);
    } catch (e) {
      debugPrint('Failed to fetch paths: $e');
      if (mounted) setState(() => _myPaths = []);
    }
  }

  Future<void> _fetchProfileStats() async {
    try {
      final stats = await _apiService.fetchProfileStats();
      if (mounted) setState(() => _profileStats = stats);
    } catch (e) {
      debugPrint('Failed to fetch stats: $e');
      if (mounted) setState(() => _profileStats = null);
    }
  }

  Future<void> _fetchSubscriptionStatus() async {
    try {
      final status = await _apiService.fetchSubscriptionStatus();
      if (mounted) setState(() => _subscriptionStatus = status);
    } catch (e) {
      debugPrint('Failed to fetch subscription status: $e');
      if (mounted) setState(() => _subscriptionStatus = null);
    }
  }

  Future<void> _fetchUserSettings() async {
    try {
      final settings = await _apiService.fetchUserSettings();
      if (mounted) setState(() => _userSettings = settings);
    } catch (e) {
      debugPrint('Failed to fetch user settings: $e');
    }
  }

  void _onItemTapped(int index) {
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

  void _updateUserSettings(UserSettings newSettings) {
    setState(() {
      _userSettings = newSettings;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          MyPathsScreen(
            key: const PageStorageKey('MyPathsScreen'),
            myPaths: _myPaths,
            subscriptionStatus: _subscriptionStatus,
            onAddPath: _navigateAndFocusHome,
            onRefresh: _reloadData,
          ),
          HomeScreen(
            key: const PageStorageKey('HomeScreen'),
            recentPaths: _myPaths,
            subscriptionStatus: _subscriptionStatus,
            userSettings: _userSettings,
            onSettingsChanged: _updateUserSettings,
            onPathAction: _reloadData,
            homeFocusNode: _homeScreenFocusNode,
          ),
          ProfileScreen(
            key: const PageStorageKey('ProfileScreen'),
            stats: _profileStats,
            subscriptionStatus: _subscriptionStatus,
            onLogout: widget.onLogout,
            onRefresh: _reloadData,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.school_outlined),
            activeIcon: const Icon(Icons.school),
            label: l10n.mainScreen_labelMyPaths,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.mainScreen_labelHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
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
