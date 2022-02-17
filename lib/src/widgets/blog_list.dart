import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/src/models/blog.dart';
import 'package:egnimos/src/models/category.dart';
import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/widgets/blog_post_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../config/k.dart';
import '../theme/color_theme.dart';
import '../utility/enum.dart';

class BlogList extends StatelessWidget {
  final String heading;
  final bool isLoading;
  final List<Category> categories;
  final void Function(Cat catType) onClick;

  const BlogList({
    required this.onClick,
    required this.isLoading,
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
                    fontSize: constraints.maxWidth > K.kTableteWidth
                        ? (constraints.maxWidth / 100) * 2.6
                        : 22.0,
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
                constraints: constraints,
                onClick: (val) => onClick,
              ),
              const SizedBox(
                height: 20.0,
              ),

              //Blogs
              if (isLoading)
                const Align(
                  child: CircularProgressIndicator(),
                )
              else
                Consumer<BlogProvider>(
                  builder: (context, bp, __) => bp.blogs.isEmpty
                      ? Container(
                          width: double.infinity,
                          height: 250.0,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Expanded(
                                child: Lottie.asset(
                                  "assets/json/not-found.json",
                                  reverse: true,
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "no blog post available",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ),
                        )
                      : Wrap(
                          children: bp.blogs
                              .map((bo) => BlogPostCard(blog: bo))
                              .toList(),
                        ),
                ),

              //error
              // if (snapshot.hasError) {
              //   return Align(
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text(snapshot.error.toString()),
              //     ),
              //   );
              // }

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
  final BoxConstraints constraints;
  final void Function(Cat catType) onClick;

  const BlogCategoryList({
    required this.categories,
    required this.constraints,
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
                constraints: widget.constraints,
                cat: cat,
                selectedCat: _selectedCat,
                onSelect: (val) {
                  setState(() {
                    _selectedCat = val;
                  });
                  widget.onClick(val);
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
  final BoxConstraints constraints;
  final void Function(Cat cat) onSelect;

  const BlogType({
    required this.cat,
    required this.selectedCat,
    required this.constraints,
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
                    fontSize: widget.constraints.maxWidth > K.kTableteWidth
                        ? (widget.constraints.maxWidth / 100) * 1.4
                        : 16.0,
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
