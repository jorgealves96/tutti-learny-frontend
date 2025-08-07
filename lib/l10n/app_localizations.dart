import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// No description provided for @generatingPathsScreen_craftingPersonalizedLearningPath.
  ///
  /// In en, this message translates to:
  /// **'Crafting your personalized learning path'**
  String get generatingPathsScreen_craftingPersonalizedLearningPath;

  /// No description provided for @generatingPathsScreen_loadingPathGenerationMessage.
  ///
  /// In en, this message translates to:
  /// **'Our AI is working hard to create a curriculum tailored to your goals and learning style. This may take a few moments.'**
  String get generatingPathsScreen_loadingPathGenerationMessage;

  /// No description provided for @homeScreen_pleaseEnterATopic.
  ///
  /// In en, this message translates to:
  /// **'Please enter a topic to generate a path.'**
  String get homeScreen_pleaseEnterATopic;

  /// No description provided for @homeScreen_usageLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Usage Limit Reached'**
  String get homeScreen_usageLimitReached;

  /// No description provided for @homeScreen_maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get homeScreen_maybeLater;

  /// No description provided for @homeScreen_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get homeScreen_upgrade;

  /// No description provided for @homeScreen_namePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get homeScreen_namePlaceholder;

  /// No description provided for @homeScreen_hi.
  ///
  /// In en, this message translates to:
  /// **'Hi '**
  String get homeScreen_hi;

  /// No description provided for @homeScreen_callToActionMsg.
  ///
  /// In en, this message translates to:
  /// **',\nwhat do you want to learn today?'**
  String get homeScreen_callToActionMsg;

  /// No description provided for @homeScreen_createLearningPath.
  ///
  /// In en, this message translates to:
  /// **'Create Learning Path'**
  String get homeScreen_createLearningPath;

  /// No description provided for @homeScreen_recentlyCreatedPaths.
  ///
  /// In en, this message translates to:
  /// **'Recently Created Paths'**
  String get homeScreen_recentlyCreatedPaths;

  /// No description provided for @homeScreen_pathCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Path created successfully!'**
  String get homeScreen_pathCreatedSuccess;

  /// No description provided for @loginScreen_welcomePrimary.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get loginScreen_welcomePrimary;

  /// No description provided for @loginScreen_welcomeSecondary.
  ///
  /// In en, this message translates to:
  /// **'Your personal guide to learn anything.'**
  String get loginScreen_welcomeSecondary;

  /// No description provided for @loginScreen_continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginScreen_continueWithGoogle;

  /// No description provided for @loginScreen_failedToSignInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in with Google.'**
  String get loginScreen_failedToSignInGoogle;

  /// No description provided for @loginScreen_continueWithPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Continue with Phone Number'**
  String get loginScreen_continueWithPhoneNumber;

  /// No description provided for @mainScreen_labelMyPaths.
  ///
  /// In en, this message translates to:
  /// **'My Paths'**
  String get mainScreen_labelMyPaths;

  /// No description provided for @mainScreen_labelHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainScreen_labelHome;

  /// No description provided for @mainScreen_labelProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get mainScreen_labelProfile;

  /// No description provided for @mainScreen_tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get mainScreen_tryAgain;

  /// No description provided for @myPathsScreen_noPathsCreatedYet.
  ///
  /// In en, this message translates to:
  /// **'No paths created yet'**
  String get myPathsScreen_noPathsCreatedYet;

  /// No description provided for @myPathsScreen_createANewPath.
  ///
  /// In en, this message translates to:
  /// **'Create a New Path'**
  String get myPathsScreen_createANewPath;

  /// Error message shown when a path fails to load.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String pathDetailScreen_error(String error);

  /// No description provided for @pathDetailScreen_pathNotFound.
  ///
  /// In en, this message translates to:
  /// **'Path not found.'**
  String get pathDetailScreen_pathNotFound;

  /// No description provided for @pathDetailScreen_usageLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Usage Limit Reached'**
  String get pathDetailScreen_usageLimitReached;

  /// No description provided for @pathDetailScreen_maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get pathDetailScreen_maybeLater;

  /// No description provided for @pathDetailScreen_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get pathDetailScreen_upgrade;

  /// No description provided for @pathDetailScreen_pathCompleted.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have completed this path.'**
  String get pathDetailScreen_pathCompleted;

  /// No description provided for @pathDetailScreen_failedToExtendPath.
  ///
  /// In en, this message translates to:
  /// **'Failed to extend path: {error}'**
  String pathDetailScreen_failedToExtendPath(String error);

  /// No description provided for @pathDetailScreen_failedToUpdateTask.
  ///
  /// In en, this message translates to:
  /// **'Failed to update task: {error}'**
  String pathDetailScreen_failedToUpdateTask(String error);

  /// No description provided for @pathDetailScreen_failedToUpdateResource.
  ///
  /// In en, this message translates to:
  /// **'Failed to update resource: {error}'**
  String pathDetailScreen_failedToUpdateResource(String error);

  /// No description provided for @pathDetailScreen_noLinkAvailable.
  ///
  /// In en, this message translates to:
  /// **'This resource has no link available.'**
  String get pathDetailScreen_noLinkAvailable;

  /// No description provided for @pathDetailScreen_deletePathTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Path'**
  String get pathDetailScreen_deletePathTitle;

  /// No description provided for @pathDetailScreen_deletePathConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this learning path?'**
  String get pathDetailScreen_deletePathConfirm;

  /// No description provided for @pathDetailScreen_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pathDetailScreen_cancel;

  /// No description provided for @pathDetailScreen_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get pathDetailScreen_delete;

  /// No description provided for @pathDetailScreen_failedToDeletePath.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete path: {error}'**
  String pathDetailScreen_failedToDeletePath(String error);

  /// No description provided for @pathDetailScreen_pathIsComplete.
  ///
  /// In en, this message translates to:
  /// **'Path Complete!'**
  String get pathDetailScreen_pathIsComplete;

  /// No description provided for @pathDetailScreen_generating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get pathDetailScreen_generating;

  /// No description provided for @pathDetailScreen_extendPath.
  ///
  /// In en, this message translates to:
  /// **'Extend Path'**
  String get pathDetailScreen_extendPath;

  /// No description provided for @pathDetailScreen_pathExtendedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Path extended successfully!'**
  String get pathDetailScreen_pathExtendedSuccess;

  /// No description provided for @pathDetailScreen_checkReportStatus.
  ///
  /// In en, this message translates to:
  /// **'Check report status'**
  String get pathDetailScreen_checkReportStatus;

  /// No description provided for @pathDetailScreen_reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report A Problem'**
  String get pathDetailScreen_reportProblem;

  /// No description provided for @pathDetailScreen_testYourKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Test Your Knowledge'**
  String get pathDetailScreen_testYourKnowledge;

  /// No description provided for @phoneLoginScreen_enterPhoneNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get phoneLoginScreen_enterPhoneNumberTitle;

  /// No description provided for @phoneLoginScreen_enterVerificationCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get phoneLoginScreen_enterVerificationCodeTitle;

  /// No description provided for @phoneLoginScreen_enterPhoneNumberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your country and enter your phone number.'**
  String get phoneLoginScreen_enterPhoneNumberSubtitle;

  /// Message indicating where the verification code was sent.
  ///
  /// In en, this message translates to:
  /// **'A 6-digit code was sent to {fullPhoneNumber}'**
  String phoneLoginScreen_codeSentSubtitle(String fullPhoneNumber);

  /// No description provided for @phoneLoginScreen_phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLoginScreen_phoneNumberLabel;

  /// No description provided for @phoneLoginScreen_otpLabel.
  ///
  /// In en, this message translates to:
  /// **'6-Digit Code'**
  String get phoneLoginScreen_otpLabel;

  /// No description provided for @phoneLoginScreen_sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get phoneLoginScreen_sendCode;

  /// No description provided for @phoneLoginScreen_verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get phoneLoginScreen_verifyCode;

  /// No description provided for @phoneLoginScreen_pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number.'**
  String get phoneLoginScreen_pleaseEnterPhoneNumber;

  /// No description provided for @phoneLoginScreen_failedToSendCode.
  ///
  /// In en, this message translates to:
  /// **'Failed to send code: {error}'**
  String phoneLoginScreen_failedToSendCode(String error);

  /// No description provided for @phoneLoginScreen_anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String phoneLoginScreen_anErrorOccurred(String error);

  /// No description provided for @phoneLoginScreen_invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Please try again.'**
  String get phoneLoginScreen_invalidCode;

  /// No description provided for @profileScreen_editName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get profileScreen_editName;

  /// No description provided for @profileScreen_enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get profileScreen_enterYourName;

  /// No description provided for @profileScreen_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileScreen_cancel;

  /// No description provided for @profileScreen_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileScreen_save;

  /// No description provided for @profileScreen_failedToUpdateName.
  ///
  /// In en, this message translates to:
  /// **'Failed to update name: {error}'**
  String profileScreen_failedToUpdateName(String error);

  /// No description provided for @profileScreen_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileScreen_logout;

  /// No description provided for @profileScreen_logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profileScreen_logoutConfirm;

  /// No description provided for @profileScreen_deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileScreen_deleteAccount;

  /// No description provided for @profileScreen_deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This action cannot be undone.'**
  String get profileScreen_deleteAccountConfirm;

  /// No description provided for @profileScreen_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileScreen_delete;

  /// No description provided for @profileScreen_user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profileScreen_user;

  /// Text showing the month and year the user joined.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String profileScreen_joined(String date);

  /// No description provided for @profileScreen_sectionLearningStatistics.
  ///
  /// In en, this message translates to:
  /// **'Learning Statistics'**
  String get profileScreen_sectionLearningStatistics;

  /// No description provided for @profileScreen_sectionSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get profileScreen_sectionSubscription;

  /// No description provided for @profileScreen_sectionMonthlyUsage.
  ///
  /// In en, this message translates to:
  /// **'Monthly Usage'**
  String get profileScreen_sectionMonthlyUsage;

  /// No description provided for @profileScreen_sectionAccountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get profileScreen_sectionAccountManagement;

  /// No description provided for @profileScreen_statPathsStarted.
  ///
  /// In en, this message translates to:
  /// **'Paths Started'**
  String get profileScreen_statPathsStarted;

  /// No description provided for @profileScreen_statPathsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Paths Completed'**
  String get profileScreen_statPathsCompleted;

  /// No description provided for @profileScreen_statResourcesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Resources Completed'**
  String get profileScreen_statResourcesCompleted;

  /// No description provided for @profileScreen_usagePathsGenerated.
  ///
  /// In en, this message translates to:
  /// **'Paths Generated'**
  String get profileScreen_usagePathsGenerated;

  /// No description provided for @profileScreen_usagePathsExtended.
  ///
  /// In en, this message translates to:
  /// **'Paths Extended'**
  String get profileScreen_usagePathsExtended;

  /// No description provided for @profileScreen_usageUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get profileScreen_usageUnlimited;

  /// No description provided for @profileScreen_currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get profileScreen_currentPlan;

  /// No description provided for @profileScreen_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get profileScreen_upgrade;

  /// No description provided for @profileScreen_manageEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileScreen_manageEditProfile;

  /// No description provided for @profileScreen_manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileScreen_manageNotifications;

  /// No description provided for @profileScreen_manageAppearance.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileScreen_manageAppearance;

  /// No description provided for @profileScreen_manageLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileScreen_manageLanguage;

  /// No description provided for @profileScreen_tierFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get profileScreen_tierFree;

  /// No description provided for @profileScreen_daysLeft.
  ///
  /// In en, this message translates to:
  /// **'Your subscription ends on {date} ({count,plural, =1{1 day left}other{{count} days left}})'**
  String profileScreen_daysLeft(String date, int count);

  /// No description provided for @profileScreen_manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get profileScreen_manageSubscription;

  /// No description provided for @profileScreen_nameUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Name updated successfully!'**
  String get profileScreen_nameUpdateSuccess;

  /// No description provided for @profileScreen_statQuizzesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Quizzes Completed'**
  String get profileScreen_statQuizzesCompleted;

  /// No description provided for @profileScreen_usageQuizzesCreated.
  ///
  /// In en, this message translates to:
  /// **'Quizzes Created'**
  String get profileScreen_usageQuizzesCreated;

  /// No description provided for @subscriptionScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Your Learning'**
  String get subscriptionScreen_title;

  /// No description provided for @subscriptionScreen_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get subscriptionScreen_monthly;

  /// No description provided for @subscriptionScreen_yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly (Save ~30%)'**
  String get subscriptionScreen_yearly;

  /// No description provided for @subscriptionScreen_upgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get subscriptionScreen_upgradeNow;

  /// Snackbar message when a purchase is initiated.
  ///
  /// In en, this message translates to:
  /// **'Starting purchase for {tierTitle} ({duration})'**
  String subscriptionScreen_startingPurchase(String tierTitle, String duration);

  /// No description provided for @subscriptionScreen_tierPro_title.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get subscriptionScreen_tierPro_title;

  /// No description provided for @subscriptionScreen_tierPro_priceMonthly.
  ///
  /// In en, this message translates to:
  /// **'{price}/month'**
  String subscriptionScreen_tierPro_priceMonthly(String price);

  /// No description provided for @subscriptionScreen_tierPro_priceYearly.
  ///
  /// In en, this message translates to:
  /// **'{price}/year'**
  String subscriptionScreen_tierPro_priceYearly(String price);

  /// No description provided for @subscriptionScreen_tierPro_feature1.
  ///
  /// In en, this message translates to:
  /// **'{count} Path Generations/month'**
  String subscriptionScreen_tierPro_feature1(int count);

  /// No description provided for @subscriptionScreen_tierPro_feature2.
  ///
  /// In en, this message translates to:
  /// **'{count} Path Extensions/month'**
  String subscriptionScreen_tierPro_feature2(int count);

  /// No description provided for @subscriptionScreen_tierPro_feature3.
  ///
  /// In en, this message translates to:
  /// **'{count} Quizzes/month'**
  String subscriptionScreen_tierPro_feature3(int count);

  /// No description provided for @subscriptionScreen_tierUnlimited_title.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get subscriptionScreen_tierUnlimited_title;

  /// No description provided for @subscriptionScreen_tierUnlimited_priceMonthly.
  ///
  /// In en, this message translates to:
  /// **'{price}/month'**
  String subscriptionScreen_tierUnlimited_priceMonthly(String price);

  /// No description provided for @subscriptionScreen_tierUnlimited_priceYearly.
  ///
  /// In en, this message translates to:
  /// **'{price}/year'**
  String subscriptionScreen_tierUnlimited_priceYearly(String price);

  /// No description provided for @subscriptionScreen_tierUnlimited_feature1.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Path Generations'**
  String get subscriptionScreen_tierUnlimited_feature1;

  /// No description provided for @subscriptionScreen_tierUnlimited_feature2.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Path Extensions'**
  String get subscriptionScreen_tierUnlimited_feature2;

  /// No description provided for @subscriptionScreen_tierUnlimited_feature3.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Quizzes'**
  String get subscriptionScreen_tierUnlimited_feature3;

  /// No description provided for @subscriptionScreen_upgradeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Subscription updated successfully!'**
  String get subscriptionScreen_upgradeSuccess;

  /// No description provided for @subscriptionScreen_noPlansAvailable.
  ///
  /// In en, this message translates to:
  /// **'No subscription plans are available right now.'**
  String get subscriptionScreen_noPlansAvailable;

  /// No description provided for @subscriptionScreen_purchaseVerificationError.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful, but we couldn\'t verify it. Please try restoring purchases from the profile screen.'**
  String get subscriptionScreen_purchaseVerificationError;

  /// No description provided for @suggestionsScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestionsScreen_title;

  /// No description provided for @suggestionsScreen_errorAssigningPath.
  ///
  /// In en, this message translates to:
  /// **'Error assigning path: {error}'**
  String suggestionsScreen_errorAssigningPath(String error);

  /// Header text on the suggestions page.
  ///
  /// In en, this message translates to:
  /// **'We\'ve found some existing paths have been proven helpful to other users for \"{prompt}\". You can pick one of these or generate your own.'**
  String suggestionsScreen_header(String prompt);

  /// No description provided for @suggestionsScreen_generateMyOwnPath.
  ///
  /// In en, this message translates to:
  /// **'Generate My Own Path'**
  String get suggestionsScreen_generateMyOwnPath;

  /// No description provided for @rotatingHintTextField_suggestion1.
  ///
  /// In en, this message translates to:
  /// **'e.g. Learn guitar basics…'**
  String get rotatingHintTextField_suggestion1;

  /// No description provided for @rotatingHintTextField_suggestion2.
  ///
  /// In en, this message translates to:
  /// **'e.g. Start a course on public speaking…'**
  String get rotatingHintTextField_suggestion2;

  /// No description provided for @rotatingHintTextField_suggestion3.
  ///
  /// In en, this message translates to:
  /// **'e.g. Master Excel in 30 days…'**
  String get rotatingHintTextField_suggestion3;

  /// No description provided for @rotatingHintTextField_suggestion4.
  ///
  /// In en, this message translates to:
  /// **'e.g. Learn to cook Italian food…'**
  String get rotatingHintTextField_suggestion4;

  /// No description provided for @rotatingHintTextField_suggestion5.
  ///
  /// In en, this message translates to:
  /// **'e.g. Improve your photography skills…'**
  String get rotatingHintTextField_suggestion5;

  /// No description provided for @rotatingHintTextField_suggestion6.
  ///
  /// In en, this message translates to:
  /// **'e.g. Study for the SATs…'**
  String get rotatingHintTextField_suggestion6;

  /// No description provided for @rotatingHintTextField_suggestion7.
  ///
  /// In en, this message translates to:
  /// **'e.g. Learn French for travel…'**
  String get rotatingHintTextField_suggestion7;

  /// No description provided for @rotatingHintTextField_suggestion8.
  ///
  /// In en, this message translates to:
  /// **'e.g. Build a personal budget…'**
  String get rotatingHintTextField_suggestion8;

  /// No description provided for @rotatingHintTextField_suggestion9.
  ///
  /// In en, this message translates to:
  /// **'e.g. Practice meditation techniques…'**
  String get rotatingHintTextField_suggestion9;

  /// No description provided for @rotatingHintTextField_suggestion10.
  ///
  /// In en, this message translates to:
  /// **'e.g. Learn to code in Python...'**
  String get rotatingHintTextField_suggestion10;

  /// No description provided for @rotatingHintTextField_unlimitedGenerations.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Generations'**
  String get rotatingHintTextField_unlimitedGenerations;

  /// Text showing the remaining number of path generations.
  ///
  /// In en, this message translates to:
  /// **'{count} Path Generations Left'**
  String rotatingHintTextField_generationsLeft(int count);

  /// No description provided for @ratingScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Rating screen'**
  String get ratingScreen_title;

  /// No description provided for @ratingScreen_congratulationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations on finishing the \'{pathTitle}\' path!'**
  String ratingScreen_congratulationsTitle(String pathTitle);

  /// No description provided for @ratingScreen_callToAction.
  ///
  /// In en, this message translates to:
  /// **'Your rating helps other users find the best learning paths.'**
  String get ratingScreen_callToAction;

  /// No description provided for @ratingScreen_submitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit rating'**
  String get ratingScreen_submitRating;

  /// No description provided for @ratingScreen_noThanks.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get ratingScreen_noThanks;

  /// No description provided for @ratingScreen_thankYouTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get ratingScreen_thankYouTitle;

  /// No description provided for @notificationsScreen_learningReminders.
  ///
  /// In en, this message translates to:
  /// **'Learning Reminders'**
  String get notificationsScreen_learningReminders;

  /// No description provided for @notificationsScreen_learningRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications for unfinished paths'**
  String get notificationsScreen_learningRemindersDesc;

  /// No description provided for @reportScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get reportScreen_title;

  /// No description provided for @reportScreen_question.
  ///
  /// In en, this message translates to:
  /// **'What is the problem?'**
  String get reportScreen_question;

  /// No description provided for @reportScreen_optionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Optional Details'**
  String get reportScreen_optionalDetails;

  /// No description provided for @reportScreen_detailsHint.
  ///
  /// In en, this message translates to:
  /// **'Provide more details about the issue...'**
  String get reportScreen_detailsHint;

  /// No description provided for @reportScreen_submitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get reportScreen_submitButton;

  /// No description provided for @reportScreen_submitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report submitted successfully. Thank you!'**
  String get reportScreen_submitSuccess;

  /// No description provided for @reportScreen_typeInaccurate.
  ///
  /// In en, this message translates to:
  /// **'Inaccurate Content'**
  String get reportScreen_typeInaccurate;

  /// No description provided for @reportScreen_typeBrokenLinks.
  ///
  /// In en, this message translates to:
  /// **'Broken or Incorrect Links'**
  String get reportScreen_typeBrokenLinks;

  /// No description provided for @reportScreen_typeInappropriate.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate Content'**
  String get reportScreen_typeInappropriate;

  /// No description provided for @reportScreen_typeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reportScreen_typeOther;

  /// No description provided for @reportStatusScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Report Status'**
  String get reportStatusScreen_title;

  /// No description provided for @reportStatusScreen_noReportFound.
  ///
  /// In en, this message translates to:
  /// **'No report found for this path.'**
  String get reportStatusScreen_noReportFound;

  /// No description provided for @reportStatusScreen_statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String reportStatusScreen_statusLabel(String status);

  /// No description provided for @reportStatusScreen_resolvedMessageDefault.
  ///
  /// In en, this message translates to:
  /// **'This issue has been reviewed and resolved. Thank you for your feedback!'**
  String get reportStatusScreen_resolvedMessageDefault;

  /// No description provided for @reportStatusScreen_submittedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your report has been submitted and will be reviewed soon. Thank you for helping us improve!'**
  String get reportStatusScreen_submittedMessage;

  /// No description provided for @reportStatusScreen_acknowledgeButton.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge & Close'**
  String get reportStatusScreen_acknowledgeButton;

  /// No description provided for @reportStatus_submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get reportStatus_submitted;

  /// No description provided for @reportStatus_inReview.
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get reportStatus_inReview;

  /// No description provided for @reportStatus_resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get reportStatus_resolved;

  /// No description provided for @reportStatus_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get reportStatus_unknown;

  /// No description provided for @quizHistoryScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Quiz History'**
  String get quizHistoryScreen_title;

  /// No description provided for @quizHistoryScreen_noQuizzesTaken.
  ///
  /// In en, this message translates to:
  /// **'No quizzes taken yet.'**
  String get quizHistoryScreen_noQuizzesTaken;

  /// No description provided for @quizHistoryScreen_cta.
  ///
  /// In en, this message translates to:
  /// **'Test your knowledge by creating a new quiz!'**
  String get quizHistoryScreen_cta;

  /// No description provided for @quizHistoryScreen_createQuizButton.
  ///
  /// In en, this message translates to:
  /// **'Create a New Quiz'**
  String get quizHistoryScreen_createQuizButton;

  /// No description provided for @quizHistoryScreen_createAnotherQuizButton.
  ///
  /// In en, this message translates to:
  /// **'Take Another Quiz'**
  String get quizHistoryScreen_createAnotherQuizButton;

  /// No description provided for @quizHistoryScreen_score.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}/{total}'**
  String quizHistoryScreen_score(int score, int total);

  /// No description provided for @quizHistoryScreen_takenOn.
  ///
  /// In en, this message translates to:
  /// **'Taken on: {date}'**
  String quizHistoryScreen_takenOn(String date);

  /// No description provided for @quizHistoryScreen_quizInProgress.
  ///
  /// In en, this message translates to:
  /// **'Quiz in Progress'**
  String get quizHistoryScreen_quizInProgress;

  /// No description provided for @quizScreen_failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load quiz.'**
  String get quizScreen_failedToLoad;

  /// No description provided for @quizScreen_questionOf.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quizScreen_questionOf(int current, int total);

  /// No description provided for @quizScreen_nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get quizScreen_nextQuestion;

  /// No description provided for @quizScreen_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get quizScreen_submit;

  /// No description provided for @quizScreen_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get quizScreen_back;

  /// No description provided for @quizScreen_quizComplete.
  ///
  /// In en, this message translates to:
  /// **'Quiz Complete!'**
  String get quizScreen_quizComplete;

  /// No description provided for @quizScreen_yourScore.
  ///
  /// In en, this message translates to:
  /// **'Your Score:'**
  String get quizScreen_yourScore;

  /// No description provided for @quizScreen_backToPath.
  ///
  /// In en, this message translates to:
  /// **'Back to Path'**
  String get quizScreen_backToPath;

  /// No description provided for @quizScreen_loadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Generating your custom quiz...'**
  String get quizScreen_loadingTitle;

  /// No description provided for @quizScreen_resumingTitle.
  ///
  /// In en, this message translates to:
  /// **'Resuming your quiz...'**
  String get quizScreen_resumingTitle;

  /// No description provided for @quizReviewScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get quizReviewScreen_title;

  /// No description provided for @quizReviewScreen_reviewAnswersButton.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get quizReviewScreen_reviewAnswersButton;

  /// No description provided for @quizScreen_loadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our AI is preparing a set of questions to test your knowledge. This may take a few moments.'**
  String get quizScreen_loadingSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
