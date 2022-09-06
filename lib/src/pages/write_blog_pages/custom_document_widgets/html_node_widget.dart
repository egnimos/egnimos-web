import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/html_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlNodeWidget extends StatelessWidget {
  final HtmlNode node;
  final EdgeInsets padding;
  const HtmlNodeWidget({
    Key? key,
    required this.node,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final html = HtmlWidget(
      node.html,
      // ignore: deprecated_member_use
      webView: true,
      // ignore: deprecated_member_use
      webViewJs: true,
      // ignore: deprecated_member_use
      webViewMediaPlaybackAlwaysAllow: true,
      isSelectable: true,
    );
    return Center(
      child: Padding(
          padding: padding,
          child: html,
        ),
    );
  }
}
