import 'package:flutter/material.dart';

// Enum for the resource type
enum ResourceType { article, video, book, project, documentation, other }

// Model for a single resource link
class ResourceDetail {
  final int id;
  final String title;
  final String url;
  final ResourceType type;
  bool isCompleted;

  ResourceDetail({
    required this.id,
    required this.title,
    required this.url,
    required this.type,
    required this.isCompleted,
  });

  IconData get icon {
    switch (type) {
      case ResourceType.article:
        return Icons.article_outlined;
      case ResourceType.video:
        return Icons.play_circle_outline;
      case ResourceType.book:
        return Icons.book_outlined;
      case ResourceType.project:
        return Icons.code;
      case ResourceType.documentation:
        return Icons.description_outlined;
      default:
        return Icons.link;
    }
  }

  factory ResourceDetail.fromJson(Map<String, dynamic> json) {
    final typeString = (json['type'] as String? ?? 'other').toLowerCase();
    final type = ResourceType.values.firstWhere(
      (e) => e.name.toLowerCase() == typeString,
      orElse: () => ResourceType.other,
    );

    return ResourceDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Resource',
      url: json['url'] ?? '',
      type: type,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

// Model for a single item (a conceptual step) in the detailed path view
class PathItemDetail {
  final int id;
  final String title;
  final int order;
  bool isCompleted;
  final List<ResourceDetail> resources;

  PathItemDetail({
    required this.id,
    required this.title,
    required this.order,
    required this.isCompleted,
    required this.resources,
  });

  factory PathItemDetail.fromJson(Map<String, dynamic> json) {
    var resourcesList = json['resources'] as List? ?? [];
    List<ResourceDetail> resources = resourcesList.map((i) => ResourceDetail.fromJson(i)).toList();

    return PathItemDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Step',
      order: json['order'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      resources: resources,
    );
  }
}

// Model for the entire detailed learning path
class LearningPathDetail {
  // The property is now correctly named userPathId
  final int userPathId;
  final String title;
  final String description;
  final DateTime createdAt;
  final List<PathItemDetail> pathItems;
  final int pathTemplateId;
  final bool hasBeenRated;

  LearningPathDetail({
    required this.userPathId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.pathItems,
    required this.pathTemplateId,
    required this.hasBeenRated,
  });

  factory LearningPathDetail.fromJson(Map<String, dynamic> json) {
    var itemsList = json['pathItems'] as List? ?? [];
    List<PathItemDetail> pathItems = itemsList.map((i) => PathItemDetail.fromJson(i)).toList();

    return LearningPathDetail(
      // Read from the correct JSON key: 'userPathId'
      userPathId: json['userPathId'] ?? 0,
      title: json['title'] ?? 'Untitled Path',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      pathItems: pathItems,
      pathTemplateId: json['pathTemplateId'],
      hasBeenRated: json['hasBeenRated'] ?? false
    );
  }
}
