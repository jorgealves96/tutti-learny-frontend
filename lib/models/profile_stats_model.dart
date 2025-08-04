class ProfileStats {
  final int pathsStarted;
  final int pathsInProgress;
  final int pathsCompleted;
  final int itemsCompleted;
  final int quizzesCompleted;
  final DateTime joinedDate;

  ProfileStats({
    required this.pathsStarted,
    required this.pathsInProgress,
    required this.pathsCompleted,
    required this.itemsCompleted,
    required this.quizzesCompleted,
    required this.joinedDate,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      pathsStarted: json['pathsStarted'] ?? 0,
      pathsInProgress: json['pathsInProgress'] ?? 0,
      pathsCompleted: json['pathsCompleted'] ?? 0,
      itemsCompleted: json['itemsCompleted'] ?? 0,
      quizzesCompleted: json['quizzesCompleted'] ?? 0,
      joinedDate: json['joinedDate'] != null
          ? DateTime.parse(json['joinedDate'])
          : DateTime.now(),
    );
  }
}
