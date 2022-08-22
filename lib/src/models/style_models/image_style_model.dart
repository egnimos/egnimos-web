class ImageStyleModel {
  final String blockId;
  final num? width;

  ImageStyleModel({
    required this.blockId,
    required this.width,
  });

  //fromJson
  factory ImageStyleModel.fromJson(Map<String, dynamic> data) =>
      ImageStyleModel(
        blockId: data["block_id"],
        width: data["width"],
      );

  //toJson
  Map<String, dynamic> toJson() => {
        "block_id": blockId,
        "width": width,
      };
}
