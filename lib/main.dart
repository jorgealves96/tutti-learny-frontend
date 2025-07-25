import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'services/auth_service.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /*await Purchases.configure(
    //PurchasesConfiguration("your_apple_api_key")
      //..appUserID = null
      // ..setGoogleApiKey("your_google_api_key")
  );*/

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: const TuttiLearnyApp(),
    ),
  );
}

class TuttiLearnyApp extends StatelessWidget {
  const TuttiLearnyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to listen to the provider and get the correct context
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'Tutti Learni',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF141443),
              primary: const Color.fromARGB(255, 2, 2, 112),
              secondary: const Color(0xFF0067F9),
              surface: const Color(0xFFF4F6F8),
            ),
            scaffoldBackgroundColor: const Color(0xFFF4F6F8),
            textTheme: GoogleFonts.interTextTheme(
              Theme.of(context).textTheme,
            ),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          
          locale: localeProvider.locale, // Use the value from the builder
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          
          home: const AuthWrapper(),
        );
      },
    );
  }
}

// AuthWrapper remains the same
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return MainScreen(onLogout: () async {
            await AuthService.logout();
          });
        }
        return LoginScreen(onLoginSuccess: () {
          // The StreamBuilder will automatically rebuild
        });
      },
    );
  }
}