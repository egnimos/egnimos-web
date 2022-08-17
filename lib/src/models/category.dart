import 'package:egnimos/src/providers/upload_provider.dart';
import 'package:egnimos/src/utility/convert.dart';
import 'package:egnimos/src/utility/enum.dart';

class Category {
  final String id;
  final String label;
  final int? color;
  final UploadOutput? image;
  final String description;
  final Cat catEnum;

  Category({
    required this.id,
    required this.label,
    this.color,
    required this.image,
    required this.description,
    required this.catEnum,
  });

  factory Category.fromJson(Map<String, dynamic> data) => Category(
        id: data["id"],
        label: data["label"],
        color: data["color"],
        image: UploadOutput.fromJson(data["image"]),
        description: data["description"],
        catEnum: Convert.stringToenum<Cat>(
            Cat.values, data["cat_enum"], () => Cat.unknown),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "color": color,
        "image": image?.toJson(),
        "description": description,
        "cat_enum": Convert.enumTostring(Cat.values, catEnum, () => null),
      };
}
