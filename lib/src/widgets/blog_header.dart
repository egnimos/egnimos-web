import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/k.dart';
import '../theme/color_theme.dart';

class BlogHeader extends StatelessWidget {
  const BlogHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.only(left: 30.0),
        width: double.infinity,
        height: constraints.maxWidth >= K.kTableteWidth ? 500.0 : 400.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                "egnimos blog",
                style: GoogleFonts.rubik().copyWith(
                  fontSize: constraints.maxWidth > K.kTableteWidth
                      ? (constraints.maxWidth / 100) * 4.5
                      : 26.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: ColorTheme.bgColor,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Flexible(
              child: Text(
                "All the recent articles and news or updates \nregarding egnimos are available here",
                style: GoogleFonts.raleway().copyWith(
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
