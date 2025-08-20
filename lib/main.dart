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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initialize();

  final notificationSettingsProvider = NotificationSettingsProvider();
  await notificationSettingsProvider.init();

  if (kDebugMode) {
    await Purchases.setLogLevel(LogLevel.debug);
  } else {
    await Purchases.setLogLevel(LogLevel.info);
  }

  late PurchasesConfiguration configuration;
  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration("goog_miazFZFONgYPqIurCcTBbdvCYvX");
  } else if (Platform.isIOS) {
    configuration = PurchasesConfiguration("your_apple_api_key");
  }

  await Purchases.configure(configuration);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: notificationSettingsProvider),
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
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
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
          return const PostAuthScreen();
        }
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
    _setupFuture = AuthService.postLoginSetup();
  }

  void _retrySetup() {
    setState(() {
      _setupFuture = AuthService.postLoginSetup();
    });
  }

  void _showRestoreAccountDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false, // User must choose an action
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.main_restoreAccountDialog_title),
          content: Text(l10n.main_restoreAccountDialog_content),
          actions: [
            TextButton(
              child: Text(l10n.main_restoreAccountDialog_cancel),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await AuthService.logout(); // Log the user out if they cancel
              },
            ),
            ElevatedButton(
              child: Text(l10n.main_restoreAccountDialog_restore),
              onPressed: () async {
                final navigator = Navigator.of(dialogContext);
                try {
                  await AuthService.restoreAccount();
                  navigator.pop();
                  _retrySetup(); // Re-run the setup process after restoring
                } catch (e) {
                  navigator.pop();
                  // Handle error during restore
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _setupFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          // Check if the error is our specific "account in cooldown" exception.
          if (snapshot.error.toString().contains('AccountInCooldownException')) {
            // Use a post-frame callback to show the dialog safely after the build.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showRestoreAccountDialog();
            });
            // Return an empty screen while the dialog is being prepared.
            return const Scaffold();
          } else {
            // For all other errors, show the generic retry screen.
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Failed to connect. Please check your internet connection.',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _retrySetup,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }
        }

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
