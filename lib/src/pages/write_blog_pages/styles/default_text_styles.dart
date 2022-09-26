import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/user_node.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_editor/super_editor.dart';
import '../../../models/style_models/text_style_model.dart';
import '../../../utility/enum.dart';
import '../../../widgets/create_blog_widgets/layout_widgets/text_style_widgets/font_families_widget.dart';
import '../named_attributions.dart';
import 'header_styles.dart';

///[TextStyle] key
const textStyleKey = "textStyle";

///List of the default text styles for style rules of a document node
///these text styles is set for each different attribution

///[defaultTextStyle] text style for all the [TextNode]
final defaultTextStyle = TextStyle(
  color: textColor,
  fontFamily: fontFamilyInfo.selectedFontFamily,
  fontSize: 18,
  height: 1.4,
);

final checkboxTextStyle = TextStyle(
  color: textColor,
  fontFamily: fontFamilyInfo.selectedFontFamily,
  fontSize: 18,
  height: 1.4,
);

final userNameTextStyle = GoogleFonts.rubik(
  color: textColor,
  fontSize: 18,
  height: 1.4,
);

final listitemTextStyle = TextStyle(
  color: Colors.green,
  fontFamily: fontFamilyInfo.selectedFontFamily,
  fontSize: 20,
  height: 1.4,
  fontWeight: FontWeight.w600,
);

final blockquoteTextStyle = TextStyle(
  color: textColor,
  fontFamily: fontFamilyInfo.selectedFontFamily,
  fontSize: 18,
  height: 1.4,
);

///[h1TextStyle] text style for all the [header1Attribution]
final h1TextStyle = TextStyle(
  color: textColor,
  fontFamily: fontFamilyInfo.selectedFontFamily,
  fontSize: 60.0,
  fontWeight: FontWeight.w800,
);

///[h2TextStyle] text style for all the [header2Attribution]
// Theme.of(context).textTheme.headline2!.
final h2TextStyle = TextStyle(
  color: textColor,
  fontFamily: fontFamilyInfo.selectedFontFamily,
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

///[h3TextStyle] text style for all the [header3Attribution]
final h3TextStyle = TextStyle(
  color: textColor,
  fontFamily: fontFamilyInfo.selectedFontFamily,
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
);

///[h4TextStyle] text style for all the [header4Attribution]
const h4TextStyle = TextStyle(
  color: textColor,
  fontSize: 35.0,
  fontWeight: FontWeight.w700,
);

///[h5TextStyle] text style for all the [header5Attribution]
final h5TextStyle = TextStyle(
  color: textColor,
  fontFamily: fontFamilyInfo.selectedFontFamily,
  fontSize: 26.0,
  fontWeight: FontWeight.w700,
);

///[h6TextStyle] text style for all the [header6Attribution]
final h6TextStyle = TextStyle(
  color: textColor,
  fontFamily: fontFamilyInfo.selectedFontFamily,
  fontSize: 18.0,
  fontWeight: FontWeight.w700,
);

TextStyle getTextStyleBasedOnTextType(TextTypes type, {required List<TextStyleModel> stylers,}) {
  switch (type) {
    case TextTypes.header1:
      return getTextStyle(h1TextStyle, type, stylers: stylers);
    case TextTypes.header2:
      return getTextStyle(h2TextStyle, type, stylers: stylers);
    case TextTypes.header3:
      return getTextStyle(h3TextStyle, type, stylers: stylers);
    case TextTypes.header4:
      return getTextStyle(h4TextStyle, type, stylers: stylers);
    case TextTypes.header5:
      return getTextStyle(h5TextStyle, type, stylers: stylers);
    case TextTypes.header6:
      return getTextStyle(h6TextStyle, type, stylers: stylers);
    case TextTypes.blockquote:
      return getTextStyle(blockquoteTextStyle, type, stylers: stylers);
    case TextTypes.listItem:
      return getTextStyle(listitemTextStyle, type, stylers: stylers);
    case TextTypes.checkbox:
      return getTextStyle(checkboxTextStyle, type, stylers: stylers);
    default:
      return getTextStyle(defaultTextStyle, type, stylers: stylers);
  }
}

String getId(TextTypes type) {
  switch (type) {
    case TextTypes.header1:
      return header1Attribution.id;
    case TextTypes.header2:
      return header2Attribution.id;
    case TextTypes.header3:
      return header3Attribution.id;
    case TextTypes.header4:
      return header4Attribution.id;
    case TextTypes.header5:
      return header5Attribution.id;
    case TextTypes.header6:
      return header6Attribution.id;
    case TextTypes.blockquote:
      return blockquoteAttribution.id;
    case TextTypes.listItem:
      return listItemAttribution.id;
    case TextTypes.checkbox:
      return checkboxAttribution.id;
    case TextTypes.user:
      return userNodeAttribution.id;
    default:
      return paragraphAttribution.id;
  }
}

Map<NamedAttribution, TextTypes> getTextType() => {
      header1Attribution: TextTypes.header1,
      header2Attribution: TextTypes.header2,
      header3Attribution: TextTypes.header3,
      header4Attribution: TextTypes.header4,
      header5Attribution: TextTypes.header5,
      header6Attribution: TextTypes.header6,
      blockquoteAttribution: TextTypes.blockquote,
      listItemAttribution: TextTypes.listItem,
      checkboxAttribution: TextTypes.checkbox,
      paragraphAttribution: TextTypes.paragraph,
      userNodeAttribution: TextTypes.user,
    };

TextStyle getTextStyle(
  TextStyle textStyle,
  TextTypes type, {
  required List<TextStyleModel> stylers,
}) {
  final blockId = getId(type);
  final values = stylers.where((e) => e.blockId == blockId);
  if (values.isEmpty) {
    return textStyle;
  }
  final style = values.first;
  return textStyle.copyWith(
    color: style.fontColor,
    backgroundColor: style.backgroundColor,
    decorationColor: style.textDecorationColor,
    fontFamily: style.fontFamilyInfo?.selectedFontFamily,
    fontSize: style.fontSize,
    fontStyle: style.fontStyle,
    decoration: style.textDecoration,
    decorationStyle: style.textDecorationStyle,
    decorationThickness: style.textDecorationThickness,
    wordSpacing: style.wordSpacing,
    letterSpacing: style.letterSpacing,
    fontWeight: style.fontWeight,
  );
}
