import 'package:cloud_firestore/cloud_firestore.dart';

import 'category.dart';

class Blog {
  final String id;
  final String userId;
  final Category category;
  final String title;
  final String description;
  final String coverImage;
  final List<String> tags;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Blog({
    required this.id,
    required this.userId,
    required this.category,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  //fromJson
  factory Blog.fromJson(Map<String, dynamic> data) => Blog(
        id: data["id"],
        userId: data["user_id"],
        category: Category.fromJson(data["category"]),
        title: data["title"]??"",
        description: data["description"]??"",
        coverImage: data["cover_image"]??"",
        tags: List<String>.from(data["tags"]),
        createdAt: data["created_at"],
        updatedAt: data["updated_at"],
      );

  //toJson
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "category": category.toJson(),
        "title": title,
        "description": description,
        "cover_image": coverImage,
        "tags": tags,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
