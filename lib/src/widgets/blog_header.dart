import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/k.dart';
import '../theme/color_theme.dart';

class BlogHeader extends StatelessWidget {
  final Widget? categoryImage;
  final String heading;
  final TextStyle? headingStyle;
  final String info;
  final TextStyle? infoStyle;
  const BlogHeader({
    Key? key,
    this.categoryImage,
    this.headingStyle,
    this.infoStyle,
    this.heading = "egnimos blog",
    this.info =
        "All the recent articles and news or updates \nregarding egnimos are available here",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.only(left: 30.0),
        width: constraints.maxWidth >= K.kTableteWidth
            ? (constraints.maxWidth / 100.0) * 50.0
            : (constraints.maxWidth / 100.0) * 30.0,
        height: constraints.maxWidth >= K.kTableteWidth ? 500.0 : 400.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            categoryImage ?? const SizedBox.shrink(),
            if (categoryImage != null)
              const SizedBox(
                height: 20.0,
              ),
            Flexible(
              child: Text(
                heading,
                style: headingStyle?.copyWith(
                      fontSize: constraints.maxWidth > K.kTableteWidth
                          ? (constraints.maxWidth / 100) * 4.5
                          : 30.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ) ??
                    GoogleFonts.rubik(
                      fontSize: constraints.maxWidth > K.kTableteWidth
                          ? (constraints.maxWidth / 100) * 4.5
                          : 26.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: ColorTheme.bgColor,
                    ),
                // .copyWith(
                //   color: headingStyle?.color,
                // ),
              ),
            ),
            if (info.isNotEmpty)
              const SizedBox(
                height: 20.0,
              ),
            if (info.isNotEmpty)
              Flexible(
                child: Text(
                  info,
                  style: GoogleFonts.raleway(
                    textStyle: infoStyle,
                    fontSize: constraints.maxWidth > K.kMobileWidth
                        ? (constraints.maxWidth / 100) * 2.2
                        : 16.0,
                  ),
                ),
              )
          ],
        ),
      );
    });
  }
}
