import 'package:super_editor/super_editor.dart';

///Attribution to be used within [AttributedText] to
///set the font size of the particular selected
///attributed text
class FontSizeAttribution implements Attribution {
  FontSizeAttribution({
    required this.fontSize,
  });

  @override
  String get id => 'fontSizeAttribution';

  final num fontSize;

  @override
  bool canMergeWith(Attribution other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FontSizeAttribution &&
          runtimeType == other.runtimeType &&
          fontSize == other.fontSize;

  @override
  int get hashCode => fontSize.hashCode;

  @override
  String toString() {
    return '[FontSizeAttribution]: $fontSize';
  }
}
