import 'package:flutter/cupertino.dart';
import 'package:super_editor/super_editor.dart';

///Attribution to be used within [AttributedText] to
///set the font size of the particular selected
///attributed text
class FontSizeDecorationAttribution implements Attribution {
  FontSizeDecorationAttribution({
    required this.fontSize,
  });

  @override
  String get id => 'fontSizeDecorationAttribution';

  final num fontSize;

  @override
  bool canMergeWith(Attribution other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontSizeDecorationAttribution &&
          runtimeType == other.runtimeType &&
          fontSize == other.fontSize;

  @override
  int get hashCode => fontSize.hashCode;

  @override
  String toString() {
    return '[FontSizeDecorationAttribution]: $fontSize';
  }
}
