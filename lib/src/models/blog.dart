import 'package:cloud_firestore/cloud_firestore.dart';

import 'category.dart';

class Blog {
  final String id;
  final Category category;
  final String title;
  final String description;
  final String coverImage;
  final String readingTime;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Blog({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.readingTime,
    required this.createdAt,
    required this.updatedAt,
  });

  //fromJson
  factory Blog.fromJson(Map<String, dynamic> data) => Blog(
        id: data["id"],
        category: Category.fromJson(data["category"]),
        title: data["title"],
        description: data["description"],
        coverImage: data["cover_image"],
        readingTime: data["reading_time"],
        createdAt: data["created_at"],
        updatedAt: data["updated_at"],
      );

  //toJson
  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category.toJson(),
        "title": title,
        "description": description,
        "cover_image": coverImage,
        "reading_time": readingTime,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
