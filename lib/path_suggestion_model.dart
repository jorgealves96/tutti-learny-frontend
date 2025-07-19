import 'package:flutter/material.dart';
import 'my_path_model.dart'; // We can reuse the PathCategory enum

class PathSuggestion {
  final int id; // This is the PathTemplate ID
  final String title;
  final String description;
  final PathCategory category;

  PathSuggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
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

  factory PathSuggestion.fromJson(Map<String, dynamic> json) {
    final categoryString = json['category'] ?? 'Other';
    final category = PathCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == categoryString.toLowerCase(),
      orElse: () => PathCategory.Other,
    );

    return PathSuggestion(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Path',
      description: json['description'] ?? '',
      category: category,
    );
  }
}
