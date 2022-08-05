import 'package:egnimos/src/pages/write_blog_pages/custom_attribution/font_decoration_attribution.dart';
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
      print("STYLE BUILDER FONT SIZE ::" + attribution.fontSize.toString());
      newStyle = newStyle.copyWith(
        fontSize: attribution.fontSize.toDouble(),
      );
    } else if (attribution is FontColorDecorationAttribution) {
      print("STYLE BUILDER FONT COLOR ::" + attribution.fontColor.toString());
      newStyle = newStyle.copyWith(
        color: attribution.fontColor,
      );
    } else if (attribution is FontBackgroundColorDecorationAttribution) {
      print("STYLE BUILDER FONT BACKGROUND COLOR ::" +
          attribution.fontBackgroundColor.toString());
      newStyle = newStyle.copyWith(
        backgroundColor: attribution.fontBackgroundColor,
      );
    } else if (attribution is FontDecorationColorDecorationAttribution) {
      print("STYLE BUILDER FONT DECORATION COLOR ::" +
          attribution.fontDecorationColor.toString());
      newStyle = newStyle.copyWith(
        decorationColor: attribution.fontDecorationColor,
      );
    } else if (attribution is FontDecorationStyleAttribution) {
      print("STYLE BUILDER FONT DECORATION style ::" +
          attribution.fontDecorationStyle.name);
      newStyle = newStyle.copyWith(
        decorationStyle: attribution.fontDecorationStyle,
      );
    }
  }
  return newStyle;
}
