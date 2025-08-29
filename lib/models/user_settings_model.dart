enum LearningLevel { beginner, intermediate, advanced }
enum PathLength { quick, standard, inDepth }

class UserSettings {
  final LearningLevel learningLevel;
  final PathLength pathLength;

  UserSettings({
    required this.learningLevel,
  required this.pathLength});

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      learningLevel: LearningLevel.values[json['learningLevel']],
      pathLength: PathLength.values[json['pathLength']]
    );
  }
}