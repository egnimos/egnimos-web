import 'package:egnimos/src/models/style_models/image_style_model.dart';
import 'package:egnimos/src/models/style_models/text_style_model.dart';
import 'package:egnimos/src/pages/write_blog_pages/named_attributions.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/header_styles.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../../pages/write_blog_pages/styles/default_paddings.dart';
import '../../pages/write_blog_pages/styles/default_text_styles.dart';

const layoutStylerId = "layout_styler";

class LayoutStyler {
  final String layoutId;
  final Color? layoutColor;
  final String layoutBgUri;

  LayoutStyler({
    required this.layoutId,
    this.layoutColor,
    required this.layoutBgUri,
  });

  //toJson
  Map<String, dynamic> toJson() => {
        "layout_id": layoutId,
        "layout_color": layoutColor,
        "layout_bg_uri": layoutBgUri,
      };

  //fromJson
  factory LayoutStyler.fromJson(Map<String, dynamic> data) => LayoutStyler(
        layoutId: data["layout_id"],
        layoutColor: data["layout_color"],
        layoutBgUri: data["layout_bg_uri"],
      );

  //stylertoJson
  Map<String, dynamic> stylerToJson(List stylers) {
    Map<String, dynamic> data = {};
    for (var style in stylers) {
      //layout styler
      if (style is LayoutStyler) {
        data[layoutStylerId] = style.toJson();
      }

      //image style model
      if (style is ImageStyleModel) {
        data[style.blockId] = style.toJson();
      }

      //text style model
      if (style is TextStyleModel) {
        data[style.blockId] = style.toJson();
      }
    }
    return data;
  }

  //fromJsonToStylers
  List fromJsonToStylers(Map<String, dynamic> data) {
    final stylers = [];
    for (var key in data.keys) {
      //if the key is layout styler
      if (key == layoutStylerId) {
        stylers.add(LayoutStyler.fromJson(data[key]));
      }
      //if the key is image
      if (key == imageAttribution.name) {
        stylers.add(ImageStyleModel.fromJson(data[key]));
      }
      //if the key is header1
      if (key == header1Attribution.name) {
        stylers.add(TextStyleModel.fromJson(data[key]));
      }
      //if the key is header2
      if (key == header2Attribution.name) {
        stylers.add(TextStyleModel.fromJson(data[key]));
      }
      //if the key is header3
      if (key == header3Attribution.name) {
        stylers.add(TextStyleModel.fromJson(data[key]));
      }
      //if the key is header4
      if (key == header4Attribution.name) {
        stylers.add(TextStyleModel.fromJson(data[key]));
      }
      //if the key is header5
      if (key == header5Attribution.name) {
        stylers.add(TextStyleModel.fromJson(data[key]));
      }
      //if the key is header6
      if (key == header6Attribution.name) {
        stylers.add(TextStyleModel.fromJson(data[key]));
      }
      //if the key is paragraph
      if (key == paragraphAttribution.name) {
        stylers.add(TextStyleModel.fromJson(data[key]));
      }
      //if the key is listitem node
      if (key == listItemAttribution.name) {
        stylers.add(TextStyleModel.fromJson(data[key]));
      }
      //if the key is checkbox node
      if (key == checkboxAttribution.name) {
        stylers.add(TextStyleModel.fromJson(data[key]));
      }
      //if the key is blockquote node
      if (key == blockquoteAttribution.name) {
        stylers.add(TextStyleModel.fromJson(data[key]));
      }
    }
    return stylers;
  }

  //fromStylerToStyleRules
  StyleRules fromStylerToStyleRules(List styleRules) {
    StyleRules rules = <StyleRule>[];
    for (var style in styleRules) {
      //if the image style model
      if (style is ImageStyleModel) {
        if (style.blockId == imageAttribution.name) {
          rules.add(
            StyleRule(
              BlockSelector(style.blockId),
              (doc, docNode) {
                if (docNode is! ImageNode) {
                  return {};
                }

                return {
                  "width": style.width,
                };
              },
            ),
          );
        }
      }
      //if the text style model
      if (style is TextStyleModel) {
        //header-1
        if (style.blockId == header1Attribution.name) {
          // final intialTextStyle = h1TextStyle;
          rules.add(
            getStyleRule(
              padding: h1Padding,
              style: style,
              textStyle: h1TextStyle,
            ),
          );
        }
        //header-2
        if (style.blockId == header2Attribution.name) {
          rules.add(
            getStyleRule(
              padding: h2Padding,
              style: style,
              textStyle: h2TextStyle,
            ),
          );
        }
        //header-3
        if (style.blockId == header3Attribution.name) {
          rules.add(
            getStyleRule(
              padding: h3Padding,
              style: style,
              textStyle: h3TextStyle,
            ),
          );
        }
        //header-4
        if (style.blockId == header4Attribution.name) {
          rules.add(
            getStyleRule(
              padding: h4Padding,
              style: style,
              textStyle: h4TextStyle,
            ),
          );
        }
        //header-5
        if (style.blockId == header5Attribution.name) {
          rules.add(
            getStyleRule(
              padding: h5Padding,
              style: style,
              textStyle: h5TextStyle,
            ),
          );
        }
        //header-6
        if (style.blockId == header6Attribution.name) {
          rules.add(
            getStyleRule(
              padding: h6Padding,
              style: style,
              textStyle: h6TextStyle,
            ),
          );
        }
        //checkbox
        if (style.blockId == checkboxAttribution.name) {
          rules.add(
            getStyleRule(
              padding: checkboxPadding,
              style: style,
              textStyle: checkboxTextStyle,
            ),
          );
        }
        //paragraph
        if (style.blockId == paragraphAttribution.name) {
          rules.add(
            getStyleRule(
              padding: defaultPadding,
              style: style,
              textStyle: defaultTextStyle,
            ),
          );
        }
        //listitem
        if (style.blockId == listItemAttribution.name) {
          rules.add(
            getStyleRule(
              padding: listitemPadding,
              style: style,
              textStyle: listitemTextStyle,
            ),
          );
        }
        //blockquote
        if (style.blockId == blockquoteAttribution.name) {
          rules.add(
            getStyleRule(
              padding: defaultPadding,
              style: style,
              textStyle: blockquoteTextStyle,
            ),
          );
        }
      }
    }
    return rules;
  }

  StyleRule getStyleRule({
    required CascadingPadding padding,
    required TextStyleModel style,
    required TextStyle textStyle,
    String? blockId,
  }) {
    return StyleRule(
      BlockSelector(blockId ?? style.blockId),
      (doc, docNode) {
        return {
          paddingKey: padding,
          textStyleKey: textStyle.copyWith(
            color: style.fontColor,
            backgroundColor: style.backgroundColor,
            decorationColor: style.textDecorationColor,
            fontSize: style.fontSize,
            fontStyle: style.fontStyle,
            decoration: style.textDecoration,
            decorationStyle: style.textDecorationStyle,
            decorationThickness: style.textDecorationThickness,
            wordSpacing: style.wordSpacing,
            letterSpacing: style.letterSpacing,
            fontWeight: style.fontWeight,
          ),
        };
      },
    );
  }
}
