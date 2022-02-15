import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/blog_list.dart';
import 'package:egnimos/src/widgets/footer.dart';
import 'package:egnimos/src/widgets/nav.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../widgets/blog_header.dart';

const List<Category> blogCategories = [
  Category(label: "All Posts", catEnum: Cat.all),
  Category(label: "Must Read", catEnum: Cat.mustRead),
  Category(label: "Programming", catEnum: Cat.programming),
  Category(label: "Design", catEnum: Cat.design),
];

const List<Category> newCategories = [
  Category(label: "All Updates", catEnum: Cat.all)
];

class Blog extends StatelessWidget {
  static const routeName = "blog-page";
  const Blog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          //nav
          const Nav(selectedOption: NavOptions.blog),
          //header
          const BlogHeader(),
          //most recent blog
          BlogList(
            categories: blogCategories,
            heading: "Most Recent",
            onClick: () {},
          ),
          //news and update
          BlogList(
            categories: newCategories,
            heading: "News/Updates",
            onClick: () {},
          ),
          //footer
          const Footer(),
        ],
      ),
    );
  }
}
