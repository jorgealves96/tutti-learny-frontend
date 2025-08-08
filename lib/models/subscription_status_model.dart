class SubscriptionStatus {
  final String tier;
  final int pathsGeneratedThisMonth;
  final int pathsExtendedThisMonth;
  final int? pathGenerationLimit;
  final int? pathExtensionLimit;
  final int quizzesCreatedThisMonth;
  final int? quizCreationLimit;
  final DateTime? subscriptionExpiryDate;
  final int? daysLeftInSubscription;

  SubscriptionStatus({
    required this.tier,
    required this.pathsGeneratedThisMonth,
    required this.pathsExtendedThisMonth,
    this.pathGenerationLimit,
    this.pathExtensionLimit,
    required this.quizzesCreatedThisMonth,
    this.quizCreationLimit,
    this.subscriptionExpiryDate,
    this.daysLeftInSubscription,
  });

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      tier: json['tier'] == 0
          ? 'Free'
          : (json['tier'] == 1 ? 'Pro' : 'Unlimited'),
      pathsGeneratedThisMonth: json['pathsGeneratedThisMonth'],
      pathsExtendedThisMonth: json['pathsExtendedThisMonth'],
      pathGenerationLimit: json['pathGenerationLimit'],
      pathExtensionLimit: json['pathExtensionLimit'],
      quizzesCreatedThisMonth: json['quizzesCreatedThisMonth'] ?? 0,
      quizCreationLimit: json['quizCreationLimit'],
      subscriptionExpiryDate: json['subscriptionExpiryDate'] != null
          ? DateTime.parse(json['subscriptionExpiryDate'])
          : null,
      daysLeftInSubscription: json['daysLeftInSubscription'],
    );
  }
}
