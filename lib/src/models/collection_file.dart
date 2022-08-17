class CollectionFile {
  final String id;
  final String userId;
  final String collectionName;
  final String fileName;
  final String extensionName;
  final String uri;
  final String createdAt;

  CollectionFile({
    required this.id,
    required this.userId,
    required this.collectionName,
    required this.fileName,
    required this.extensionName,
    required this.uri,
    required this.createdAt,
  });

  //fromJson
  factory CollectionFile.fromJson(Map<String, dynamic> data) => CollectionFile(
        id: data["id"],
        userId: data["user_id"],
        collectionName: data["collection_name"],
        fileName: data["file_name"],
        extensionName: data["extension"],
        uri: data["uri"],
        createdAt: data["created_at"],
      );

  //toJson
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "collection_name": collectionName,
        "file_name": fileName,
        "extension": extensionName,
        "uri": uri,
        "created_at": createdAt,
      };
}
