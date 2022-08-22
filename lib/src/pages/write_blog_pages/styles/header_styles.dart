import 'package:egnimos/src/pages/write_blog_pages/styles/default_paddings.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/default_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

typedef StyleRules = List<StyleRule>;
const Color textColor = Color(0xFF333333);

StyleRules defaultHeaders(BuildContext context) => [
      StyleRule(
        BlockSelector(header1Attribution.name),
        (doc, docNode) {
          return {
            paddingKey: h1Padding,
            textStyleKey: h1TextStyle,
          };
        },
      ),
      StyleRule(
        BlockSelector(header2Attribution.name),
        (doc, docNode) {
          return {
            paddingKey: h2Padding,
            textStyleKey: h2TextStyle,
          };
        },
      ),
      StyleRule(
        BlockSelector(header3Attribution.name),
        (doc, docNode) {
          return {
            paddingKey: h3Padding,
            textStyleKey: h3TextStyle,
          };
        },
      ),
      StyleRule(
        BlockSelector(header4Attribution.name),
        (doc, docNode) {
          return {
            paddingKey: h4Padding,
            textStyleKey: h4TextStyle,
          };
        },
      ),
      StyleRule(
        BlockSelector(header5Attribution.name),
        (doc, docNode) {
          return {
            paddingKey: h5Padding,
            textStyleKey: h5TextStyle,
          };
        },
      ),
      StyleRule(
        BlockSelector(header6Attribution.name),
        (doc, docNode) {
          return {
            paddingKey: h6Padding,
            textStyleKey: h6TextStyle,
          };
        },
      ),
    ];
