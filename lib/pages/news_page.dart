import 'package:egnimos/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  static const routeName = "news-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header1(
        context,
        title: "egnimos",
        selectedButtonKey: "news",
      ),
    );
  }
}
