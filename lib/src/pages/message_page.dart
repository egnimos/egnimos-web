import 'package:egnimos/src/config/responsive.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MessagePage extends StatelessWidget {
  final String message;
  const MessagePage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 20.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //nav
                const Nav(selectedOption: NavOptions.unknown),

                const SizedBox(
                  height: 50.0,
                ),

                //animations
                LottieBuilder.asset(
                  "assets/json/working.json",
                  repeat: true,
                ),

                const SizedBox(
                  height: 40.0,
                ),

                //message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontSize: Responsive.textMultiplier * 3.6,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    color: ColorTheme.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
