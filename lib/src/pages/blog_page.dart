import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/src/models/category.dart';
import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/blog_list.dart';
import 'package:egnimos/src/widgets/footer.dart';
import 'package:egnimos/src/widgets/nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/blog_header.dart';
import '../widgets/menu.dart';

class BlogPage extends StatefulWidget {
  static const routeName = "/blog-page";
  const BlogPage({Key? key}) : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  bool _isBlogLoading = true;
  // final _isPaginationLoading = ValueNotifier<bool>(false);
  DocumentSnapshot? lastDoc;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<BlogProvider>(context, listen: false)
          .updatePublishedBlogSnaps([]);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
                //print(error);
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

//Categories based blogs
class CategoriesBlogPage extends StatefulWidget {
  static const routeName = "/categories-blog-page";
  final Category categoryInfo;

  const CategoriesBlogPage({
    Key? key,
    required this.categoryInfo,
  }) : super(key: key);

  @override
  State<CategoriesBlogPage> createState() => _CategoriesBlogPageState();
}

class _CategoriesBlogPageState extends State<CategoriesBlogPage> {
  bool _isBlogLoading = true;
  // final _isPaginationLoading = ValueNotifier<bool>(false);
  DocumentSnapshot? lastDoc;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<BlogProvider>(context, listen: false)
          .updatePublishedBlogSnaps([]);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
          BlogHeader(
            categoryImage: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints.tight(
                  const Size.square(120.0),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.categoryInfo.image?.generatedUri.isEmpty ?? true
                          ? "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_960_720.png"
                          : widget.categoryInfo.image!.generatedUri,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            heading: widget.categoryInfo.label,
            info: widget.categoryInfo.description,
          ),
          //most recent blog
          BlogList(
            categories: [widget.categoryInfo],
            heading: "Based on Categories",
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
                        .getPublishedBlogSnaps(
                            widget.categoryInfo.catEnum, lastDoc);
              } catch (error) {
                //print(error);
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

//Tags based blogs
class TagsBlogPage extends StatefulWidget {
  static const routeName = "/tags-blog-page";
  final String tag;

  const TagsBlogPage({
    Key? key,
    required this.tag,
  }) : super(key: key);

  @override
  State<TagsBlogPage> createState() => _TagsBlogPageState();
}

class _TagsBlogPageState extends State<TagsBlogPage> {
  bool _isBlogLoading = true;
  // final _isPaginationLoading = ValueNotifier<bool>(false);
  DocumentSnapshot? lastDoc;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<BlogProvider>(context, listen: false)
            .updatePublishedBlogSnaps([]);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
          BlogHeader(
            heading: widget.tag,
            headingStyle: GoogleFonts.handlee(
              color: Colors.blue.shade600,
            ),
            info: "",
          ),

          //most recent blog
          BlogList(
            categories: [],
            heading: "Based on #tags",
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
                        .getTagBasedPublishedBlogSnaps(widget.tag, lastDoc);
              } catch (error) {
                //print(error);
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
