class SubscriptionStatus {
  final String tier;
  final int pathsGeneratedThisMonth;
  final int pathsExtendedThisMonth;
  final int? pathGenerationLimit;
  final int? pathExtensionLimit;

  SubscriptionStatus({
    required this.tier,
    required this.pathsGeneratedThisMonth,
    required this.pathsExtendedThisMonth,
    this.pathGenerationLimit,
    this.pathExtensionLimit,
  });

  factory SubscriptionStatus.freeTier() {
    return SubscriptionStatus(
      tier: 'Free',
      pathsGeneratedThisMonth: 0,
      pathsExtendedThisMonth: 0,
      pathGenerationLimit: 5,
      pathExtensionLimit: 5,
    );
  }

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatus(
      tier: json['tier'] == 0
          ? 'Free'
          : (json['tier'] == 1 ? 'Pro' : 'Unlimited'),
      pathsGeneratedThisMonth: json['pathsGeneratedThisMonth'],
      pathsExtendedThisMonth: json['pathsExtendedThisMonth'],
      pathGenerationLimit: json['pathGenerationLimit'],
      pathExtensionLimit: json['pathExtensionLimit'],
    );
  }
}
