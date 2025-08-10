// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get generatingPathsScreen_craftingPersonalizedLearningPath =>
      'Création de votre parcours d\'apprentissage personnalisé';

  @override
  String get generatingPathsScreen_loadingPathGenerationMessage =>
      'Notre IA travaille à créer un programme adapté à vos objectifs et à votre style d\'apprentissage. Cela peut prendre quelques instants.';

  @override
  String get homeScreen_pleaseEnterATopic =>
      'Veuillez entrer un sujet pour générer un parcours.';

  @override
  String get homeScreen_usageLimitReached => 'Limite d\'Utilisation Atteinte';

  @override
  String get homeScreen_maybeLater => 'Peut-être plus tard';

  @override
  String get homeScreen_upgrade => 'Mettre à niveau';

  @override
  String get homeScreen_namePlaceholder => '';

  @override
  String get homeScreen_hi => 'Salut ';

  @override
  String get homeScreen_callToActionMsg =>
      ',\nqu\'est-ce que tu veux apprendre aujourd\'hui ?';

  @override
  String get homeScreen_createLearningPath =>
      'Créer un Parcours d\'Apprentissage';

  @override
  String get homeScreen_recentlyCreatedPaths => 'Parcours Récemment Créés';

  @override
  String get homeScreen_pathCreatedSuccess => 'Parcours créé avec succès !';

  @override
  String get loginScreen_welcomePrimary => 'Bienvenue sur';

  @override
  String get loginScreen_welcomeSecondary =>
      'Votre guide personnel pour tout apprendre.';

  @override
  String get loginScreen_continueWithGoogle => 'Continuer avec Google';

  @override
  String get loginScreen_failedToSignInGoogle =>
      'Échec de la connexion avec Google.';

  @override
  String get loginScreen_continueWithPhoneNumber =>
      'Continuer avec un numéro de téléphone';

  @override
  String get mainScreen_labelMyPaths => 'Mes Parcours';

  @override
  String get mainScreen_labelHome => 'Accueil';

  @override
  String get mainScreen_labelProfile => 'Profil';

  @override
  String get mainScreen_tryAgain => 'Réessayer';

  @override
  String get myPathsScreen_noPathsCreatedYet =>
      'Aucun parcours créé pour le moment';

  @override
  String get myPathsScreen_createANewPath => 'Créer un Nouveau Parcours';

  @override
  String pathDetailScreen_error(String error) {
    return 'Erreur : $error';
  }

  @override
  String get pathDetailScreen_pathNotFound => 'Parcours non trouvé.';

  @override
  String get pathDetailScreen_usageLimitReached =>
      'Limite d\'utilisation atteinte';

  @override
  String get pathDetailScreen_maybeLater => 'Peut-être plus tard';

  @override
  String get pathDetailScreen_upgrade => 'Mettre à niveau';

  @override
  String get pathDetailScreen_pathCompleted =>
      'Félicitations ! Vous avez terminé ce parcours.';

  @override
  String pathDetailScreen_failedToExtendPath(String error) {
    return 'Échec de l\'extension du parcours : $error';
  }

  @override
  String pathDetailScreen_failedToUpdateTask(String error) {
    return 'Échec de la mise à jour de la tâche : $error';
  }

  @override
  String pathDetailScreen_failedToUpdateResource(String error) {
    return 'Échec de la mise à jour de la ressource : $error';
  }

  @override
  String get pathDetailScreen_noLinkAvailable =>
      'Cette ressource n\'a pas de lien disponible.';

  @override
  String get pathDetailScreen_deletePathTitle => 'Supprimer le Parcours';

  @override
  String get pathDetailScreen_deletePathConfirm =>
      'Êtes-vous sûr de vouloir supprimer définitivement ce parcours d\'apprentissage ?';

  @override
  String get pathDetailScreen_cancel => 'Annuler';

  @override
  String get pathDetailScreen_delete => 'Supprimer';

  @override
  String pathDetailScreen_failedToDeletePath(String error) {
    return 'Échec de la suppression du parcours : $error';
  }

  @override
  String get pathDetailScreen_pathIsComplete => 'Parcours Terminé !';

  @override
  String get pathDetailScreen_generating => 'Génération...';

  @override
  String get pathDetailScreen_extendPath => 'Prolonger le Parcours';

  @override
  String get pathDetailScreen_pathExtendedSuccess =>
      'Parcours étendu avec succès !';

  @override
  String get pathDetailScreen_checkReportStatus =>
      'Vérifier le statut du signalement';

  @override
  String get pathDetailScreen_reportProblem => 'Signaler un problème';

  @override
  String get pathDetailScreen_testYourKnowledge => 'Testez vos connaissances';

  @override
  String get phoneLoginScreen_enterPhoneNumberTitle =>
      'Entrez votre numéro de téléphone';

  @override
  String get phoneLoginScreen_enterVerificationCodeTitle =>
      'Entrez le code de vérification';

  @override
  String get phoneLoginScreen_enterPhoneNumberSubtitle =>
      'Sélectionnez votre pays et entrez votre numéro de téléphone.';

  @override
  String phoneLoginScreen_codeSentSubtitle(String fullPhoneNumber) {
    return 'Un code à 6 chiffres a été envoyé au $fullPhoneNumber';
  }

  @override
  String get phoneLoginScreen_phoneNumberLabel => 'Numéro de téléphone';

  @override
  String get phoneLoginScreen_otpLabel => 'Code à 6 chiffres';

  @override
  String get phoneLoginScreen_sendCode => 'Envoyer le code';

  @override
  String get phoneLoginScreen_verifyCode => 'Vérifier le code';

  @override
  String get phoneLoginScreen_pleaseEnterPhoneNumber =>
      'Veuillez entrer un numéro de téléphone.';

  @override
  String phoneLoginScreen_failedToSendCode(String error) {
    return 'Échec de l\'envoi du code : $error';
  }

  @override
  String phoneLoginScreen_anErrorOccurred(String error) {
    return 'Une erreur est survenue : $error';
  }

  @override
  String get phoneLoginScreen_invalidCode =>
      'Code invalide. Veuillez réessayer.';

  @override
  String get phoneLoginScreen_verifyingAutomatically =>
      'Vérification automatique...';

  @override
  String get profileScreen_editName => 'Modifier le nom';

  @override
  String get profileScreen_enterYourName => 'Entrez votre nom';

  @override
  String get profileScreen_cancel => 'Annuler';

  @override
  String get profileScreen_save => 'Enregistrer';

  @override
  String profileScreen_failedToUpdateName(String error) {
    return 'Échec de la mise à jour du nom : $error';
  }

  @override
  String get profileScreen_logout => 'Déconnexion';

  @override
  String get profileScreen_logoutConfirm =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get profileScreen_deleteAccount => 'Supprimer le compte';

  @override
  String get profileScreen_deleteAccountConfirm =>
      'Êtes-vous sûr de vouloir supprimer définitivement votre compte ? Cette action est irréversible.';

  @override
  String get profileScreen_delete => 'Supprimer';

  @override
  String get profileScreen_user => 'Utilisateur';

  @override
  String profileScreen_joined(String date) {
    return 'Membre depuis $date';
  }

  @override
  String get profileScreen_sectionLearningStatistics =>
      'Statistiques d\'Apprentissage';

  @override
  String get profileScreen_sectionSubscription => 'Abonnement';

  @override
  String get profileScreen_sectionMonthlyUsage => 'Utilisation Mensuelle';

  @override
  String get profileScreen_sectionAccountManagement => 'Gestion du Compte';

  @override
  String get profileScreen_statPathsStarted => 'Parcours Commencés';

  @override
  String get profileScreen_statPathsCompleted => 'Parcours Terminés';

  @override
  String get profileScreen_statResourcesCompleted => 'Ressources Terminées';

  @override
  String get profileScreen_usagePathsGenerated => 'Parcours Générés';

  @override
  String get profileScreen_usagePathsExtended => 'Parcours Prolongés';

  @override
  String get profileScreen_usageUnlimited => 'Illimité';

  @override
  String get profileScreen_currentPlan => 'Plan Actuel';

  @override
  String get profileScreen_upgrade => 'Améliorer';

  @override
  String get profileScreen_manageEditProfile => 'Modifier le Profil';

  @override
  String get profileScreen_manageNotifications => 'Notifications';

  @override
  String get profileScreen_manageAppearance => 'Thème';

  @override
  String get profileScreen_manageLanguage => 'Langue';

  @override
  String get profileScreen_tierFree => 'Gratuit';

  @override
  String profileScreen_daysLeft(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours restants',
      one: '1 jour restant',
    );
    return 'Votre abonnement se termine le $date ($_temp0)';
  }

  @override
  String get profileScreen_manageSubscription => 'Gérer';

  @override
  String get profileScreen_nameUpdateSuccess => 'Nom mis à jour avec succès !';

  @override
  String get profileScreen_statQuizzesCompleted => 'Quiz Terminés';

  @override
  String get profileScreen_usageQuizzesCreated => 'Quiz Créés';

  @override
  String get subscriptionScreen_title => 'Améliorez Votre Apprentissage';

  @override
  String get subscriptionScreen_monthly => 'Mensuel';

  @override
  String get subscriptionScreen_yearly => 'Annuel (Économisez ~30%)';

  @override
  String get subscriptionScreen_upgradeNow => 'Mettre à niveau maintenant';

  @override
  String subscriptionScreen_startingPurchase(
    String tierTitle,
    String duration,
  ) {
    return 'Début de l\'achat pour $tierTitle ($duration)';
  }

  @override
  String get subscriptionScreen_tierPro_title => 'Pro';

  @override
  String subscriptionScreen_tierPro_priceMonthly(String price) {
    return '$price/mois';
  }

  @override
  String subscriptionScreen_tierPro_priceYearly(String price) {
    return '$price/an';
  }

  @override
  String subscriptionScreen_tierPro_feature1(int count) {
    return '$count Générations de parcours/mois';
  }

  @override
  String subscriptionScreen_tierPro_feature2(int count) {
    return '$count Extensions de parcours/mois';
  }

  @override
  String subscriptionScreen_tierPro_feature3(int count) {
    return '$count Quiz/mois';
  }

  @override
  String get subscriptionScreen_tierUnlimited_title => 'Illimité';

  @override
  String subscriptionScreen_tierUnlimited_priceMonthly(String price) {
    return '$price/mois';
  }

  @override
  String subscriptionScreen_tierUnlimited_priceYearly(String price) {
    return '$price/an';
  }

  @override
  String get subscriptionScreen_tierUnlimited_feature1 =>
      'Générations de parcours illimitées';

  @override
  String get subscriptionScreen_tierUnlimited_feature2 =>
      'Extensions de parcours illimitées';

  @override
  String get subscriptionScreen_tierUnlimited_feature3 => 'Quiz illimités';

  @override
  String get subscriptionScreen_upgradeSuccess =>
      'Abonnement mis à jour avec succès !';

  @override
  String get subscriptionScreen_noPlansAvailable =>
      'Aucun plan d\'abonnement n\'est disponible pour le moment.';

  @override
  String get subscriptionScreen_purchaseVerificationError =>
      'Achat réussi, mais nous n\'avons pas pu le vérifier. Veuillez essayer de restaurer les achats depuis l\'écran de profil.';

  @override
  String get suggestionsScreen_title => 'Suggestions';

  @override
  String suggestionsScreen_errorAssigningPath(String error) {
    return 'Erreur lors de l\'assignation du parcours : $error';
  }

  @override
  String suggestionsScreen_header(String prompt) {
    return 'Nous avons trouvé des parcours existants qui se sont avérés utiles pour d\'autres utilisateurs pour \"$prompt\". Vous pouvez en choisir un ou générer le vôtre.';
  }

  @override
  String get suggestionsScreen_generateMyOwnPath =>
      'Générer mon propre parcours';

  @override
  String get rotatingHintTextField_suggestion1 =>
      'ex. Apprendre les bases de la guitare…';

  @override
  String get rotatingHintTextField_suggestion2 =>
      'ex. Commencer un cours d\'art oratoire…';

  @override
  String get rotatingHintTextField_suggestion3 =>
      'ex. Maîtriser Excel en 30 jours…';

  @override
  String get rotatingHintTextField_suggestion4 =>
      'ex. Apprendre à cuisiner italien…';

  @override
  String get rotatingHintTextField_suggestion5 =>
      'ex. Améliorer mes compétences en photographie…';

  @override
  String get rotatingHintTextField_suggestion6 =>
      'ex. Étudier pour le baccalauréat…';

  @override
  String get rotatingHintTextField_suggestion7 =>
      'ex. Apprendre le anglais pour voyager…';

  @override
  String get rotatingHintTextField_suggestion8 =>
      'ex. Établir un budget personnel…';

  @override
  String get rotatingHintTextField_suggestion9 =>
      'ex. Pratiquer des techniques de méditation…';

  @override
  String get rotatingHintTextField_suggestion10 =>
      'ex. Apprendre à coder en Python...';

  @override
  String get rotatingHintTextField_unlimitedGenerations =>
      'Générations Illimitées';

  @override
  String rotatingHintTextField_generationsLeft(int count) {
    return '$count Générations de parcours restantes';
  }

  @override
  String get ratingScreen_title => 'Évaluer le Parcours';

  @override
  String ratingScreen_congratulationsTitle(String pathTitle) {
    return 'Félicitations pour avoir terminé le parcours \'$pathTitle\' !';
  }

  @override
  String get ratingScreen_callToAction =>
      'Votre évaluation aide les autres utilisateurs à trouver les meilleurs parcours d\'apprentissage.';

  @override
  String get ratingScreen_submitRating => 'Envoyer l\'évaluation';

  @override
  String get ratingScreen_noThanks => 'Non, merci';

  @override
  String get ratingScreen_thankYouTitle => 'Merci pour votre retour !';

  @override
  String get notificationsScreen_learningReminders =>
      'Rappels d\'Apprentissage';

  @override
  String get notificationsScreen_learningRemindersDesc =>
      'Recevoir des notifications pour les parcours non terminés';

  @override
  String get notificationsScreen_generalAnnouncements => 'Annonces Générales';

  @override
  String get notificationsScreen_generalAnnouncementsSubtitle =>
      'Recevez des nouvelles et des mises à jour occasionnelles sur l\'application.';

  @override
  String get reportScreen_title => 'Signaler un Problème';

  @override
  String get reportScreen_question => 'Quel est le problème ?';

  @override
  String get reportScreen_optionalDetails => 'Détails Optionnels';

  @override
  String get reportScreen_detailsHint =>
      'Fournissez plus de détails sur le problème...';

  @override
  String get reportScreen_submitButton => 'Envoyer le Signalement';

  @override
  String get reportScreen_submitSuccess =>
      'Signalement envoyé avec succès. Merci !';

  @override
  String get reportScreen_typeInaccurate => 'Contenu Inexact';

  @override
  String get reportScreen_typeBrokenLinks => 'Liens Incorrects ou Inactifs';

  @override
  String get reportScreen_typeInappropriate => 'Contenu Inapproprié';

  @override
  String get reportScreen_typeOther => 'Autre';

  @override
  String get reportStatusScreen_title => 'Statut du Signalement';

  @override
  String get reportStatusScreen_noReportFound =>
      'Aucun signalement trouvé pour ce parcours.';

  @override
  String reportStatusScreen_statusLabel(String status) {
    return 'Statut : $status';
  }

  @override
  String get reportStatusScreen_resolvedMessageDefault =>
      'Ce problème a été examiné et résolu. Merci pour votre retour !';

  @override
  String get reportStatusScreen_submittedMessage =>
      'Votre signalement a été soumis et sera examiné bientôt. Merci de nous aider à nous améliorer !';

  @override
  String get reportStatusScreen_acknowledgeButton => 'Confirmer et Fermer';

  @override
  String get reportStatus_submitted => 'Soumis';

  @override
  String get reportStatus_inReview => 'En cours d\'examen';

  @override
  String get reportStatus_resolved => 'Résolu';

  @override
  String get reportStatus_unknown => 'Inconnu';

  @override
  String get quizHistoryScreen_title => 'Historique des Quiz';

  @override
  String get quizHistoryScreen_noQuizzesTaken =>
      'Aucun quiz effectué pour l\'instant.';

  @override
  String get quizHistoryScreen_cta =>
      'Testez vos connaissances en créant un nouveau quiz !';

  @override
  String get quizHistoryScreen_createQuizButton => 'Créer un Nouveau Quiz';

  @override
  String get quizHistoryScreen_createAnotherQuizButton => 'Faire un autre Quiz';

  @override
  String quizHistoryScreen_score(int score, int total) {
    return 'Score : $score/$total';
  }

  @override
  String quizHistoryScreen_takenOn(String date) {
    return 'Effectué le : $date';
  }

  @override
  String get quizHistoryScreen_quizInProgress => 'Quiz en cours';

  @override
  String get quizScreen_failedToLoad => 'Échec du chargement du quiz.';

  @override
  String quizScreen_questionOf(int current, int total) {
    return 'Question $current sur $total';
  }

  @override
  String get quizScreen_nextQuestion => 'Question Suivante';

  @override
  String get quizScreen_submit => 'Envoyer';

  @override
  String get quizScreen_back => 'Retour';

  @override
  String get quizScreen_quizComplete => 'Quiz Terminé !';

  @override
  String get quizScreen_yourScore => 'Votre Score :';

  @override
  String get quizScreen_backToPath => 'Retour au Parcours';

  @override
  String get quizScreen_loadingTitle =>
      'Génération de votre quiz personnalisé...';

  @override
  String get quizScreen_resumingTitle => 'Reprise de votre quiz...';

  @override
  String get quizReviewScreen_title => 'Vérifier les Réponses';

  @override
  String get quizReviewScreen_reviewAnswersButton => 'Vérifier les Réponses';

  @override
  String get quizScreen_loadingSubtitle =>
      'Notre IA prépare une série de questions pour tester vos connaissances. Cela peut prendre quelques instants.';
}
