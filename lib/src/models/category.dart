import 'package:egnimos/src/utility/convert.dart';
import 'package:egnimos/src/utility/enum.dart';

class Category {
  final String id;
  final String label;
  final int? color;
  final String image;
  final Cat catEnum;

  Category({
    required this.id,
    required this.label,
    this.color,
    required this.image,
    required this.catEnum,
  });

  factory Category.fromJson(Map<String, dynamic> data) => Category(
        id: data["id"],
        label: data["label"],
        color: data["color"],
        image: data["image"],
        catEnum: Convert.stringToenum<Cat>(
            Cat.values, data["cat_enum"], () => Cat.unknown),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "color": color,
        "image": image,
        "cat_enum": Convert.enumTostring(Cat.values, catEnum, () => null),
      };
}
