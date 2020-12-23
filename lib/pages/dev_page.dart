import 'package:egnimos/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class DevPage extends StatelessWidget {
  static const routeName = "dev-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header1(
        context,
        title: "egnimos",
        selectedButtonKey: "dev",
      ),
    );
  }
}
