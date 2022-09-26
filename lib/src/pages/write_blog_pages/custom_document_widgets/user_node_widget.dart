import 'package:cached_network_image/cached_network_image.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/user_node.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;

import '../../../theme/color_theme.dart';
import '../../blog_page.dart';
import '../doc_to_custom_widget_generator.dart';

class UserNodeWidget extends StatelessWidget {
  const UserNodeWidget({
    Key? key,
    required this.setTextStyle,
    required this.node,
    required this.padding,
  }) : super(key: key);

  final UserNode node;
  final TextStyle setTextStyle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final textSpans = DocToCustomWidgetGenerator.computeTextSpan(
      node.text,
      startOffset: node.beginningPosition.offset,
      endOffset: node.endPosition.offset,
    );
    final dateTime =
        intl.DateFormat('EEE, MMM d, yyyy').format(node.blogUpdatedAt);
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //category info
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CategoriesBlogPage(categoryInfo: node.blogInfo.category);
              }));
            },
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.4,
                    color: ColorTheme.bgColor14,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Text(
                  node.blogInfo.category.label,
                  style: GoogleFonts.rubik(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: ColorTheme.bgColor10,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20.0,
          ),

          //user info
          Row(
            children: [
              //cat image
              Container(
                constraints: BoxConstraints.tight(
                  const Size.square(80.0),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      node.userInfo.image?.generatedUri.isEmpty ?? true
                          ? "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_960_720.png"
                          : node.userInfo.image!.generatedUri,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(
                width: 10.0,
              ),

              //cat name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //user name
                  RichText(
                    text: TextSpan(
                      children: [textSpans],
                      style: setTextStyle,
                    ),
                  ),

                  const SizedBox(
                    height: 5.0,
                  ),

                  //date of published
                  Text(
                    dateTime,
                    style: GoogleFonts.openSans(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(
                    height: 5.0,
                  ),

                  Text(
                    "Reading time ${node.blogInfo.readingTime.roundToDouble()} min",
                    style: GoogleFonts.openSans(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ],
          ),

          //share link

          //date of published
        ],
      ),
    );
  }
}
