import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/blog_list.dart';
import 'package:egnimos/src/widgets/footer.dart';
import 'package:egnimos/src/widgets/nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utility/data/categories.dart';
import '../widgets/blog_header.dart';
import '../widgets/menu.dart';

class Blog extends StatefulWidget {
  static const routeName = "blog-page";
  const Blog({Key? key}) : super(key: key);

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  bool _isBlogLoading = false;
  bool _isUpdateBlogLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(selectedOption: NavOptions.blog),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          //nav
          const Nav(selectedOption: NavOptions.blog),
          //header
          const BlogHeader(),
          //most recent blog
          BlogList(
            categories: categories,
            heading: "Most Recent",
            isLoading: _isBlogLoading,
            onClick: (val) async {
              try {
                setState(() {
                  _isBlogLoading = true;
                });
                await Provider.of<BlogProvider>(context, listen: false)
                    .getBlogs(val);
                setState(() {
                  _isBlogLoading = false;
                });
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Failed to load the data",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    backgroundColor: Colors.red.shade300,
                  ),
                );
              }
            },
          ),
          //news and update
          BlogList(
            categories: updatesCategories,
            heading: "News/Updates",
            isLoading: _isUpdateBlogLoading,
            onClick: (val) async {
              try {
                setState(() {
                  _isUpdateBlogLoading = true;
                });
                await Provider.of<BlogProvider>(context, listen: false)
                    .getEgnimosUpdates(val);
                setState(() {
                  _isUpdateBlogLoading = false;
                });
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Failed to load the data",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    backgroundColor: Colors.red.shade300,
                  ),
                );
              }
            },
          ),
          //footer
          const Footer(),
        ],
      ),
    );
  }
}
