class BlogDoc {
  final String id;
  final String blogId;
  final String doc;

  BlogDoc({
    required this.id,
    required this.blogId,
    required this.doc,
  });

  factory BlogDoc.fromJson(Map<String, dynamic> data) => BlogDoc(
        id: data["id"],
        blogId: data["blog_id"],
        doc: data["doc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "blog_id": blogId,
        "doc": doc,
      };
}
