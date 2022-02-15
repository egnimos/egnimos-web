import 'package:egnimos/src/models/category.dart';
import 'package:egnimos/src/widgets/blog_post_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/color_theme.dart';
import '../utility/enum.dart';

class BlogList extends StatelessWidget {
  final String heading;
  final List<Category> categories;
  final void Function() onClick;

  const BlogList({
    required this.onClick,
    required this.categories,
    required this.heading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 20.0,
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              //heading
              Flexible(
                child: Text(
                  heading,
                  style: GoogleFonts.rubik().copyWith(
                    fontSize: (constraints.maxWidth / 100) * 2.6,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: ColorTheme.bgColor,
                  ),
                ),
              ),

              const SizedBox(
                height: 20.0,
              ),

              Divider(
                height: 0.0,
                endIndent: 10.0,
                indent: 10.0,
                color: Colors.grey.shade400,
                thickness: 0.5,
              ),

              BlogCategoryList(
                categories: categories,
                onClick: onClick,
              ),
              const SizedBox(
                height: 20.0,
              ),

              //Blogs
              Wrap(
                children: List<int>.generate(10, (int index) => index * index,
                        growable: false)
                    .map((e) => const BlogPostCard())
                    .toList(),
              ),

              const SizedBox(
                height: 100.0,
              ),

              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 6.0,
                  fixedSize: const Size(150.0, 50.0),
                  minimumSize: const Size(150.0, 50.0),
                  side: const BorderSide(color: ColorTheme.bgColor10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "Load More",
                  style: GoogleFonts.rubik().copyWith(
                    fontSize: 18.0,
                    // letterSpacing: 1.1,
                    fontWeight: FontWeight.w500,
                    color: ColorTheme.bgColor10,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

class BlogCategoryList extends StatefulWidget {
  final List<Category> categories;
  final void Function() onClick;

  const BlogCategoryList({
    required this.categories,
    required this.onClick,
    Key? key,
  }) : super(key: key);

  @override
  _BlogCategoryListState createState() => _BlogCategoryListState();
}

class _BlogCategoryListState extends State<BlogCategoryList> {
  Cat _selectedCat = Cat.all;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.categories
            .map(
              (cat) => BlogType(
                cat: cat,
                selectedCat: _selectedCat,
                onSelect: (val) {
                  setState(() {
                    _selectedCat = val;
                  });
                  widget.onClick();
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class BlogType extends StatefulWidget {
  final Category cat;
  final Cat selectedCat;
  final void Function(Cat cat) onSelect;

  const BlogType({
    required this.cat,
    required this.selectedCat,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  State<BlogType> createState() => _BlogTypeState();
}

class _BlogTypeState extends State<BlogType> {
  double height = 0.0;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          height = 6.0;
        });
      },
      onExit: (value) {
        setState(() {
          height = 0.0;
        });
      },
      child: GestureDetector(
        onTap: () => widget.onSelect(widget.cat.catEnum),
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            height: 70.0,
            child: Column(
              children: [
                Container(
                  height:
                      widget.selectedCat == widget.cat.catEnum ? 6.0 : height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: ColorTheme.bgColor10,
                  ),
                ),
                const Spacer(),
                Text(
                  widget.cat.label,
                  style: GoogleFonts.rubik().copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
