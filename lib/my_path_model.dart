import 'package:flutter/material.dart';

// Enum to represent the categories from the backend
enum PathCategory {
  Technology,
  CreativeArts,
  Music,
  Business,
  Wellness,
  LifeSkills,
  Academic,
  Other
}

class MyPath {
  final int id;
  final String title;
  final String description;
  final PathCategory category; // Use the enum for type safety
  final double progress;

  MyPath({
    required this.id,
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
      case PathCategory.Academic:
        return Icons.school_outlined;
      default:
        return Icons.lightbulb_outline;
    }
  }

  factory MyPath.fromJson(Map<String, dynamic> json) {
    // Convert the category string from the API to our enum
    final categoryString = json['category'] ?? 'Other';
    final category = PathCategory.values.firstWhere(
      (e) => e.toString().split('.').last == categoryString,
      orElse: () => PathCategory.Other,
    );

    return MyPath(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: category,
      progress: (json['progress'] as num).toDouble(),
    );
  }
}
