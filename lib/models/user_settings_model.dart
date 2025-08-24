enum LearningLevel { beginner, intermediate, advanced }

class UserSettings {
  final LearningLevel learningLevel;

  UserSettings({required this.learningLevel});

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      learningLevel: LearningLevel.values[json['learningLevel']],
    );
  }
}