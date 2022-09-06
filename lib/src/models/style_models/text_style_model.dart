import 'dart:ui';

import 'package:egnimos/src/widgets/create_blog_widgets/layout_widgets/text_style_widgets/font_decoration_widget.dart';
import 'package:flutter/cupertino.dart';

extension StringToEnum on Enum {
  int toEnum<T>(String value) {
    return index;
  }
}

class TextStyleModel {
  final String blockId;
  final double? fontSize;
  final FontStyle? fontStyle;
  final FontFamily? fontFamilyInfo;
  final Color? fontColor;
  final Color? backgroundColor;
  final TextDecorationStyle? textDecorationStyle;
  final FontWeight? fontWeight;
  final double? textDecorationThickness;
  final Color? textDecorationColor;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextDecoration? textDecoration;
  final TextPaint? foreground;
  final TextPaint? background;
  final List<Shadow> shadow;

  TextStyleModel({
    required this.blockId,
    required this.fontSize,
    required this.fontStyle,
    required this.fontFamilyInfo,
    required this.fontColor,
    required this.backgroundColor,
    required this.textDecorationStyle,
    required this.textDecorationThickness,
    required this.textDecorationColor,
    required this.letterSpacing,
    required this.fontWeight,
    required this.wordSpacing,
    required this.textDecoration,
    this.background,
    this.foreground,
    this.shadow = const [],
  });

  //fromJson
  factory TextStyleModel.fromJson(Map<String, dynamic> data) => TextStyleModel(
        blockId: data["block_id"],
        fontSize: data["font_size"],
        fontFamilyInfo: data["font_family_info"] != null
            ? FontFamily.fromJson(data["font_family_info"])
            : null,
        fontStyle: FontStyle.values.firstWhere(
          (e) => e.name == data["font_style"],
          orElse: () => FontStyle.normal,
        ),
        fontColor: data["font_color"] != null
            ? Color(int.parse(data["font_color"].toString()))
            : null,
        backgroundColor: data["background_color"] != null
            ? Color(int.parse(data["background_color"].toString()))
            : null,
        textDecorationStyle: TextDecorationStyle.values.firstWhere(
          (e) => e.name == data["text_decoration_style"],
          orElse: () => TextDecorationStyle.solid,
        ),
        fontWeight: FontWeight.values.firstWhere(
          (e) => e.index == int.parse(data["font_weight_index"].toString()),
          orElse: () => FontWeight.normal,
        ),
        textDecorationThickness: data["text_decoration_thickness"],
        textDecorationColor: data["text_decoration_color"] != null
            ? Color(int.parse(data["text_decoration_color"].toString()))
            : null,
        letterSpacing: data["letter_spacing"],
        wordSpacing: data["word_spacing"],
        textDecoration: decorations.firstWhere(
          (e) => e.toString().split(".")[1] == data["text_decoration"],
          orElse: () => TextDecoration.none,
        ),
      );

  //toJson
  Map<String, dynamic> toJson() => {
        "block_id": blockId,
        "font_size": fontSize,
        "font_style": fontStyle?.name,
        "font_family_info": fontFamilyInfo?.toJson(),
        "font_color": fontColor?.value,
        "background_color": backgroundColor?.value,
        "text_decoration_style": textDecorationStyle?.name,
        "font_weight_index": fontWeight?.index,
        "text_decoration_thickness": textDecorationThickness,
        "text_decoration_color": textDecorationColor?.value,
        "letter_spacing": letterSpacing,
        "word_spacing": wordSpacing,
        "text_decoration": textDecoration != null
            ? textDecoration.toString().split(".")[1]
            : null,
      };
}

class FontFamily {
  final String fontFamilyName;
  final String selectedFontFamily;

  FontFamily({
    required this.fontFamilyName,
    required this.selectedFontFamily,
  });

  //fromJson
  factory FontFamily.fromJson(Map<String, dynamic>? data) => FontFamily(
        fontFamilyName: data?["font_family_name"] ?? "",
        selectedFontFamily: data?["selected_font_family"] ?? "",
      );

  //toJson
  Map<String, dynamic> toJson() => {
        "font_family_name": fontFamilyName,
        "selected_font_family": selectedFontFamily,
      };
}

class TextPaint {
  final BlendMode? blendMode;
  final Color? color;
  // final ColorFilter? colorFilter;
  final FilterQuality? filterQuality;
  // final ImageFilter? imageFilter;
  final bool? invertColors;
  final bool? isAntiAlias;
  // final MaskFilter? maskFilter;
  // final Shader? shader;
  final StrokeCap? strokeCap;
  final StrokeJoin? strokeJoin;
  final double? strokeMiterLimit;
  final double? strokeWidth;
  final PaintingStyle? style;

  TextPaint({
    required this.blendMode,
    required this.color,
    // required this.colorFilter,
    required this.filterQuality,
    // required this.imageFilter = ImageFilter.,
    required this.invertColors,
    required this.isAntiAlias,
    // required this.maskFilter = MaskFilter.blur(Blur, _sigma),
    // required this.shader = LinearGradient(colors: colors),
    required this.strokeCap,
    required this.strokeJoin,
    required this.strokeMiterLimit,
    required this.strokeWidth,
    required this.style,
  });

  Paint getPaint() {
    final paint = Paint();
    return paint;
  }

  factory TextPaint.fromJson(Map<String, dynamic> data) => TextPaint(
        blendMode: data[""] != null
            ? BlendMode.values.firstWhere((element) => element.name == data[""])
            : null,
        color: data[""] != null ? Color(int.parse(data[""])) : null,
        // colorFilter: data[""],
        filterQuality: data[""] != null ? FilterQuality.values[data[""]] : null,
        // imageFilter: data[""],
        invertColors: data[""],
        isAntiAlias: data[""],
        // maskFilter: data[""],
        // shader: data[""],
        strokeCap: data[""] != null ? StrokeCap.values[data[""]] : null,
        strokeJoin: data[""] != null ? StrokeJoin.values[data[""]] : null,
        strokeMiterLimit: data[""],
        strokeWidth: data[""],
        style: data[""] != null ? PaintingStyle.values[data[""]] : null,
      );

  Map<String, dynamic> toJson() => {
        "": blendMode?.name,
        "": color?.value,
        // "": colorFilter,
        "": filterQuality?.index,
        // "": imageFilter?,
        "": invertColors,
        "": isAntiAlias,
        // "": maskFilter,
        // "": shader,
        "": strokeCap?.index,
        "": strokeJoin?.index,
        "": strokeMiterLimit,
        "": strokeWidth,
        "": style?.index,
      };
}
