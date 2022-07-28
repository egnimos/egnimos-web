import 'package:flutter/cupertino.dart';
import 'package:super_editor/super_editor.dart';

///Attribution to be used within [AttributedText] to
///set the font size of the particular selected
///attributed text
class FontDecorationAttribution implements Attribution {
  FontDecorationAttribution({
    required this.textStyle,
  });

  @override
  String get id => 'fontSizeAttribution';

  final TextStyle textStyle;

  @override
  bool canMergeWith(Attribution other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontDecorationAttribution &&
          runtimeType == other.runtimeType &&
          textStyle == other.textStyle;

  @override
  int get hashCode => textStyle.hashCode;

  @override
  String toString() {
    return '[FontSizeAttribution]: $textStyle';
  }
}
