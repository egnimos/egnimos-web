import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:egnimos/src/models/blog.dart';
import 'package:egnimos/src/pages/view_blog_page.dart';
import 'package:egnimos/src/pages/write_blog_pages/write_blog_page.dart';
import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../providers/auth_provider.dart';
import '../theme/color_theme.dart';
import '../utility/prefs_keys.dart';

class BlogPostCard extends StatelessWidget {
  final Blog blog;
  final BlogType blogType;
  final bool showEditOptions;

  const BlogPostCard({
    required this.blog,
    this.showEditOptions = true,
    this.blogType = BlogType.published,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDeleting = ValueNotifier<bool>(false);
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    print(user);
    return Container(
      width: 350.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 19.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20.0,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 10.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.0),
                    border: Border.all(
                      color: ColorTheme.bgColor2,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    blog.category.label,
                    style: GoogleFonts.openSans(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: ColorTheme.bgColor2,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (contex) => ViewBlogPage(
                          blogId: blog.id,
                          blogType: blogType,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 10.0,
                    ),
                    constraints: BoxConstraints.tight(
                      const Size.square(40.0),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(
                        color: ColorTheme.bgColor2,
                        width: 1.2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorTheme.bgColor2,
                    ),
                  ),
                ),
              ],
            ),

            //date & reading time
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 10.0,
              ),
              child: Text(
                "Feburary 1st, 2022 . 10 min read",
                style: GoogleFonts.openSans(
                  color: Colors.grey.shade800,
                ),
              ),
            ),

            //tags
            if (blog.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 5.0,
                ),
                child: Text(
                  blog.tags.join(" "),
                  style: TextStyle(
                    color: Colors.blue.shade600,
                  ),
                ),
              ),

            //title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 5.0,
              ),
              child: Text(
                blog.title,
                maxLines: 3,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.raleway(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: ColorTheme.bgColor,
                ),
              ),
            ),

            //description
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 5.0,
                ),
                child: Text(
                  blog.description,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30.0,
            ),

            //image
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                // vertical: 5.0,
              ),
              height: 160.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                // borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 30,
                    spreadRadius: -5,
                    offset: const Offset(0, 10),
                  )
                ],
                image: DecorationImage(
                  image: CachedNetworkImageProvider(blog.coverImage.isNotEmpty
                      ? blog.coverImage
                      : "https://images.ctfassets.net/aq13lwl6616q/2PQ4cHChKkILIou8mTEKsl/59f4bf9bb8bfb7f89ee37050026663c4/5_Ways_to_Supercharge_Your_Figma_Designs.png?w=1280&h=720&q=50&fm=webp"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(
              height: 50.0,
            ),

            if (user != null && blog.userId == user.id && showEditOptions)
              //decorator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //edit
                  optionWidget(
                    onClick: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return WriteBlogPage(
                          blogType: blogType,
                          blog: blog,
                        );
                      }));
                    },
                    color: ColorTheme.bgColor10,
                    label: "Edit",
                    radius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),

                  //delete
                  ValueListenableBuilder<bool>(
                    valueListenable: isDeleting,
                    builder: (context, value, child) => optionWidget(
                      onClick: () async {
                        isDeleting.value = true;
                        await Provider.of<BlogProvider>(context, listen: false)
                            .deleteBlog(blogType, blogId: blog.id);
                        isDeleting.value = false;
                      },
                      color: Colors.redAccent,
                      label: value ? "Deleting...." : "Delete",
                      radius: const BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget optionWidget({
    required VoidCallback onClick,
    required String label,
    required Color color,
    required BorderRadiusGeometry radius,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 19.0,
        ),
        decoration: BoxDecoration(
          borderRadius: radius,
          color: color,
        ),
        child: Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade50,
          ),
        ),
      ),
    );
  }
}
