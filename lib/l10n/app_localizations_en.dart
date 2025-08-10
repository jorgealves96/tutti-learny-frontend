// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get generatingPathsScreen_craftingPersonalizedLearningPath =>
      'Crafting your personalized learning path';

  @override
  String get generatingPathsScreen_loadingPathGenerationMessage =>
      'Our AI is working hard to create a curriculum tailored to your goals and learning style. This may take a few moments.';

  @override
  String get homeScreen_pleaseEnterATopic =>
      'Please enter a topic to generate a path.';

  @override
  String get homeScreen_usageLimitReached => 'Usage Limit Reached';

  @override
  String get homeScreen_maybeLater => 'Maybe Later';

  @override
  String get homeScreen_upgrade => 'Upgrade';

  @override
  String get homeScreen_namePlaceholder => 'there';

  @override
  String get homeScreen_hi => 'Hi ';

  @override
  String get homeScreen_callToActionMsg =>
      ',\nwhat do you want to learn today?';

  @override
  String get homeScreen_createLearningPath => 'Create Learning Path';

  @override
  String get homeScreen_recentlyCreatedPaths => 'Recently Created Paths';

  @override
  String get homeScreen_pathCreatedSuccess => 'Path created successfully!';

  @override
  String get loginScreen_welcomePrimary => 'Welcome to';

  @override
  String get loginScreen_welcomeSecondary =>
      'Your personal guide to learn anything.';

  @override
  String get loginScreen_continueWithGoogle => 'Continue with Google';

  @override
  String get loginScreen_failedToSignInGoogle =>
      'Failed to sign in with Google.';

  @override
  String get loginScreen_continueWithPhoneNumber =>
      'Continue with Phone Number';

  @override
  String get mainScreen_labelMyPaths => 'My Paths';

  @override
  String get mainScreen_labelHome => 'Home';

  @override
  String get mainScreen_labelProfile => 'Profile';

  @override
  String get mainScreen_tryAgain => 'Try Again';

  @override
  String get myPathsScreen_noPathsCreatedYet => 'No paths created yet';

  @override
  String get myPathsScreen_createANewPath => 'Create a New Path';

  @override
  String pathDetailScreen_error(String error) {
    return 'Error: $error';
  }

  @override
  String get pathDetailScreen_pathNotFound => 'Path not found.';

  @override
  String get pathDetailScreen_usageLimitReached => 'Usage Limit Reached';

  @override
  String get pathDetailScreen_maybeLater => 'Maybe Later';

  @override
  String get pathDetailScreen_upgrade => 'Upgrade';

  @override
  String get pathDetailScreen_pathCompleted =>
      'Congratulations! You have completed this path.';

  @override
  String pathDetailScreen_failedToExtendPath(String error) {
    return 'Failed to extend path: $error';
  }

  @override
  String pathDetailScreen_failedToUpdateTask(String error) {
    return 'Failed to update task: $error';
  }

  @override
  String pathDetailScreen_failedToUpdateResource(String error) {
    return 'Failed to update resource: $error';
  }

  @override
  String get pathDetailScreen_noLinkAvailable =>
      'This resource has no link available.';

  @override
  String get pathDetailScreen_deletePathTitle => 'Delete Path';

  @override
  String get pathDetailScreen_deletePathConfirm =>
      'Are you sure you want to permanently delete this learning path?';

  @override
  String get pathDetailScreen_cancel => 'Cancel';

  @override
  String get pathDetailScreen_delete => 'Delete';

  @override
  String pathDetailScreen_failedToDeletePath(String error) {
    return 'Failed to delete path: $error';
  }

  @override
  String get pathDetailScreen_pathIsComplete => 'Path Complete!';

  @override
  String get pathDetailScreen_generating => 'Generating...';

  @override
  String get pathDetailScreen_extendPath => 'Extend Path';

  @override
  String get pathDetailScreen_pathExtendedSuccess =>
      'Path extended successfully!';

  @override
  String get pathDetailScreen_checkReportStatus => 'Check report status';

  @override
  String get pathDetailScreen_reportProblem => 'Report A Problem';

  @override
  String get pathDetailScreen_testYourKnowledge => 'Test Your Knowledge';

  @override
  String get phoneLoginScreen_enterPhoneNumberTitle =>
      'Enter Your Phone Number';

  @override
  String get phoneLoginScreen_enterVerificationCodeTitle =>
      'Enter Verification Code';

  @override
  String get phoneLoginScreen_enterPhoneNumberSubtitle =>
      'Select your country and enter your phone number.';

  @override
  String phoneLoginScreen_codeSentSubtitle(String fullPhoneNumber) {
    return 'A 6-digit code was sent to $fullPhoneNumber';
  }

  @override
  String get phoneLoginScreen_phoneNumberLabel => 'Phone Number';

  @override
  String get phoneLoginScreen_otpLabel => '6-Digit Code';

  @override
  String get phoneLoginScreen_sendCode => 'Send Code';

  @override
  String get phoneLoginScreen_verifyCode => 'Verify Code';

  @override
  String get phoneLoginScreen_pleaseEnterPhoneNumber =>
      'Please enter a phone number.';

  @override
  String phoneLoginScreen_failedToSendCode(String error) {
    return 'Failed to send code: $error';
  }

  @override
  String phoneLoginScreen_anErrorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get phoneLoginScreen_invalidCode => 'Invalid code. Please try again.';

  @override
  String get phoneLoginScreen_verifyingAutomatically =>
      'Verifying automatically...';

  @override
  String get profileScreen_editName => 'Edit Name';

  @override
  String get profileScreen_enterYourName => 'Enter your name';

  @override
  String get profileScreen_cancel => 'Cancel';

  @override
  String get profileScreen_save => 'Save';

  @override
  String profileScreen_failedToUpdateName(String error) {
    return 'Failed to update name: $error';
  }

  @override
  String get profileScreen_logout => 'Logout';

  @override
  String get profileScreen_logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get profileScreen_deleteAccount => 'Delete Account';

  @override
  String get profileScreen_deleteAccountConfirm =>
      'Are you sure you want to permanently delete your account? This action cannot be undone.';

  @override
  String get profileScreen_delete => 'Delete';

  @override
  String get profileScreen_user => 'User';

  @override
  String profileScreen_joined(String date) {
    return 'Joined $date';
  }

  @override
  String get profileScreen_sectionLearningStatistics => 'Learning Statistics';

  @override
  String get profileScreen_sectionSubscription => 'Subscription';

  @override
  String get profileScreen_sectionMonthlyUsage => 'Monthly Usage';

  @override
  String get profileScreen_sectionAccountManagement => 'Account Management';

  @override
  String get profileScreen_statPathsStarted => 'Paths Started';

  @override
  String get profileScreen_statPathsCompleted => 'Paths Completed';

  @override
  String get profileScreen_statResourcesCompleted => 'Resources Completed';

  @override
  String get profileScreen_usagePathsGenerated => 'Paths Generated';

  @override
  String get profileScreen_usagePathsExtended => 'Paths Extended';

  @override
  String get profileScreen_usageUnlimited => 'Unlimited';

  @override
  String get profileScreen_currentPlan => 'Current Plan';

  @override
  String get profileScreen_upgrade => 'Upgrade';

  @override
  String get profileScreen_manageEditProfile => 'Edit Profile';

  @override
  String get profileScreen_manageNotifications => 'Notifications';

  @override
  String get profileScreen_manageAppearance => 'Theme';

  @override
  String get profileScreen_manageLanguage => 'Language';

  @override
  String get profileScreen_tierFree => 'Free';

  @override
  String profileScreen_daysLeft(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return 'Your subscription ends on $date ($_temp0)';
  }

  @override
  String get profileScreen_manageSubscription => 'Manage';

  @override
  String get profileScreen_nameUpdateSuccess => 'Name updated successfully!';

  @override
  String get profileScreen_statQuizzesCompleted => 'Quizzes Completed';

  @override
  String get profileScreen_usageQuizzesCreated => 'Quizzes Created';

  @override
  String get subscriptionScreen_title => 'Upgrade Your Learning';

  @override
  String get subscriptionScreen_monthly => 'Monthly';

  @override
  String get subscriptionScreen_yearly => 'Yearly (Save ~30%)';

  @override
  String get subscriptionScreen_upgradeNow => 'Upgrade Now';

  @override
  String subscriptionScreen_startingPurchase(
    String tierTitle,
    String duration,
  ) {
    return 'Starting purchase for $tierTitle ($duration)';
  }

  @override
  String get subscriptionScreen_tierPro_title => 'Pro';

  @override
  String subscriptionScreen_tierPro_priceMonthly(String price) {
    return '$price/month';
  }

  @override
  String subscriptionScreen_tierPro_priceYearly(String price) {
    return '$price/year';
  }

  @override
  String subscriptionScreen_tierPro_feature1(int count) {
    return '$count Path Generations/month';
  }

  @override
  String subscriptionScreen_tierPro_feature2(int count) {
    return '$count Path Extensions/month';
  }

  @override
  String subscriptionScreen_tierPro_feature3(int count) {
    return '$count Quizzes/month';
  }

  @override
  String get subscriptionScreen_tierUnlimited_title => 'Unlimited';

  @override
  String subscriptionScreen_tierUnlimited_priceMonthly(String price) {
    return '$price/month';
  }

  @override
  String subscriptionScreen_tierUnlimited_priceYearly(String price) {
    return '$price/year';
  }

  @override
  String get subscriptionScreen_tierUnlimited_feature1 =>
      'Unlimited Path Generations';

  @override
  String get subscriptionScreen_tierUnlimited_feature2 =>
      'Unlimited Path Extensions';

  @override
  String get subscriptionScreen_tierUnlimited_feature3 => 'Unlimited Quizzes';

  @override
  String get subscriptionScreen_upgradeSuccess =>
      'Subscription updated successfully!';

  @override
  String get subscriptionScreen_noPlansAvailable =>
      'No subscription plans are available right now.';

  @override
  String get subscriptionScreen_purchaseVerificationError =>
      'Purchase successful, but we couldn\'t verify it. Please try restoring purchases from the profile screen.';

  @override
  String get suggestionsScreen_title => 'Suggestions';

  @override
  String suggestionsScreen_errorAssigningPath(String error) {
    return 'Error assigning path: $error';
  }

  @override
  String suggestionsScreen_header(String prompt) {
    return 'We\'ve found some existing paths have been proven helpful to other users for \"$prompt\". You can pick one of these or generate your own.';
  }

  @override
  String get suggestionsScreen_generateMyOwnPath => 'Generate My Own Path';

  @override
  String get rotatingHintTextField_suggestion1 => 'e.g. Learn guitar basics…';

  @override
  String get rotatingHintTextField_suggestion2 =>
      'e.g. Start a course on public speaking…';

  @override
  String get rotatingHintTextField_suggestion3 =>
      'e.g. Master Excel in 30 days…';

  @override
  String get rotatingHintTextField_suggestion4 =>
      'e.g. Learn to cook Italian food…';

  @override
  String get rotatingHintTextField_suggestion5 =>
      'e.g. Improve your photography skills…';

  @override
  String get rotatingHintTextField_suggestion6 => 'e.g. Study for the SATs…';

  @override
  String get rotatingHintTextField_suggestion7 =>
      'e.g. Learn French for travel…';

  @override
  String get rotatingHintTextField_suggestion8 =>
      'e.g. Build a personal budget…';

  @override
  String get rotatingHintTextField_suggestion9 =>
      'e.g. Practice meditation techniques…';

  @override
  String get rotatingHintTextField_suggestion10 =>
      'e.g. Learn to code in Python...';

  @override
  String get rotatingHintTextField_unlimitedGenerations =>
      'Unlimited Generations';

  @override
  String rotatingHintTextField_generationsLeft(int count) {
    return '$count Path Generations Left';
  }

  @override
  String get ratingScreen_title => 'Rating screen';

  @override
  String ratingScreen_congratulationsTitle(String pathTitle) {
    return 'Congratulations on finishing the \'$pathTitle\' path!';
  }

  @override
  String get ratingScreen_callToAction =>
      'Your rating helps other users find the best learning paths.';

  @override
  String get ratingScreen_submitRating => 'Submit rating';

  @override
  String get ratingScreen_noThanks => 'No thanks';

  @override
  String get ratingScreen_thankYouTitle => 'Thank you for your feedback!';

  @override
  String get notificationsScreen_learningReminders => 'Learning Reminders';

  @override
  String get notificationsScreen_learningRemindersDesc =>
      'Receive notifications for unfinished paths';

  @override
  String get notificationsScreen_generalAnnouncements =>
      'General Announcements';

  @override
  String get notificationsScreen_generalAnnouncementsSubtitle =>
      'Receive occasional news and updates about the app.';

  @override
  String get reportScreen_title => 'Report a Problem';

  @override
  String get reportScreen_question => 'What is the problem?';

  @override
  String get reportScreen_optionalDetails => 'Optional Details';

  @override
  String get reportScreen_detailsHint =>
      'Provide more details about the issue...';

  @override
  String get reportScreen_submitButton => 'Submit Report';

  @override
  String get reportScreen_submitSuccess =>
      'Report submitted successfully. Thank you!';

  @override
  String get reportScreen_typeInaccurate => 'Inaccurate Content';

  @override
  String get reportScreen_typeBrokenLinks => 'Broken or Incorrect Links';

  @override
  String get reportScreen_typeInappropriate => 'Inappropriate Content';

  @override
  String get reportScreen_typeOther => 'Other';

  @override
  String get reportStatusScreen_title => 'Report Status';

  @override
  String get reportStatusScreen_noReportFound =>
      'No report found for this path.';

  @override
  String reportStatusScreen_statusLabel(String status) {
    return 'Status: $status';
  }

  @override
  String get reportStatusScreen_resolvedMessageDefault =>
      'This issue has been reviewed and resolved. Thank you for your feedback!';

  @override
  String get reportStatusScreen_submittedMessage =>
      'Your report has been submitted and will be reviewed soon. Thank you for helping us improve!';

  @override
  String get reportStatusScreen_acknowledgeButton => 'Acknowledge & Close';

  @override
  String get reportStatus_submitted => 'Submitted';

  @override
  String get reportStatus_inReview => 'In Review';

  @override
  String get reportStatus_resolved => 'Resolved';

  @override
  String get reportStatus_unknown => 'Unknown';

  @override
  String get quizHistoryScreen_title => 'Quiz History';

  @override
  String get quizHistoryScreen_noQuizzesTaken => 'No quizzes taken yet.';

  @override
  String get quizHistoryScreen_cta =>
      'Test your knowledge by creating a new quiz!';

  @override
  String get quizHistoryScreen_createQuizButton => 'Create a New Quiz';

  @override
  String get quizHistoryScreen_createAnotherQuizButton => 'Take Another Quiz';

  @override
  String quizHistoryScreen_score(int score, int total) {
    return 'Score: $score/$total';
  }

  @override
  String quizHistoryScreen_takenOn(String date) {
    return 'Taken on: $date';
  }

  @override
  String get quizHistoryScreen_quizInProgress => 'Quiz in Progress';

  @override
  String get quizScreen_failedToLoad => 'Failed to load quiz.';

  @override
  String quizScreen_questionOf(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get quizScreen_nextQuestion => 'Next Question';

  @override
  String get quizScreen_submit => 'Submit';

  @override
  String get quizScreen_back => 'Back';

  @override
  String get quizScreen_quizComplete => 'Quiz Complete!';

  @override
  String get quizScreen_yourScore => 'Your Score:';

  @override
  String get quizScreen_backToPath => 'Back to Path';

  @override
  String get quizScreen_loadingTitle => 'Generating your custom quiz...';

  @override
  String get quizScreen_resumingTitle => 'Resuming your quiz...';

  @override
  String get quizReviewScreen_title => 'Review Answers';

  @override
  String get quizReviewScreen_reviewAnswersButton => 'Review Answers';

  @override
  String get quizScreen_loadingSubtitle =>
      'Our AI is preparing a set of questions to test your knowledge. This may take a few moments.';
}
