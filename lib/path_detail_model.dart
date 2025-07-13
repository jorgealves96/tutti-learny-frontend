import 'package:flutter/material.dart';

// Enum to represent the different types of path items
enum PathItemType { article, video, book, project, documentation }

// Model for a single item in the detailed path view
class PathItemDetail {
  final int id;
  final String title;
  final String? url;
  final PathItemType type;
  final int order;
  bool isCompleted;

  PathItemDetail({
    required this.id,
    required this.title,
    this.url,
    required this.type,
    required this.order,
    this.isCompleted = false,
  });

  // Helper method to get the correct icon based on the type
  IconData get icon {
    switch (type) {
      case PathItemType.article:
        return Icons.article_outlined;
      case PathItemType.video:
        return Icons.play_circle_outline;
      case PathItemType.book:
        return Icons.book_outlined;
      case PathItemType.project:
        return Icons.code;
      case PathItemType.documentation:
        return Icons.description_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  // Factory constructor to create a PathItemDetail from JSON
  factory PathItemDetail.fromJson(Map<String, dynamic> json) {
    // Convert the string type from the API to our enum
    final typeString = (json['type'] as String).toLowerCase();
    final type = PathItemType.values.firstWhere(
      (e) => e.toString().split('.').last == typeString,
      orElse: () => PathItemType.article, // Default to article if type is unknown
    );

    return PathItemDetail(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      type: type,
      order: json['order'],
      isCompleted: json['isCompleted'],
    );
  }
}

// Model for the entire detailed learning path
class LearningPathDetail {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final List<PathItemDetail> pathItems;

  LearningPathDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.pathItems,
  });

  factory LearningPathDetail.fromJson(Map<String, dynamic> json) {
    var itemsList = json['pathItems'] as List;
    List<PathItemDetail> pathItems = itemsList.map((i) => PathItemDetail.fromJson(i)).toList();

    return LearningPathDetail(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      pathItems: pathItems,
    );
  }
}
