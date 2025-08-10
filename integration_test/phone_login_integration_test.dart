import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io' show Platform;

// Import your app's files
import 'package:tutti_learny_frontend/main.dart' as app;
import 'package:tutti_learny_frontend/firebase_options.dart';
import 'package:tutti_learny_frontend/providers/locale_provider.dart';
import 'package:tutti_learny_frontend/providers/theme_provider.dart';
import 'package:tutti_learny_frontend/providers/notification_settings_provider.dart';
import 'package:tutti_learny_frontend/services/notification_service.dart';
import 'package:country_code_picker/country_code_picker.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Automatic phone verification with a test number succeeds', (WidgetTester tester) async {
    // 1. Initialize all necessary app services for the test environment.
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await NotificationService().initialize();
    SharedPreferences.setMockInitialValues({});
    
    final notificationSettingsProvider = NotificationSettingsProvider();
    await notificationSettingsProvider.init();
    
    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration("goog_miazFZFONgYPqIurCcTBbdvCYvX");
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration("your_apple_api_key");
    }
    await Purchases.configure(configuration);

    // 2. Pump the app with the pre-initialized providers.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider.value(value: notificationSettingsProvider),
        ],
        child: const app.TuttiLearnyApp(),
      ),
    );
    
    // 3. Wait for the app to settle (initial auth checks, etc.).
    await tester.pumpAndSettle();

    // 4. Find and tap the phone login button.
    final phoneLoginButton = find.byKey(const ValueKey('phone_login_button'));
    expect(phoneLoginButton, findsOneWidget);
    await tester.tap(phoneLoginButton);
    await tester.pumpAndSettle();

    // --- NEW: Correctly interact with the Country Code Picker ---
    // 5. Tap the country code picker to open the selection dialog.
    final countryPicker = find.byType(CountryCodePicker);
    expect(countryPicker, findsOneWidget);
    await tester.tap(countryPicker);
    await tester.pumpAndSettle(); // Wait for dialog to open

    // 6. Find 'United States' in the list and tap it to select the '+1' code.
    final usaSelection = find.text('Portugal').last;
    expect(usaSelection, findsOneWidget);
    await tester.tap(usaSelection);
    await tester.pumpAndSettle(); // Wait for dialog to close
    // -----------------------------------------------------------

    // 7. Enter the test phone number (without the country code).
    final phoneField = find.byType(TextField);
    expect(phoneField, findsOneWidget);
    await tester.enterText(phoneField, '6505553434'); // Firebase test number

    // 8. Tap the "Send Code" button.
    final sendCodeButton = find.text('Send Code');
    expect(sendCodeButton, findsOneWidget);
    await tester.tap(sendCodeButton);
    
    // --- THIS IS THE KEY PART FOR AUTO-VERIFICATION ---
    // 9. Wait for Firebase to do its magic. On a supported Android emulator,
    // this will trigger the `verificationCompleted` callback in your app,
    // which should handle the sign-in and navigation automatically.
    // We don't need to find or enter an OTP.
    await tester.pumpAndSettle(const Duration(seconds: 10)); // Allow time for auto-retrieval

    // 10. ASSERT: Verify that the login was successful and the home screen is visible.
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}