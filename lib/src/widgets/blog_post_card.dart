import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/src/models/blog.dart';
import 'package:egnimos/src/pages/blog_page.dart';
import 'package:egnimos/src/pages/view_blog_page.dart';
import 'package:egnimos/src/pages/write_blog_pages/write_blog_page.dart';
import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../providers/auth_provider.dart';
import '../providers/style_provider.dart';
import '../theme/color_theme.dart';
import '../utility/prefs_keys.dart';

class BlogPostCard extends StatelessWidget {
  final Blog blog;
  final BlogType blogType;
  final bool showEditOptions;
  final bool isForAdmin;

  const BlogPostCard({
    this.isForAdmin = false,
    required this.blog,
    this.showEditOptions = true,
    this.blogType = BlogType.published,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDeleting = ValueNotifier<bool>(false);
    final isTransfering = ValueNotifier<bool>(false);
    final selectedTag = ValueNotifier<String>("");
    final dateTime =
        DateFormat('EEE, MMM d, yyyy').format(blog.updatedAt.toDate());
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CategoriesBlogPage(categoryInfo: blog.category);
                    }));
                  },
                  child: Container(
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
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (contex) => ViewBlogPage(
                          blogSnap: blog,
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
                dateTime,
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
                child: Wrap(
                  children: blog.tags
                      .map(
                        (tag) => //tag
                            MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (val) {
                            selectedTag.value = tag;
                          },
                          onExit: (val) {
                            selectedTag.value = "";
                          },
                          child: GestureDetector(
                            onTap: () {
                              print(tag);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return TagsBlogPage(
                                  tag: tag,
                                );
                              }));
                            },
                            child: ValueListenableBuilder<String>(
                              valueListenable: selectedTag,
                              builder: (context, value, child) => Text(
                                "$tag ",
                                style: GoogleFonts.handlee(
                                  fontSize: 22.0,
                                  decoration: tag == value
                                      ? TextDecoration.underline
                                      : null,
                                  decorationThickness: 2.0,
                                  decorationColor: Colors.blue.shade600,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
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
                mainAxisAlignment: isForAdmin
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  //edit
                  if (!isForAdmin)
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

                  if (blogType == BlogType.draft)
                    //transfer
                    ValueListenableBuilder<bool>(
                      valueListenable: isTransfering,
                      builder: (context, value, child) => optionWidget(
                        onClick: () async {
                          try {
                            isTransfering.value = true;
                            //publish the blog
                            await Provider.of<BlogProvider>(context,
                                    listen: false)
                                .publishBlog(blog);
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                              ),
                            );
                          } finally {
                            isTransfering.value = false;
                          }
                        },
                        color: Colors.blue,
                        label: value ? "Processing..." : "Publish",
                        radius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                    ),

                  //delete
                  ValueListenableBuilder<bool>(
                    valueListenable: isDeleting,
                    builder: (context, value, child) => optionWidget(
                      onClick: () async {
                        isDeleting.value = true;
                        await Provider.of<StyleProvider>(context, listen: false)
                            .deleteStyle(blog.id);
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
