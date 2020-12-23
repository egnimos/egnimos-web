// import 'package:egnimos/config/responsive.dart';
// import 'package:egnimos/theme/colorsTheme.dart';
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
    );
  }
}
