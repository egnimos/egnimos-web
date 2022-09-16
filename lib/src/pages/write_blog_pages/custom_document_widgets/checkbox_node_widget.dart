

import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/checkbox_node.dart';
import 'package:flutter/material.dart';

import '../doc_to_custom_widget_generator.dart';

///[CheckboxNodeWidget] to display
///the check node in the widget format
class CheckboxNodeWidget extends StatelessWidget {
  const CheckboxNodeWidget({
    Key? key,
    required this.node,
    required this.setStyleTextStyle,
    required this.padding,
    this.indentCalculator = _defaultIndentCalculator,
  }) : super(key: key);

  final double Function(double, int indent) indentCalculator;
  final CheckboxNode node;
  final TextStyle setStyleTextStyle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final textSpans = DocToCustomWidgetGenerator.computeTextSpan(
      node.text,
      startOffset: node.beginningPosition.offset,
      endOffset: node.endPosition.offset,
    );
    final fontSize = setStyleTextStyle.fontSize ?? 18.0;
    final indentSpace = indentCalculator(fontSize, node.indent);
    final lineHeight = setStyleTextStyle.fontSize! * (1.0);
    const manualVerticalAdjustment = 3.0;
    final isComplete = ValueNotifier<bool>(node.isComplete);
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: indentSpace,
            margin: const EdgeInsets.only(top: manualVerticalAdjustment),
            child: SizedBox(
              height: lineHeight,
              child: ValueListenableBuilder<bool>(
                valueListenable: isComplete,
                builder: (context, value, child) => Checkbox(
                  value: value,
                  onChanged: (newValue) {
                    isComplete.value = newValue!;
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: isComplete,
              builder: (context, value, child) => RichText(
                text: TextSpan(
                  children: [textSpans],
                  style: setStyleTextStyle.copyWith(
                    decoration: value ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

double _defaultIndentCalculator(double fontSize, int indent) {
  return (fontSize * 0.60) * 4 * (indent + 1);
}
