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
        return SingleChildScrollView(
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
              Flexible(
                child: Text(
                  message,
                  style: GoogleFonts.rubik(
                    fontSize: (constraints.maxWidth / 100) * 2.6,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: ColorTheme.primaryTextColor,
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
