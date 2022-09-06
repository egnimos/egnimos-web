import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class HorizontalRuleNodeWidget extends StatelessWidget {
  const HorizontalRuleNodeWidget({
    Key? key,
    required this.padding,
    this.color = Colors.grey,
    this.thickness = 1,
  }) : super(key: key);
  final double thickness;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Divider(
        color: color,
        thickness: thickness,
      ),
    );
  }
}
