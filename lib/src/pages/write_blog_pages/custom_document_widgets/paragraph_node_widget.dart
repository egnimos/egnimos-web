import 'package:egnimos/src/pages/write_blog_pages/doc_to_custom_widget_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:super_editor/super_editor.dart';

class ParagraphNodeWidget extends StatelessWidget {
  const ParagraphNodeWidget({
    Key? key,
    required this.node,
    required this.setTextStyle,
    required this.padding,
  }) : super(key: key);
  final ParagraphNode node;
  final TextStyle setTextStyle;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    final textSpans = DocToCustomWidgetGenerator.computeTextSpan(
      node.text,
      startOffset: node.beginningPosition.offset,
      endOffset: node.endPosition.offset,
    );
    return Padding(
      padding: padding,
      child: RichText(
        text: TextSpan(
          children: [textSpans],
          style: setTextStyle,
        ),
      ),
    );
  }
}
