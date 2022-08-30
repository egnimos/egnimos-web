import 'package:egnimos/src/models/category.dart';
import 'package:egnimos/src/widgets/category_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/responsive.dart';
import '../../theme/color_theme.dart';

final selectedCategory = ValueNotifier<Category?>(null);

class CategoryOptionWidget extends StatelessWidget {
  const CategoryOptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Responsive.heightMultiplier * 100.0,
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          //heading
          Align(
            child: Text(
              "Categories",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.rubik(
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ),
          //liner as a indicator
          Container(
            width: double.infinity,
            height: 4.0,
            margin: const EdgeInsets.only(
              right: 10.0,
              left: 10.0,
              top: 5.0,
              bottom: 20.0,
            ),
            decoration: BoxDecoration(
              color: ColorTheme.bgColor18,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),

          //collection list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: CategoryListWidget(
              disableActions: true,
              selectedCategories: (category) {
                print(category);
                selectedCategory.value = category;
              },
              constraints: BoxConstraints(
                maxWidth: Responsive.widthMultiplier * 100.0,
                maxHeight: Responsive.heightMultiplier * 100.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
