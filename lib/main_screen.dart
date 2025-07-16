import 'package:flutter/material.dart';
import 'api_service.dart';
import 'home_screen.dart';
import 'my_path_model.dart';
import 'my_paths_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainScreen({super.key, required this.onLogout});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  final ApiService _apiService = ApiService();
  late Future<List<MyPath>> _pathsFuture;
  final FocusNode _homeScreenFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchPaths();
  }

  @override
  void dispose() {
    _homeScreenFocusNode.dispose();
    super.dispose();
  }

  void _fetchPaths() {
    setState(() {
      _pathsFuture = _apiService.fetchMyPaths();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateAndFocusHome() {
    _onItemTapped(1);
    Future.delayed(const Duration(milliseconds: 50), () {
      _homeScreenFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MyPath>>(
        future: _pathsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return ErrorDisplay(
              errorMessage: snapshot.error.toString().replaceFirst("Exception: ", ""),
              onRetry: _fetchPaths,
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final paths = snapshot.data!;
          
          final List<Widget> widgetOptions = <Widget>[
            MyPathsScreen(
              myPaths: paths,
              onAddPath: _navigateAndFocusHome,
              onRefresh: _fetchPaths,
            ),
            HomeScreen(
              recentPaths: paths, 
              onPathAction: _fetchPaths,
              homeFocusNode: _homeScreenFocusNode,
            ),
            ProfileScreen(onLogout: widget.onLogout),
          ];

          return IndexedStack(
            index: _selectedIndex,
            children: widgetOptions,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'My Paths'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class ErrorDisplay extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorDisplay({super.key, required this.errorMessage, required this.onRetry});

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
