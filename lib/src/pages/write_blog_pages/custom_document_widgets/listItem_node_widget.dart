import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../doc_to_custom_widget_generator.dart';

class ListItemNodeWidget extends StatelessWidget {
  const ListItemNodeWidget({
    Key? key,
    required this.node,
    required this.setTextStyle,
    required this.padding,
    required this.index,
  }) : super(key: key);
  final ListItemNode node;
  final TextStyle setTextStyle;
  final EdgeInsetsGeometry padding;
  final int index;

  @override
  Widget build(BuildContext context) {
    return node.type == ListItemType.ordered
        ? OrderedListItemNodeWidget(
            node: node,
            setTextStyle: setTextStyle,
            index: index,
            padding: padding,
          )
        : UnorderedListItemNodeWidget(
            node: node,
            setTextStyle: setTextStyle,
            padding: padding,
          );
  }
}

/// Displays a un-ordered list item in a document.
///
/// Supports various indentation levels, e.g., 1, 2, 3, ...
class UnorderedListItemNodeWidget extends StatelessWidget {
  const UnorderedListItemNodeWidget({
    Key? key,
    this.dotBuilder = _defaultUnorderedListItemDotBuilder,
    this.indentCalculator = _defaultIndentCalculator,
    required this.node,
    required this.setTextStyle,
    required this.padding,
  }) : super(key: key);
  final ListItemNode node;
  final TextStyle setTextStyle;
  final EdgeInsetsGeometry padding;
  final UnorderedListItemDotBuilder dotBuilder;
  final double Function(TextStyle, int indent) indentCalculator;

  @override
  Widget build(BuildContext context) {
    final textSpans = DocToCustomWidgetGenerator.computeTextSpan(
      node.text,
      startOffset: node.beginningPosition.offset,
      endOffset: node.endPosition.offset,
    );
    final textStyle = setTextStyle;
    final indentSpace = indentCalculator(textStyle, node.indent);
    final lineHeight = textStyle.fontSize! * (textStyle.height ?? 1.25);
    const manualVerticalAdjustment = 3.0;

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
              child: dotBuilder(context, setTextStyle),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [textSpans],
                style: setTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef UnorderedListItemDotBuilder = Widget Function(BuildContext, TextStyle);

Widget _defaultUnorderedListItemDotBuilder(
    BuildContext context, TextStyle style) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: style.color,
      ),
    ),
  );
}

/// Displays an ordered list item in a document.
///
/// Supports various indentation levels, e.g., 1, 2, 3, ...
class OrderedListItemNodeWidget extends StatelessWidget {
  const OrderedListItemNodeWidget({
    Key? key,
    this.numeralBuilder = _defaultOrderedListItemNumeralBuilder,
    this.indentCalculator = _defaultIndentCalculator,
    required this.node,
    required this.setTextStyle,
    required this.index,
    required this.padding,
  }) : super(key: key);

  final ListItemNode node;
  final int index;
  final TextStyle setTextStyle;
  final EdgeInsetsGeometry padding;
  final OrderedListItemNumeralBuilder numeralBuilder;
  final double Function(TextStyle, int indent) indentCalculator;

  @override
  Widget build(BuildContext context) {
    final textSpans = DocToCustomWidgetGenerator.computeTextSpan(
      node.text,
      startOffset: node.beginningPosition.offset,
      endOffset: node.endPosition.offset,
    );
    final textStyle = setTextStyle;
    final indentSpace = indentCalculator(textStyle, node.indent);
    final lineHeight = textStyle.fontSize! * (textStyle.height ?? 1.25);
    // const manualVerticalAdjustment = 3.0;

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: indentSpace,
            height: lineHeight,
            child: SizedBox(
              height: lineHeight,
              child: numeralBuilder(context, index, setTextStyle),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [textSpans],
                style: setTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef OrderedListItemNumeralBuilder = Widget Function(
    BuildContext, int, TextStyle);

double _defaultIndentCalculator(TextStyle textStyle, int indent) {
  return (textStyle.fontSize! * 0.60) * 4 * (indent + 1);
}

Widget _defaultOrderedListItemNumeralBuilder(
    BuildContext context, int index, TextStyle style) {
  return OverflowBox(
    maxWidth: double.infinity,
    maxHeight: double.infinity,
    child: Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Text(
          '$index.',
          textAlign: TextAlign.right,
          style: style.copyWith(),
        ),
      ),
    ),
  );
}
