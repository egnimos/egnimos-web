import 'package:egnimos/src/utility/convert.dart';
import 'package:egnimos/src/utility/enum.dart';

class Category {
  final String label;
  final int? color;
  final Cat catEnum;

  Category({
    required this.label,
    this.color,
    required this.catEnum,
  });

  factory Category.fromJson(Map<String, dynamic> data) => Category(
        label: data["label"],
        color: data["color"],
        catEnum: Convert.stringToenum<Cat>(
            Cat.values, data["cat_enum"], () => Cat.unknown),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "color": color,
        "cat_enum": Convert.enumTostring(Cat.values, catEnum, () => null),
      };
}
