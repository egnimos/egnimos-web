import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/checkbox_node.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/html_node.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/user_node.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_document_widgets/horizontalrule_node_widget.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_document_widgets/paragraph_node_widget.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_document_widgets/user_node_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/style_models/text_style_model.dart';
import 'custom_attribution/font_decoration_attribution.dart';
import 'custom_attribution/font_size_attribution.dart';
import 'custom_document_widgets/checkbox_node_widget.dart';
import 'custom_document_widgets/html_node_widget.dart';
import 'custom_document_widgets/image_node_widget.dart';
import 'custom_document_widgets/listItem_node_widget.dart';
import 'styles/default_paddings.dart';
import 'styles/default_text_styles.dart';

class DocToCustomWidgetGenerator {
  static List<Widget> toWidget(
      List<DocumentNode> nodes, List<TextStyleModel> textStyler) {
    List<Widget> widgets = [];
    int? index;
    for (var node in nodes) {
      //usernode
      if (node is UserNode) {
        final value = computeNodeForBlockStyle(node, textStyler);
        widgets.add(
          UserNodeWidget(
            setTextStyle: value["t"],
            node: node,
            padding: value["p"],
          ),
        );
        continue;
      }
      //listitem node
      if (node is ListItemNode) {
        if (index == null) {
          index = 1;
        } else {
          index += 1;
        }
        final value = computeNodeForBlockStyle(node, textStyler);
        widgets.add(ListItemNodeWidget(
          node: node,
          setTextStyle: value["t"],
          padding: value["p"],
          index: index,
        ));
        continue;
      }
      //check box node
      if (node is CheckboxNode) {
        index = null;
        final value = computeNodeForBlockStyle(node, textStyler);
        widgets.add(CheckboxNodeWidget(
          node: node,
          setStyleTextStyle: value["t"],
          padding: value["p"],
        ));
        continue;
      }
      //horizontal node
      if (node is HorizontalRuleNode) {
        index = null;
        final value = computeNodeForBlockStyle(node, textStyler);
        widgets.add(HorizontalRuleNodeWidget(
          padding: value["p"],
        ));
        continue;
      }
      //image node
      if (node is ImageNode) {
        index = null;
        final value = computeNodeForBlockStyle(node, textStyler);
        widgets.add(ImageNodeWidget(
          node: node,
          padding: value["p"],
        ));
        continue;
      }
      //paragraph node
      if (node is ParagraphNode) {
        index = null;
        final value = computeNodeForBlockStyle(node, textStyler);
        widgets.add(ParagraphNodeWidget(
          node: node,
          setTextStyle: value["t"],
          padding: value["p"],
        ));
        continue;
      }
      //html node
      if (node is HtmlNode) {
        index = null;
        final value = computeNodeForBlockStyle(node, textStyler);
        widgets.add(HtmlNodeWidget(
          padding: value["p"],
          node: node,
        ));
        continue;
      }
    }
    return widgets;
  }

  static Map<String, dynamic> computeNodeForBlockStyle(
      DocumentNode node, List<TextStyleModel> stylers) {
    if (node is TextNode) {
      //get the block id
      final block = (node.metadata['blockType'] as NamedAttribution);
      final textStyle = getTextStyleBasedOnTextType(getTextType()[block]!, stylers: stylers);
      return {
        "t": textStyle,
        "p": getPadding()[block]!,
      };
    }
    return {
      "t": const TextStyle(),
      "p": defaultPadding.toEdgeInsets(),
    };
  }

  /// Returns a Flutter [TextSpan] that is styled based on the
  /// attributions within this [AttributedText].
  ///
  /// The given [styleBuilder] interprets the meaning of every
  /// attribution and constructs [TextStyle]s accordingly.
  static TextSpan computeTextSpan(
    AttributedText text, {
    required int startOffset,
    required int endOffset,
  }) {
    if (text.text.isEmpty) {
      // There is no text and therefore no attributions.
      attributionsLog.fine('text is empty. Returning empty TextSpan.');
      return TextSpan(
          text: '',
          style: () {
            final attributions = text.getAllAttributionsThroughout(
              SpanRange(
                start: startOffset,
                end: endOffset,
              ),
            );

            return getTextStyles(attributions);
          }());
    }

    final collapsedSpans =
        text.spans.collapseSpans(contentLength: text.text.length);
    final textSpans = collapsedSpans
        .map(
          (attributedSpan) => TextSpan(
            text: text.text
                .substring(attributedSpan.start, attributedSpan.end + 1),
            style: getTextStyles(attributedSpan.attributions),
            mouseCursor: attributedSpan.attributions
                    .whereType<LinkAttribution>()
                    .toList()
                    .isEmpty
                ? null
                : SystemMouseCursors.click,
            recognizer: attributedSpan.attributions
                    .whereType<LinkAttribution>()
                    .toList()
                    .isEmpty
                ? null
                : TapGestureRecognizer()
              ?..onTap = () async {
                final linkAttrs = attributedSpan.attributions
                    .whereType<LinkAttribution>()
                    .toList();
                if (linkAttrs.isEmpty) return;
                //print("LENGTH LINK ATTRIBUTION :: ${linkAttrs.length}");
                await _launchUrl(linkAttrs.first.url);
              },
            onEnter: attributedSpan.attributions
                    .whereType<LinkAttribution>()
                    .toList()
                    .isEmpty
                ? null
                : (value) {
                    //print("ONENTER");
                  },
            onExit: attributedSpan.attributions
                    .whereType<LinkAttribution>()
                    .toList()
                    .isEmpty
                ? null
                : (value) {
                    //print("ONEXIT");
                  },
          ),
        )
        .toList();

    return textSpans.length == 1
        ? textSpans.first
        : TextSpan(
            children: textSpans,
            style: getTextStyles({}),
          );
  }

  static Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  static TextStyle getTextStyles(Set<Attribution> attributions) {
    TextStyle newStyle = const TextStyle();
    for (final attribution in attributions) {
      if (attribution == boldAttribution) {
        newStyle = newStyle.copyWith(
          fontWeight: FontWeight.bold,
        );
      } else if (attribution == italicsAttribution) {
        newStyle = newStyle.copyWith(
          fontStyle: FontStyle.italic,
        );
      } else if (attribution == underlineAttribution) {
        newStyle = newStyle.copyWith(
          decoration: newStyle.decoration == null
              ? TextDecoration.underline
              : TextDecoration.combine(
                  [TextDecoration.underline, newStyle.decoration!]),
        );
      } else if (attribution == strikethroughAttribution) {
        newStyle = newStyle.copyWith(
          decoration: newStyle.decoration == null
              ? TextDecoration.lineThrough
              : TextDecoration.combine(
                  [TextDecoration.lineThrough, newStyle.decoration!]),
        );
      } else if (attribution is LinkAttribution) {
        newStyle = newStyle.copyWith(
          color: Colors.lightBlue.shade800,
          decoration: TextDecoration.underline,
        );
      } else if (attribution is FontSizeDecorationAttribution) {
        //print("STYLE BUILDER FONT SIZE ::" + attribution.fontSize.toString());
        newStyle = newStyle.copyWith(
          fontSize: attribution.fontSize.toDouble(),
        );
      } else if (attribution is FontColorDecorationAttribution) {
        //print("STYLE BUILDER FONT COLOR ::" + attribution.fontColor.toString());
        newStyle = newStyle.copyWith(
          color: attribution.fontColor,
        );
      } else if (attribution is FontBackgroundColorDecorationAttribution) {
        //print("STYLE BUILDER FONT BACKGROUND COLOR ::" +
        // attribution.fontBackgroundColor.toString());
        newStyle = newStyle.copyWith(
          backgroundColor: attribution.fontBackgroundColor,
        );
      } else if (attribution is FontDecorationColorDecorationAttribution) {
        //print("STYLE BUILDER FONT DECORATION COLOR ::" +
        // attribution.fontDecorationColor.toString());
        newStyle = newStyle.copyWith(
          decorationColor: attribution.fontDecorationColor,
        );
      } else if (attribution is FontDecorationStyleAttribution) {
        //print("STYLE BUILDER FONT DECORATION style ::" +
        // attribution.fontDecorationStyle.name);
        newStyle = newStyle.copyWith(
          decorationStyle: attribution.fontDecorationStyle,
        );
      }
    }
    return newStyle;
  }
}
