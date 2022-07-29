import 'package:flutter/cupertino.dart';
import 'package:super_editor/super_editor.dart';

///Attribution to be used within [AttributedText] to
///set the font text color of the particular selected
///attributed text
class FontColorDecorationAttribution implements Attribution {
  FontColorDecorationAttribution({
    required this.fontColor,
  });

  @override
  String get id => 'fontColorDecorationAttribution';

  final Color fontColor;

  @override
  bool canMergeWith(Attribution other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontColorDecorationAttribution &&
          runtimeType == other.runtimeType &&
          fontColor == other.fontColor;

  @override
  int get hashCode => fontColor.hashCode;

  @override
  String toString() {
    return '[FontColorDecorationAttribution]: $fontColor';
  }
}


///Attribution to be used within [AttributedText] to
///set the font text background color of the particular selected
///attributed text
class FontBackgroundColorDecorationAttribution implements Attribution {
  FontBackgroundColorDecorationAttribution({
    required this.fontBackgroundColor,
  });

  @override
  String get id => 'fontBackgroundColorDecorationAttribution';

  final Color fontBackgroundColor;

  @override
  bool canMergeWith(Attribution other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontBackgroundColorDecorationAttribution &&
          runtimeType == other.runtimeType &&
          fontBackgroundColor == other.fontBackgroundColor;

  @override
  int get hashCode => fontBackgroundColor.hashCode;

  @override
  String toString() {
    return '[FontBackgroundColorDecorationAttribution]: $fontBackgroundColor';
  }
}


///Attribution to be used within [AttributedText] to
///set the font text decoration color of the particular selected
///attributed text
class FontDecorationColorDecorationAttribution implements Attribution {
  FontDecorationColorDecorationAttribution({
    required this.fontDecorationColor,
  });

  @override
  String get id => 'fontBackgroundColorDecorationAttribution';

  final Color fontDecorationColor;

  @override
  bool canMergeWith(Attribution other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontDecorationColorDecorationAttribution &&
          runtimeType == other.runtimeType &&
          fontDecorationColor == other.fontDecorationColor;

  @override
  int get hashCode => fontDecorationColor.hashCode;

  @override
  String toString() {
    return '[FontDecorationColorDecorationAttribution]: $fontDecorationColor';
  }
}


///Attribution to be used within [AttributedText] to
///set the font text decoration style of the particular selected
///attributed text
class FontDecorationStyleAttribution implements Attribution {
  FontDecorationStyleAttribution({
    required this.fontDecorationStyle,
  });

  @override
  String get id => 'fontDecorationStyleAttribution';

  final TextDecorationStyle fontDecorationStyle;

  @override
  bool canMergeWith(Attribution other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontDecorationStyleAttribution &&
          runtimeType == other.runtimeType &&
          fontDecorationStyle == other.fontDecorationStyle;

  @override
  int get hashCode => fontDecorationStyle.hashCode;

  @override
  String toString() {
    return '[FontDecorationStyleAttribution]: $fontDecorationStyle';
  }
}
