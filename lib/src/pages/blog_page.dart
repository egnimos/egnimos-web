import 'package:cloud_firestore/cloud_firestore.dart';
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

class BlogPage extends StatefulWidget {
  static const routeName = "blog-page";
  const BlogPage({Key? key}) : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  bool _isBlogLoading = true;
  final _isPaginationLoading = ValueNotifier<bool>(false);
  DocumentSnapshot? lastDoc;

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
            categories: [],
            heading: "Most Recent",
            isLoading: _isBlogLoading,
            onClick: (val) async {
              try {
                if (!_isBlogLoading) {
                  setState(() {
                    _isBlogLoading = true;
                  });
                }
                lastDoc =
                    await Provider.of<BlogProvider>(context, listen: false)
                        .getPublishedBlogSnaps(val, lastDoc);
              } catch (error) {
                print(error);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Failed to load the data ${error.toString()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                    // backgroundColor: Colors.red.shade600,
                  ),
                );
              } finally {
                setState(() {
                  _isBlogLoading = false;
                });
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
