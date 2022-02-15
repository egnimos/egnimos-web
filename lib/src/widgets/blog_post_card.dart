import 'package:egnimos/src/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/color_theme.dart';

class BlogPostCard extends StatelessWidget {
  final Blog blog;

  const BlogPostCard({
    required this.blog,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 19.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 30,
            spreadRadius: -15,
            offset: Offset(0, 60),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //image
            Container(
              height: 160.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://images.ctfassets.net/aq13lwl6616q/2PQ4cHChKkILIou8mTEKsl/59f4bf9bb8bfb7f89ee37050026663c4/5_Ways_to_Supercharge_Your_Figma_Designs.png?w=1280&h=720&q=50&fm=webp"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(
              height: 20.0,
            ),

            //date & reading time
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 10.0,
              ),
              child: Text(
                "Feburary 1st, 2022 . 10 min read",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            //title
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 5.0,
                ),
                child: Text(
                  "Title",
                  maxLines: 3,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rubik().copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: ColorTheme.bgColor,
                  ),
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
                  "All the recent articles and news or updates regarding egnimos are available here",
                  style: GoogleFonts.raleway().copyWith(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20.0,
            ),

            // writer
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 5.0,
              ),
              child: Text(
                "By- Niteesh Dubey",
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
