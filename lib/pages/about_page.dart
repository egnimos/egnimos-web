// import 'package:egnimos/config/responsive.dart';
// import 'package:egnimos/theme/colorsTheme.dart';
import 'dart:html';

import 'package:egnimos/config/responsive.dart';
import 'package:egnimos/widgets/footer_widget.dart';
import 'package:egnimos/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const routeName = "about-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header1(
        context,
        title: "egnimos",
        selectedButtonKey: "about",
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: SizeConfig.heightMultiplier * 100),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //heading
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, top: 40),
                  child: Text(
                    "About",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: SizeConfig.textMultiplier * 2.7,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                //content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 30.0,
                  ),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: SizeConfig.textMultiplier * 2.2,
                        ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 20.0,
                ),

                //footer
                Spacer(),
                FooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
