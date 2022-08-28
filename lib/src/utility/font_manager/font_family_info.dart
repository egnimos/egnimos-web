class FontFamilyInfo {
  final String fontName;
  final String directoryName;
  final List<FontType> fontTypes;
  final String ext;

  FontFamilyInfo({
    required this.fontName,
    required this.directoryName,
    required this.fontTypes,
    required this.ext,
  });
}

enum FontType {
  // ignore: constant_identifier_names
  Bold,
  // ignore: constant_identifier_names
  Italic,
  // ignore: constant_identifier_names
  Regular,
}
