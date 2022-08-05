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
                      "We",
                      style: GoogleFonts.rubik().copyWith(
                        fontSize: (constraints.maxWidth / 100) * 4.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: leadingTextColor,
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   width: .0,
                  // ),
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
                          TypewriterAnimatedText(' Are Creative Team',
                              speed: const Duration(milliseconds: 300),
                              cursor: '_'),
                          TypewriterAnimatedText(' Provide',
                              speed: const Duration(milliseconds: 300),
                              cursor: '_'),
                          TypewriterAnimatedText(' Create',
                              speed: const Duration(milliseconds: 300),
                              cursor: '_'),
                          TypewriterAnimatedText(' Care About You',
                              speed: const Duration(milliseconds: 300),
                              cursor: '_'),
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
                    "The Creativity that needs to be done for building a thoughtful process that works smoothely and makes your business grow like never before.",
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
