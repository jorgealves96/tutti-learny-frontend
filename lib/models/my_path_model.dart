import 'package:flutter/material.dart';

// Enum to represent the categories from the backend
enum PathCategory {
  Technology,
  CreativeArts,
  Music,
  Business,
  Wellness,
  LifeSkills,
  Gaming,
  Academic,
  Other
}

class MyPath {
  // The property is now correctly named userPathId
  final int userPathId;
  final String title;
  final String description;
  final PathCategory category;
  final double progress;

  MyPath({
    required this.userPathId,
    required this.title,
    required this.description,
    required this.category,
    required this.progress,
  });

  // Helper method to get an icon based on the category
  IconData get icon {
    switch (category) {
      case PathCategory.Technology:
        return Icons.code;
      case PathCategory.CreativeArts:
        return Icons.palette_outlined;
      case PathCategory.Music:
        return Icons.music_note_outlined;
      case PathCategory.Business:
        return Icons.business_center_outlined;
      case PathCategory.Wellness:
        return Icons.favorite_border;
      case PathCategory.LifeSkills:
        return Icons.home_work_outlined;
      case PathCategory.Gaming:
        return Icons.sports_esports_outlined;
      case PathCategory.Academic:
        return Icons.school_outlined;
      default:
        return Icons.lightbulb_outline;
    }
  }

  factory MyPath.fromJson(Map<String, dynamic> json) {
    final categoryString = json['category'] ?? 'Other';
    final category = PathCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == categoryString.toLowerCase(),
      orElse: () => PathCategory.Other,
    );

    return MyPath(
      // Read from the correct JSON key: 'userPathId'
      userPathId: json['userPathId'] ?? 0,
      title: json['title'] ?? 'Untitled Path',
      description: json['description'] ?? '',
      category: category,
      progress: (json['progress'] as num? ?? 0.0).toDouble(),
    );
  }
}
