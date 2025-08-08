import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'providers/theme_provider.dart';
import 'services/auth_service.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'services/notification_service.dart';
import 'providers/notification_settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initialize();

  // --- RevenueCat SDK Initialization ---
  // Enable debug logs
  if (kDebugMode) {
    // Use verbose logs for development
    await Purchases.setLogLevel(LogLevel.debug);
  } else {
    // Use less verbose logs for release builds
    await Purchases.setLogLevel(LogLevel.info);
  }
  late PurchasesConfiguration configuration;
  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration("goog_miazFZFONgYPqIurCcTBbdvCYvX");
  } else if (Platform.isIOS) {
    // TODO: Replace with your actual public Apple API key from RevenueCat
    configuration = PurchasesConfiguration("your_apple_api_key");
  }
  await Purchases.configure(configuration);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationSettingsProvider()),
      ],
      child: const TuttiLearnyApp(),
    ),
  );
}

class TuttiLearnyApp extends StatelessWidget {
  const TuttiLearnyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, ThemeProvider>(
      // The AuthWrapper is passed as the 'child' parameter.
      // This tells the Consumer not to rebuild it when the theme changes.
      child: const AuthWrapper(),
      builder: (context, localeProvider, themeProvider, child) {
        return MaterialApp(
          title: 'Tutti Learni',

          // --- Theme Configuration ---
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0067F9),
              primary: const Color(0xFF141443),
              secondary: const Color(0xFF0067F9),
              surface: const Color(0xFFF4F6F8),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF4F6F8),
            // FIX: Create TextTheme from a consistent base
            textTheme: GoogleFonts.interTextTheme(
              ThemeData(brightness: Brightness.light).textTheme,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5A9BFF),
              primary: const Color(0xFFB3C5FF),
              secondary: const Color(0xFF5A9BFF),
              surface: const Color(0xFF1A1A1A),
              background: const Color(0xFF121212),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            // FIX: Create TextTheme from a consistent base
            textTheme: GoogleFonts.interTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ),
          ),

          debugShowCheckedModeBanner: false,

          locale: localeProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,

          // Use the 'child' that was passed in, which is our AuthWrapper.
          // This prevents it from being rebuilt.
          home: child,
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LoginScreen(onLoginSuccess: () {});
          }
          // If user is logged in, show the setup screen
          return const PostAuthScreen();
        }
        // While waiting for the initial auth state, show a loading indicator
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class PostAuthScreen extends StatefulWidget {
  const PostAuthScreen({super.key});

  @override
  State<PostAuthScreen> createState() => _PostAuthScreenState();
}

class _PostAuthScreenState extends State<PostAuthScreen> {
  late Future<void> _setupFuture;

  @override
  void initState() {
    super.initState();
    // Start the setup process which includes sync, reload, and FCM token update
    _setupFuture = AuthService.postLoginSetup();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _setupFuture,
      builder: (context, snapshot) {
        // While setup is running, show a loading spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If setup fails, show an error (postLoginSetup handles logout)
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Failed to load user data.')),
          );
        }
        // Once the setup future is complete, show the main app
        return MainScreen(
          setupFuture: _setupFuture,
          onLogout: () async {
            await AuthService.logout();
          },
        );
      },
    );
  }
}
