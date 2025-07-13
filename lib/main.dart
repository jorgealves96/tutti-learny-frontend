import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'my_paths_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(const TuttiLearnyApp());
}

class TuttiLearnyApp extends StatelessWidget {
  const TuttiLearnyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutti Learny',
      theme: ThemeData(
        // Define the color scheme based on the design
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A192F), // Deep Navy Blue
          primary: const Color(0xFF0A192F),
          secondary: const Color(0xFF007BFF), // A vibrant blue for buttons
          surface: const Color(0xFFF4F6F8), // Light grey background
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        // Use the Inter font throughout the app
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

// This widget manages the state of the Bottom Navigation Bar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // A list of the widgets to display for each tab
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MyPathsScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Updated list of navigation items
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'My Paths',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        // Use the accent color for the selected item
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        // These properties are needed to show labels and prevent the bar from shifting
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
