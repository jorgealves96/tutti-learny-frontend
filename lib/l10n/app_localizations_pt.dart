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
  String get homeScreen_pathCreatedSuccess => 'Percurso criado com sucesso!';

  @override
  String get homeScreen_onboarding_prompt_title =>
      'Introduza um Tópico de Aprendizagem';

  @override
  String get homeScreen_onboarding_prompt_description =>
      'Escreva qualquer coisa que queira aprender aqui, desde \"como fazer pão\" até \"os fundamentos da física quântica\".';

  @override
  String get homeScreen_onboarding_createButton_title => 'Crie o Seu Percurso';

  @override
  String get homeScreen_onboarding_createButton_description =>
      'Toque aqui e a nossa IA começará a gerar o seu plano de aprendizagem personalizado.';

  @override
  String get homeScreen_onboarding_welcome_title =>
      'Bem-vindo ao Tutti Learni!';

  @override
  String get homeScreen_onboarding_welcome_description =>
      'Este é o seu guia pessoal para aprender qualquer coisa. Vamos mostrar-lhe rapidamente como funciona.';

  @override
  String homeScreen_limitResetsOn(String date) {
    return 'O seu limite mensal é reposto a $date.';
  }

  @override
  String get homeScreen_generationLimitExceeded =>
      'Atingiu o seu limite mensal para a criação de novos percursos. Considere atualizar a sua subscrição para continuar.';

  @override
  String get loginScreen_welcomePrimary => 'Bem-vindo ao';

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
  String get pathDetailScreen_pathExtendedSuccess =>
      'Percurso estendido com sucesso!';

  @override
  String get pathDetailScreen_checkReportStatus => 'Ver estado do relatório';

  @override
  String get pathDetailScreen_reportProblem => 'Reportar um problema';

  @override
  String get pathDetailScreen_testYourKnowledge =>
      'Teste os seus conhecimentos';

  @override
  String get pathDetailScreen_onboarding_main_title =>
      'O Seu Percurso de Aprendizagem';

  @override
  String get pathDetailScreen_onboarding_main_description =>
      'Aqui pode ver o título, a descrição e o progresso geral do seu percurso.';

  @override
  String get pathDetailScreen_onboarding_checkbox_title =>
      'Acompanhe o Seu Progresso';

  @override
  String get pathDetailScreen_onboarding_checkbox_description =>
      'Marque secções inteiras ou recursos individuais como concluídos tocando nas caixas de seleção.';

  @override
  String get pathDetailScreen_onboarding_menu_title => 'Opções do Percurso';

  @override
  String get pathDetailScreen_onboarding_menu_description =>
      'Toque aqui para testar os seus conhecimentos com um questionário, reportar um problema ou eliminar o percurso.';

  @override
  String get pathDetailScreen_onboarding_resource_title => 'Ver Conteúdo';

  @override
  String get pathDetailScreen_onboarding_resource_description =>
      'Toque em qualquer recurso, como um artigo ou vídeo, para o abrir e visualizar.';

  @override
  String get pathDetailScreen_extensionLimitExceeded =>
      'Atingiu o seu limite mensal para expandir percursos. Considere atualizar a sua subscrição para continuar.';

  @override
  String get pathDetailScreen_onboarding_extend_title =>
      'Expanda a Sua Aprendizagem';

  @override
  String get pathDetailScreen_onboarding_extend_description =>
      'Quer aprofundar o tema? Toque aqui para adicionar os próximos passos lógicos ao seu percurso.';

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
  String get phoneLoginScreen_verifyingAutomatically =>
      'A verificar automaticamente...';

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
  String get profileScreen_upgrade => 'Melhorar';

  @override
  String get profileScreen_manageEditProfile => 'Editar Perfil';

  @override
  String get profileScreen_manageNotifications => 'Notificações';

  @override
  String get profileScreen_manageAppearance => 'Tema';

  @override
  String get profileScreen_manageLanguage => 'Idioma';

  @override
  String get profileScreen_tierFree => 'Grátis';

  @override
  String profileScreen_daysLeft(String date, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias restantes',
      one: '1 dia restante',
    );
    return 'A sua subscrição termina em $date ($_temp0)';
  }

  @override
  String get profileScreen_manageSubscription => 'Gerir';

  @override
  String get profileScreen_nameUpdateSuccess => 'Nome atualizado com sucesso!';

  @override
  String get profileScreen_statQuizzesCompleted => 'Quizzes Concluídos';

  @override
  String get profileScreen_usageQuizzesCreated => 'Quizzes Criados';

  @override
  String get subscriptionScreen_title => 'Melhore a Sua Aprendizagem';

  @override
  String get subscriptionScreen_monthly => 'Mensal';

  @override
  String get subscriptionScreen_yearly => 'Anual (Poupe ~30%)';

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
  String subscriptionScreen_tierPro_feature3(int count) {
    return '$count Quizzes/mês';
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
  String get subscriptionScreen_tierUnlimited_feature3 => 'Quizzes Ilimitados';

  @override
  String get subscriptionScreen_upgradeSuccess =>
      'Subscrição atualizada com sucesso!';

  @override
  String get subscriptionScreen_noPlansAvailable =>
      'Não existem planos de subscrição disponíveis de momento.';

  @override
  String get subscriptionScreen_purchaseVerificationError =>
      'Compra efetuada com sucesso, mas não foi possível verificá-la. Por favor, tente restaurar as compras no ecrã de perfil.';

  @override
  String get suggestionsScreen_title => 'Sugestões';

  @override
  String suggestionsScreen_errorAssigningPath(String error) {
    return 'Erro ao atribuir o percurso: $error';
  }

  @override
  String suggestionsScreen_header(String prompt) {
    return 'Encontrámos alguns percursos existentes que se revelaram úteis para outros utilizadores para \"$prompt\". Pode escolher um destes ou gerar o seu próprio.';
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

  @override
  String get ratingScreen_title => 'Avaliar Percurso';

  @override
  String ratingScreen_congratulationsTitle(String pathTitle) {
    return 'Parabéns por terminar o percurso \'$pathTitle\'!';
  }

  @override
  String get ratingScreen_callToAction =>
      'A sua avaliação ajuda outros utilizadores a encontrar os melhores percursos de aprendizagem.';

  @override
  String get ratingScreen_submitRating => 'Enviar Avaliação';

  @override
  String get ratingScreen_noThanks => 'Não, obrigado';

  @override
  String get ratingScreen_thankYouTitle => 'Obrigado pelo seu feedback!';

  @override
  String get notificationsScreen_learningReminders =>
      'Lembretes de Aprendizagem';

  @override
  String get notificationsScreen_learningRemindersDesc =>
      'Receber notificações para percursos não terminados';

  @override
  String get notificationsScreen_generalAnnouncements => 'Anúncios Gerais';

  @override
  String get notificationsScreen_generalAnnouncementsSubtitle =>
      'Receba notícias e atualizações ocasionais sobre a aplicação.';

  @override
  String get reportScreen_title => 'Reportar um Problema';

  @override
  String get reportScreen_question => 'Qual é o problema?';

  @override
  String get reportScreen_optionalDetails => 'Detalhes Opcionais';

  @override
  String get reportScreen_detailsHint =>
      'Forneça mais detalhes sobre o problema...';

  @override
  String get reportScreen_submitButton => 'Enviar Relatório';

  @override
  String get reportScreen_submitSuccess =>
      'Relatório enviado com sucesso. Obrigado!';

  @override
  String get reportScreen_typeInaccurate => 'Conteúdo Incorreto';

  @override
  String get reportScreen_typeBrokenLinks => 'Links Inativos ou Incorretos';

  @override
  String get reportScreen_typeInappropriate => 'Conteúdo Inapropriado';

  @override
  String get reportScreen_typeOther => 'Outro';

  @override
  String get reportStatusScreen_title => 'Estado do Relatório';

  @override
  String get reportStatusScreen_noReportFound =>
      'Nenhum relatório encontrado para este percurso.';

  @override
  String reportStatusScreen_statusLabel(String status) {
    return 'Estado: $status';
  }

  @override
  String get reportStatusScreen_resolvedMessageDefault =>
      'Este problema foi revisto e resolvido. Obrigado pelo seu feedback!';

  @override
  String get reportStatusScreen_submittedMessage =>
      'O seu relatório foi submetido e será revisto em breve. Obrigado por nos ajudar a melhorar!';

  @override
  String get reportStatusScreen_acknowledgeButton => 'Confirmar e Fechar';

  @override
  String get reportStatus_submitted => 'Submetido';

  @override
  String get reportStatus_inReview => 'Em Revisão';

  @override
  String get reportStatus_resolved => 'Resolvido';

  @override
  String get reportStatus_unknown => 'Desconhecido';

  @override
  String get quizHistoryScreen_title => 'Histórico de Quizzes';

  @override
  String get quizHistoryScreen_noQuizzesTaken => 'Nenhum quiz realizado ainda.';

  @override
  String get quizHistoryScreen_cta =>
      'Teste os seus conhecimentos criando um novo quiz!';

  @override
  String get quizHistoryScreen_createQuizButton => 'Criar um Novo Quiz';

  @override
  String get quizHistoryScreen_createAnotherQuizButton => 'Fazer Outro Quiz';

  @override
  String quizHistoryScreen_score(int score, int total) {
    return 'Pontuação: $score/$total';
  }

  @override
  String quizHistoryScreen_takenOn(String date) {
    return 'Realizado em: $date';
  }

  @override
  String get quizHistoryScreen_quizInProgress => 'Quiz em Progresso';

  @override
  String get quizHistoryScreen_creationLimitExceeded =>
      'Atingiu o seu limite mensal para a criação de questionários. Considere atualizar a sua subscrição para continuar.';

  @override
  String get quizScreen_failedToLoad => 'Falha ao carregar o quiz.';

  @override
  String quizScreen_questionOf(int current, int total) {
    return 'Pergunta $current de $total';
  }

  @override
  String get quizScreen_nextQuestion => 'Próxima Pergunta';

  @override
  String get quizScreen_submit => 'Submeter';

  @override
  String get quizScreen_back => 'Voltar';

  @override
  String get quizScreen_quizComplete => 'Quiz Concluído!';

  @override
  String get quizScreen_yourScore => 'A Sua Pontuação:';

  @override
  String get quizScreen_backToPath => 'Voltar ao Percurso';

  @override
  String get quizScreen_loadingTitle => 'A gerar o seu quiz personalizado...';

  @override
  String get quizScreen_resumingTitle => 'A retomar o seu quiz...';

  @override
  String get quizScreen_loadingSubtitle =>
      'A nossa IA está a preparar um conjunto de perguntas para testar os seus conhecimentos. Isto pode demorar alguns momentos.';

  @override
  String get quizReviewScreen_title => 'Rever Respostas';

  @override
  String get quizReviewScreen_reviewAnswersButton => 'Rever Respostas';
}
