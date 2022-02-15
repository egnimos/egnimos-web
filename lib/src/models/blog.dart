class Blog {
  final String id;
  final String category;
  final String title;
  final String description;
  final String coverImage;
  final String readingTime;
  final String dateCreated;
  final String updatedAt;

  Blog({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.readingTime,
    required this.dateCreated,
    required this.updatedAt,
  });

  //fromJson
  factory Blog.fromJson(Map<String, dynamic> data) => Blog(
      id: data["id"],
      category: data["category"],
      title: data["title"],
      description: data["description"],
      coverImage: data["cover_image"],
      readingTime: data["reading_time"],
      dateCreated: data["date_created"],
      updatedAt: data["updated_at"]);

  //toJson
  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "title": title,
        "description": description,
        "cover_image": coverImage,
        "reading_time": readingTime,
        "date_created": dateCreated,
        "updated_at": updatedAt,
      };
}
