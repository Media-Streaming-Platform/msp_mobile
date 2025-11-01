// models/media.dart
class Media {
  final String? id;
  final String title;
  final String? description;
  final String type; // "video" or "audio"
  final String? categoryId;
  final String filePath;
  final int? numberOfViews;
  final String? thumbnail;
  final bool isPublished;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Media({
    this.id,
    required this.title,
    this.description,
    required this.type,
    this.categoryId,
    required this.filePath,
    this.numberOfViews,
    this.thumbnail,
    this.isPublished = false,
    this.createdAt,
    this.updatedAt,
  });

  /// ✅ Create a Media object from JSON
  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      type: json['type'] ?? '',
      categoryId: json['categories']?['_id'] ?? json['categories'],
      filePath: json['filePath'] ?? '',
      numberOfViews: json['numberOfViews'],
      thumbnail: json['thumbnail'],
      isPublished: json['isPublished'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  /// ✅ Convert Media object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'categories': categoryId,
      'filePath': filePath,
      'numberOfViews': numberOfViews,
      'thumbnail': thumbnail,
      'isPublished': isPublished,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// ✅ Create from a Map (alternative)
  factory Media.fromMap(Map<String, dynamic> map) => Media.fromJson(map);

  /// ✅ Convert to a Map (alternative)
  Map<String, dynamic> toMap() => toJson();
}
