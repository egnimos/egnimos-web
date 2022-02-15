import 'package:egnimos/src/utility/convert.dart';
import 'package:egnimos/src/utility/enum.dart';

class Category {
  final String label;
  final Cat catEnum;

  const Category({
    required this.label,
    required this.catEnum,
  });

  factory Category.fromJson(Map<String, dynamic> data) => Category(
        label: data["label"],
        catEnum: Convert.stringToenum<Cat>(
            Cat.values, data["cat_enum"], () => Cat.unknown),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "cat_enum":
            Convert.enumTostring(Cat.values, catEnum, () => null),
      };
}
