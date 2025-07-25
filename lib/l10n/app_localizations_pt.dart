// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get generatingPathsScreen_craftingPersonalizedLearningPath =>
      'A criar o seu percurso de aprendizagem personalizado';

  @override
  String get generatingPathsScreen_loadingPathGenerationMessage =>
      'A nossa IA está a trabalhar para criar um currículo à medida dos seus objetivos e estilo de aprendizagem. Isto pode demorar alguns momentos.';

  @override
  String get homeScreen_pleaseEnterATopic =>
      'Por favor, insira um tópico para gerar um percurso.';

  @override
  String get homeScreen_usageLimitReached => 'Limite de Utilização Atingido';

  @override
  String get homeScreen_maybeLater => 'Talvez Depois';

  @override
  String get homeScreen_upgrade => 'Atualizar';

  @override
  String get homeScreen_namePlaceholder => '';

  @override
  String get homeScreen_hi => 'Olá ';

  @override
  String get homeScreen_callToActionMsg => ',\no que quer aprender hoje?';

  @override
  String get homeScreen_createLearningPath => 'Criar Percurso de Aprendizagem';

  @override
  String get homeScreen_recentlyCreatedPaths =>
      'Percursos Criados Recentemente';

  @override
  String get loginScreen_welcomePrimary => 'Bem-vindo ao Tutti Learni';

  @override
  String get loginScreen_welcomeSecondary =>
      'O seu guia pessoal para aprender qualquer coisa.';

  @override
  String get loginScreen_continueWithGoogle => 'Continuar com o Google';

  @override
  String get loginScreen_failedToSignInGoogle =>
      'Falha ao iniciar sessão com o Google.';

  @override
  String get loginScreen_continueWithPhoneNumber =>
      'Continuar com Número de Telemóvel';

  @override
  String get mainScreen_labelMyPaths => 'Meus Percursos';

  @override
  String get mainScreen_labelHome => 'Início';

  @override
  String get mainScreen_labelProfile => 'Perfil';

  @override
  String get mainScreen_tryAgain => 'Tentar Novamente';

  @override
  String get myPathsScreen_noPathsCreatedYet =>
      'Ainda não foram criados percursos';

  @override
  String get myPathsScreen_createANewPath => 'Criar um Novo Percurso';

  @override
  String pathDetailScreen_error(String error) {
    return 'Erro: $error';
  }

  @override
  String get pathDetailScreen_pathNotFound => 'Percurso não encontrado.';

  @override
  String get pathDetailScreen_usageLimitReached =>
      'Limite de utilização atingido';

  @override
  String get pathDetailScreen_maybeLater => 'Talvez Depois';

  @override
  String get pathDetailScreen_upgrade => 'Atualizar';

  @override
  String get pathDetailScreen_pathCompleted =>
      'Parabéns! Concluiu este percurso.';

  @override
  String pathDetailScreen_failedToExtendPath(String error) {
    return 'Falha ao estender o percurso: $error';
  }

  @override
  String pathDetailScreen_failedToUpdateTask(String error) {
    return 'Falha ao atualizar a tarefa: $error';
  }

  @override
  String pathDetailScreen_failedToUpdateResource(String error) {
    return 'Falha ao atualizar o recurso: $error';
  }

  @override
  String get pathDetailScreen_noLinkAvailable =>
      'Este recurso não tem um link disponível.';

  @override
  String get pathDetailScreen_deletePathTitle => 'Eliminar Percurso';

  @override
  String get pathDetailScreen_deletePathConfirm =>
      'Tem a certeza de que quer eliminar permanentemente este percurso de aprendizagem?';

  @override
  String get pathDetailScreen_cancel => 'Cancelar';

  @override
  String get pathDetailScreen_delete => 'Eliminar';

  @override
  String pathDetailScreen_failedToDeletePath(String error) {
    return 'Falha ao eliminar o percurso: $error';
  }

  @override
  String get pathDetailScreen_pathIsComplete => 'Percurso Completo!';

  @override
  String get pathDetailScreen_generating => 'A gerar...';

  @override
  String get pathDetailScreen_extendPath => 'Estender Percurso';

  @override
  String get phoneLoginScreen_enterPhoneNumberTitle =>
      'Insira o seu número de telemóvel';

  @override
  String get phoneLoginScreen_enterVerificationCodeTitle =>
      'Insira o Código de Verificação';

  @override
  String get phoneLoginScreen_enterPhoneNumberSubtitle =>
      'Selecione o seu país e insira o seu número de telemóvel.';

  @override
  String phoneLoginScreen_codeSentSubtitle(String fullPhoneNumber) {
    return 'Foi enviado um código de 6 dígitos para $fullPhoneNumber';
  }

  @override
  String get phoneLoginScreen_phoneNumberLabel => 'Número de Telemóvel';

  @override
  String get phoneLoginScreen_otpLabel => 'Código de 6 dígitos';

  @override
  String get phoneLoginScreen_sendCode => 'Enviar Código';

  @override
  String get phoneLoginScreen_verifyCode => 'Verificar Código';

  @override
  String get phoneLoginScreen_pleaseEnterPhoneNumber =>
      'Por favor, insira um número de telemóvel.';

  @override
  String phoneLoginScreen_failedToSendCode(String error) {
    return 'Falha ao enviar o código: $error';
  }

  @override
  String phoneLoginScreen_anErrorOccurred(String error) {
    return 'Ocorreu um erro: $error';
  }

  @override
  String get phoneLoginScreen_invalidCode =>
      'Código inválido. Por favor, tente novamente.';

  @override
  String get profileScreen_editName => 'Editar Nome';

  @override
  String get profileScreen_enterYourName => 'Insira o seu nome';

  @override
  String get profileScreen_cancel => 'Cancelar';

  @override
  String get profileScreen_save => 'Guardar';

  @override
  String profileScreen_failedToUpdateName(String error) {
    return 'Falha ao atualizar o nome: $error';
  }

  @override
  String get profileScreen_logout => 'Terminar Sessão';

  @override
  String get profileScreen_logoutConfirm =>
      'Tem a certeza de que quer terminar a sessão?';

  @override
  String get profileScreen_deleteAccount => 'Eliminar Conta';

  @override
  String get profileScreen_deleteAccountConfirm =>
      'Tem a certeza de que quer eliminar permanentemente a sua conta? Esta ação não pode ser desfeita.';

  @override
  String get profileScreen_delete => 'Eliminar';

  @override
  String get profileScreen_user => 'Utilizador';

  @override
  String profileScreen_joined(String date) {
    return 'Membro desde $date';
  }

  @override
  String get profileScreen_sectionLearningStatistics =>
      'Estatísticas de Aprendizagem';

  @override
  String get profileScreen_sectionSubscription => 'Subscrição';

  @override
  String get profileScreen_sectionMonthlyUsage => 'Utilização Mensal';

  @override
  String get profileScreen_sectionAccountManagement => 'Gestão da Conta';

  @override
  String get profileScreen_statPathsStarted => 'Percursos Iniciados';

  @override
  String get profileScreen_statPathsCompleted => 'Percursos Concluídos';

  @override
  String get profileScreen_statResourcesCompleted => 'Recursos Concluídos';

  @override
  String get profileScreen_usagePathsGenerated => 'Percursos Gerados';

  @override
  String get profileScreen_usagePathsExtended => 'Percursos Estendidos';

  @override
  String get profileScreen_usageUnlimited => 'Ilimitado';

  @override
  String get profileScreen_currentPlan => 'Plano Atual';

  @override
  String get profileScreen_upgrade => 'Atualizar';

  @override
  String get profileScreen_manageEditProfile => 'Editar Perfil';

  @override
  String get profileScreen_manageNotifications => 'Notificações';

  @override
  String get profileScreen_manageAppearance => 'Aparência';

  @override
  String get profileScreen_manageLanguage => 'Idioma';

  @override
  String get subscriptionScreen_title => 'Melhore a Sua Aprendizagem';

  @override
  String get subscriptionScreen_monthly => 'Mensal';

  @override
  String get subscriptionScreen_yearly => 'Anual (Poupe ~15%)';

  @override
  String get subscriptionScreen_upgradeNow => 'Atualizar Agora';

  @override
  String subscriptionScreen_startingPurchase(
    String tierTitle,
    String duration,
  ) {
    return 'A iniciar a compra de $tierTitle ($duration)';
  }

  @override
  String get subscriptionScreen_tierPro_title => 'Pro';

  @override
  String subscriptionScreen_tierPro_priceMonthly(String price) {
    return '$price/mês';
  }

  @override
  String subscriptionScreen_tierPro_priceYearly(String price) {
    return '$price/ano';
  }

  @override
  String subscriptionScreen_tierPro_feature1(int count) {
    return '$count Gerações de Percursos/mês';
  }

  @override
  String subscriptionScreen_tierPro_feature2(int count) {
    return '$count Extensões de Percursos/mês';
  }

  @override
  String get subscriptionScreen_tierUnlimited_title => 'Ilimitado';

  @override
  String subscriptionScreen_tierUnlimited_priceMonthly(String price) {
    return '$price/mês';
  }

  @override
  String subscriptionScreen_tierUnlimited_priceYearly(String price) {
    return '$price/ano';
  }

  @override
  String get subscriptionScreen_tierUnlimited_feature1 =>
      'Gerações de Percursos Ilimitadas';

  @override
  String get subscriptionScreen_tierUnlimited_feature2 =>
      'Extensões de Percursos Ilimitadas';

  @override
  String get suggestionsScreen_title => 'Sugestões';

  @override
  String suggestionsScreen_errorAssigningPath(String error) {
    return 'Erro ao atribuir o percurso: $error';
  }

  @override
  String suggestionsScreen_header(String prompt) {
    return 'Encontrámos alguns percursos existentes para \"$prompt\". Comece com um destes ou crie o seu próprio.';
  }

  @override
  String get suggestionsScreen_generateMyOwnPath =>
      'Gerar o Meu Próprio Percurso';

  @override
  String get rotatingHintTextField_suggestion1 =>
      'ex. Aprender o básico de guitarra…';

  @override
  String get rotatingHintTextField_suggestion2 =>
      'ex. Começar um curso de como falar em público…';

  @override
  String get rotatingHintTextField_suggestion3 =>
      'ex. Dominar o Excel em 30 dias…';

  @override
  String get rotatingHintTextField_suggestion4 =>
      'ex. Aprender a cozinhar comida italiana…';

  @override
  String get rotatingHintTextField_suggestion5 =>
      'ex. Melhorar as minhas capacidades de fotografia…';

  @override
  String get rotatingHintTextField_suggestion6 =>
      'ex. Estudar para os exames nacionais…';

  @override
  String get rotatingHintTextField_suggestion7 =>
      'ex. Aprender francês para viajar…';

  @override
  String get rotatingHintTextField_suggestion8 =>
      'ex. Criar um orçamento pessoal…';

  @override
  String get rotatingHintTextField_suggestion9 =>
      'ex. Praticar técnicas de meditação…';

  @override
  String get rotatingHintTextField_suggestion10 =>
      'ex. Aprender a programar em Python...';

  @override
  String get rotatingHintTextField_unlimitedGenerations =>
      'Gerações Ilimitadas';

  @override
  String rotatingHintTextField_generationsLeft(int count) {
    return '$count Gerações de Percursos Restantes';
  }
}
