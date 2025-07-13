import 'package:flutter/material.dart';

// Enum to represent the different types of path items
enum PathItemType { article, video, quiz, project }

class PathItem {
  final String title;
  final PathItemType type;
  bool isCompleted;

  PathItem({
    required this.title,
    required this.type,
    this.isCompleted = false,
  });

  // A helper method to get the correct icon based on the type
  IconData get icon {
    switch (type) {
      case PathItemType.article:
        return Icons.article_outlined;
      case PathItemType.video:
        return Icons.play_circle_outline;
      case PathItemType.quiz:
        return Icons.quiz_outlined;
      case PathItemType.project:
        return Icons.code;
      default:
        return Icons.article_outlined;
    }
  }
}
