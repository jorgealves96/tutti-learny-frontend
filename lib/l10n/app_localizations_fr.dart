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
  String get pathDetailScreen_extendPath => 'Étendre le Parcours';

  @override
  String get pathDetailScreen_pathExtendedSuccess =>
      'Parcours étendu avec succès !';

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
  String get profileScreen_usagePathsExtended => 'Parcours Étendus';

  @override
  String get profileScreen_usageUnlimited => 'Illimité';

  @override
  String get profileScreen_currentPlan => 'Plan Actuel';

  @override
  String get profileScreen_upgrade => 'Mettre à niveau';

  @override
  String get profileScreen_manageEditProfile => 'Modifier le Profil';

  @override
  String get profileScreen_manageNotifications => 'Notifications';

  @override
  String get profileScreen_manageAppearance => 'Apparence';

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
    return 'Nous avons trouvé des parcours existants pour \"$prompt\". Commencez avec l\'un d\'eux ou créez le vôtre.';
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
      'ex. Apprendre le français pour voyager…';

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
}
