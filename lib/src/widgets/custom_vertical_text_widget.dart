import 'package:flutter/material.dart';

class CustomVerticalTextWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  const CustomVerticalTextWidget(
    this.text, {
    Key? key,
    this.textStyle = const TextStyle(fontSize: 22),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 30,
      clipBehavior: Clip.hardEdge,
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      children: text
          .split("")
          .map(
            (string) => Text(
              string,
              style: textStyle,
            ),
          )
          .toList(),
    );
  }
}
