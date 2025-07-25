// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get generatingPathsScreen_craftingPersonalizedLearningPath =>
      'Creando tu ruta de aprendizaje personalizada';

  @override
  String get generatingPathsScreen_loadingPathGenerationMessage =>
      'Nuestra IA está trabajando para crear un plan de estudios adaptado a tus objetivos y estilo de aprendizaje. Esto puede tardar unos momentos.';

  @override
  String get homeScreen_pleaseEnterATopic =>
      'Por favor, introduce un tema para generar una ruta.';

  @override
  String get homeScreen_usageLimitReached => 'Límite de Uso Alcanzado';

  @override
  String get homeScreen_maybeLater => 'Quizás Más Tarde';

  @override
  String get homeScreen_upgrade => 'Mejorar';

  @override
  String get homeScreen_namePlaceholder => '';

  @override
  String get homeScreen_hi => 'Hola ';

  @override
  String get homeScreen_callToActionMsg => ',\n¿qué quieres aprender hoy?';

  @override
  String get homeScreen_createLearningPath => 'Crear Ruta de Aprendizaje';

  @override
  String get homeScreen_recentlyCreatedPaths => 'Rutas Creadas Recientemente';

  @override
  String get loginScreen_welcomePrimary => 'Bienvenido a Tutti Learni';

  @override
  String get loginScreen_welcomeSecondary =>
      'Tu guía personal para aprender cualquier cosa.';

  @override
  String get loginScreen_continueWithGoogle => 'Continuar con Google';

  @override
  String get loginScreen_failedToSignInGoogle =>
      'Error al iniciar sesión con Google.';

  @override
  String get loginScreen_continueWithPhoneNumber =>
      'Continuar con Número de Teléfono';

  @override
  String get mainScreen_labelMyPaths => 'Mis Rutas';

  @override
  String get mainScreen_labelHome => 'Inicio';

  @override
  String get mainScreen_labelProfile => 'Perfil';

  @override
  String get mainScreen_tryAgain => 'Intentar de Nuevo';

  @override
  String get myPathsScreen_noPathsCreatedYet => 'Aún no has creado rutas.';

  @override
  String get myPathsScreen_createANewPath => 'Crear una Nueva Ruta';

  @override
  String pathDetailScreen_error(String error) {
    return 'Error: $error';
  }

  @override
  String get pathDetailScreen_pathNotFound => 'Ruta no encontrada.';

  @override
  String get pathDetailScreen_usageLimitReached => 'Límite de Uso Alcanzado';

  @override
  String get pathDetailScreen_maybeLater => 'Quizás Más Tarde';

  @override
  String get pathDetailScreen_upgrade => 'Mejorar';

  @override
  String get pathDetailScreen_pathCompleted =>
      '¡Felicidades! Has completado esta ruta.';

  @override
  String pathDetailScreen_failedToExtendPath(String error) {
    return 'Error al extender la ruta: $error';
  }

  @override
  String pathDetailScreen_failedToUpdateTask(String error) {
    return 'Error al actualizar la tarea: $error';
  }

  @override
  String pathDetailScreen_failedToUpdateResource(String error) {
    return 'Error al actualizar el recurso: $error';
  }

  @override
  String get pathDetailScreen_noLinkAvailable =>
      'Este recurso no tiene un enlace disponible.';

  @override
  String get pathDetailScreen_deletePathTitle => 'Eliminar Ruta';

  @override
  String get pathDetailScreen_deletePathConfirm =>
      '¿Estás seguro de que quieres eliminar permanentemente esta ruta de aprendizaje?';

  @override
  String get pathDetailScreen_cancel => 'Cancelar';

  @override
  String get pathDetailScreen_delete => 'Eliminar';

  @override
  String pathDetailScreen_failedToDeletePath(String error) {
    return 'Error al eliminar la ruta: $error';
  }

  @override
  String get pathDetailScreen_pathIsComplete => '¡Ruta Completada!';

  @override
  String get pathDetailScreen_generating => 'Generando...';

  @override
  String get pathDetailScreen_extendPath => 'Extender Ruta';

  @override
  String get phoneLoginScreen_enterPhoneNumberTitle =>
      'Introduce tu Número de Teléfono';

  @override
  String get phoneLoginScreen_enterVerificationCodeTitle =>
      'Introduce el Código de Verificación';

  @override
  String get phoneLoginScreen_enterPhoneNumberSubtitle =>
      'Selecciona tu país e introduce tu número de teléfono.';

  @override
  String phoneLoginScreen_codeSentSubtitle(String fullPhoneNumber) {
    return 'Se ha enviado un código de 6 dígitos a $fullPhoneNumber';
  }

  @override
  String get phoneLoginScreen_phoneNumberLabel => 'Número de Teléfono';

  @override
  String get phoneLoginScreen_otpLabel => 'Código de 6 dígitos';

  @override
  String get phoneLoginScreen_sendCode => 'Enviar Código';

  @override
  String get phoneLoginScreen_verifyCode => 'Verificar Código';

  @override
  String get phoneLoginScreen_pleaseEnterPhoneNumber =>
      'Por favor, introduce un número de teléfono.';

  @override
  String phoneLoginScreen_failedToSendCode(String error) {
    return 'Error al enviar el código: $error';
  }

  @override
  String phoneLoginScreen_anErrorOccurred(String error) {
    return 'Ocurrió un error: $error';
  }

  @override
  String get phoneLoginScreen_invalidCode =>
      'Código inválido. Por favor, inténtalo de nuevo.';

  @override
  String get profileScreen_editName => 'Editar Nombre';

  @override
  String get profileScreen_enterYourName => 'Introduce tu nombre';

  @override
  String get profileScreen_cancel => 'Cancelar';

  @override
  String get profileScreen_save => 'Guardar';

  @override
  String profileScreen_failedToUpdateName(String error) {
    return 'Error al actualizar el nombre: $error';
  }

  @override
  String get profileScreen_logout => 'Cerrar Sesión';

  @override
  String get profileScreen_logoutConfirm =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get profileScreen_deleteAccount => 'Eliminar Cuenta';

  @override
  String get profileScreen_deleteAccountConfirm =>
      '¿Estás seguro de que quieres eliminar tu cuenta permanentemente? Esta acción no se puede deshacer.';

  @override
  String get profileScreen_delete => 'Eliminar';

  @override
  String get profileScreen_user => 'Usuario';

  @override
  String profileScreen_joined(String date) {
    return 'Miembro desde $date';
  }

  @override
  String get profileScreen_sectionLearningStatistics =>
      'Estadísticas de Aprendizaje';

  @override
  String get profileScreen_sectionSubscription => 'Suscripción';

  @override
  String get profileScreen_sectionMonthlyUsage => 'Uso Mensual';

  @override
  String get profileScreen_sectionAccountManagement => 'Gestión de la Cuenta';

  @override
  String get profileScreen_statPathsStarted => 'Rutas Iniciadas';

  @override
  String get profileScreen_statPathsCompleted => 'Rutas Completadas';

  @override
  String get profileScreen_statResourcesCompleted => 'Recursos Completados';

  @override
  String get profileScreen_usagePathsGenerated => 'Rutas Generadas';

  @override
  String get profileScreen_usagePathsExtended => 'Rutas Extendidas';

  @override
  String get profileScreen_usageUnlimited => 'Ilimitado';

  @override
  String get profileScreen_currentPlan => 'Plan Actual';

  @override
  String get profileScreen_upgrade => 'Mejorar';

  @override
  String get profileScreen_manageEditProfile => 'Editar Perfil';

  @override
  String get profileScreen_manageNotifications => 'Notificaciones';

  @override
  String get profileScreen_manageAppearance => 'Apariencia';

  @override
  String get profileScreen_manageLanguage => 'Idioma';

  @override
  String get subscriptionScreen_title => 'Mejora Tu Aprendizaje';

  @override
  String get subscriptionScreen_monthly => 'Mensual';

  @override
  String get subscriptionScreen_yearly => 'Anual (Ahorra ~15%)';

  @override
  String get subscriptionScreen_upgradeNow => 'Mejorar Ahora';

  @override
  String subscriptionScreen_startingPurchase(
    String tierTitle,
    String duration,
  ) {
    return 'Iniciando compra para $tierTitle ($duration)';
  }

  @override
  String get subscriptionScreen_tierPro_title => 'Pro';

  @override
  String subscriptionScreen_tierPro_priceMonthly(String price) {
    return '$price/mes';
  }

  @override
  String subscriptionScreen_tierPro_priceYearly(String price) {
    return '$price/año';
  }

  @override
  String subscriptionScreen_tierPro_feature1(int count) {
    return '$count Generaciones de Rutas/mes';
  }

  @override
  String subscriptionScreen_tierPro_feature2(int count) {
    return '$count Extensiones de Rutas/mes';
  }

  @override
  String get subscriptionScreen_tierUnlimited_title => 'Ilimitado';

  @override
  String subscriptionScreen_tierUnlimited_priceMonthly(String price) {
    return '$price/mes';
  }

  @override
  String subscriptionScreen_tierUnlimited_priceYearly(String price) {
    return '$price/año';
  }

  @override
  String get subscriptionScreen_tierUnlimited_feature1 =>
      'Generaciones de Rutas Ilimitadas';

  @override
  String get subscriptionScreen_tierUnlimited_feature2 =>
      'Extensiones de Rutas Ilimitadas';

  @override
  String get suggestionsScreen_title => 'Sugerencias';

  @override
  String suggestionsScreen_errorAssigningPath(String error) {
    return 'Error al asignar la ruta: $error';
  }

  @override
  String suggestionsScreen_header(String prompt) {
    return 'Encontramos algunas rutas existentes para \"$prompt\". Empieza con una de estas o genera la tuya propia.';
  }

  @override
  String get suggestionsScreen_generateMyOwnPath => 'Generar Mi Propia Ruta';

  @override
  String get rotatingHintTextField_suggestion1 =>
      'ej. Aprender lo básico de guitarra…';

  @override
  String get rotatingHintTextField_suggestion2 =>
      'ej. Empezar un curso de hablar en público…';

  @override
  String get rotatingHintTextField_suggestion3 =>
      'ej. Dominar Excel en 30 días…';

  @override
  String get rotatingHintTextField_suggestion4 =>
      'ej. Aprender a cocinar comida italiana…';

  @override
  String get rotatingHintTextField_suggestion5 =>
      'ej. Mejorar mis habilidades de fotografía…';

  @override
  String get rotatingHintTextField_suggestion6 =>
      'ej. Estudiar para los exámenes de acceso…';

  @override
  String get rotatingHintTextField_suggestion7 =>
      'ej. Aprender francés para viajar…';

  @override
  String get rotatingHintTextField_suggestion8 =>
      'ej. Crear un presupuesto personal…';

  @override
  String get rotatingHintTextField_suggestion9 =>
      'ej. Practicar técnicas de meditación…';

  @override
  String get rotatingHintTextField_suggestion10 =>
      'ej. Aprender a programar en Python...';

  @override
  String get rotatingHintTextField_unlimitedGenerations =>
      'Generaciones Ilimitadas';

  @override
  String rotatingHintTextField_generationsLeft(int count) {
    return '$count Generaciones de Rutas Restantes';
  }
}
