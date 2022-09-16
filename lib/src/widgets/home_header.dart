import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:egnimos/src/config/k.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  final Color? leadingTextColor;
  final Color animatedTextColor;
  final Color? infoColor;
  const HomeHeader({
    Key? key,
    this.animatedTextColor = ColorTheme.bgColor10,
    this.infoColor,
    this.leadingTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return SizedBox(
          width: double.infinity,
          height: constraints.maxWidth >= K.kTableteWidth ? 600.0 : 400.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "A Place ",
                      style: GoogleFonts.openSans().copyWith(
                        fontSize: (constraints.maxWidth / 100) * 4.2,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: leadingTextColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: DefaultTextStyle(
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textWidthBasis: TextWidthBasis.longestLine,
                      style: GoogleFonts.rubik().copyWith(
                        fontSize: (constraints.maxWidth / 100) * 4.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: animatedTextColor,
                      ),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'To Write',
                            textStyle: GoogleFonts.gochiHand(
                              // decoration: TextDecoration.underline,
                              // decorationStyle: TextDecorationStyle.wavy,
                              fontSize: (constraints.maxWidth / 100) * 5.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: animatedTextColor,
                            ),
                            speed: const Duration(milliseconds: 300),
                            cursor: '_',
                          ),
                          TypewriterAnimatedText(
                            'To Share',
                            textStyle: GoogleFonts.shareTech(
                              fontSize: (constraints.maxWidth / 100) * 4.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: animatedTextColor,
                            ),
                            speed: const Duration(milliseconds: 300),
                            cursor: '_',
                          ),
                          TypewriterAnimatedText(
                            'To Learn',
                            textStyle: GoogleFonts.raleway(
                              fontSize: (constraints.maxWidth / 100) * 4.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: animatedTextColor,
                            ),
                            speed: const Duration(milliseconds: 300),
                            cursor: '_',
                          ),
                          TypewriterAnimatedText(
                            'To Try',
                            textStyle: GoogleFonts.indieFlower(
                              fontSize: (constraints.maxWidth / 100) * 5.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: animatedTextColor,
                            ),
                            speed: const Duration(milliseconds: 300),
                            cursor: '_',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: (constraints.maxWidth / 100) * 1.8,
              ),

              //description
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    "The Creativity that needs to be done for building a thoughtful process that works smoothly and makes your content grow like never before.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway().copyWith(
                      color: infoColor,
                      fontSize: constraints.maxWidth > K.kMobileWidth
                          ? (constraints.maxWidth / 100) * 2.3
                          : 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
