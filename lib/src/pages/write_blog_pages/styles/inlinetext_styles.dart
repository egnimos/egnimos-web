import 'package:egnimos/src/pages/write_blog_pages/custom_attribution/font_size_attribution.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

TextStyle inlinetextStyle(
    Set<Attribution> attributions, TextStyle existingStyle) {
  return existingStyle.merge(inlineStyleBuilder(attributions));
}

TextStyle inlineStyleBuilder(Set<Attribution> attributions) {
  TextStyle newStyle = const TextStyle();

  for (final attribution in attributions) {
    if (attribution == boldAttribution) {
      newStyle = newStyle.copyWith(
        fontWeight: FontWeight.bold,
        // color: Colors.pink,
        fontSize: 18.0,
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
    } else if (attribution is FontDecorationAttribution) {
      print("STYLE BUILDER FONT SIZE ::" +
          attribution.textStyle.fontSize.toString());
      newStyle = newStyle.copyWith(
        fontSize: attribution.textStyle.fontSize,
        color: attribution.textStyle.color,
        backgroundColor: attribution.textStyle.backgroundColor,
        decorationColor: attribution.textStyle.decorationColor,
        decorationStyle: attribution.textStyle.decorationStyle,
      );
    }
  }
  return newStyle;
}
