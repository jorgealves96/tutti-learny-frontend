class ProfileStats {
  final int pathsStarted;
  final int pathsCompleted;
  final int itemsCompleted;
  final DateTime joinedDate;

  ProfileStats({
    required this.pathsStarted,
    required this.pathsCompleted,
    required this.itemsCompleted,
    required this.joinedDate,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      pathsStarted: json['pathsStarted'] ?? 0,
      pathsCompleted: json['pathsCompleted'] ?? 0,
      itemsCompleted: json['itemsCompleted'] ?? 0,
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'])
          : DateTime.now(),
    );
  }
}
