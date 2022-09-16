import 'package:dynamic_cached_fonts/dynamic_cached_fonts.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../models/style_models/text_style_model.dart';
import 'font_family_info.dart';
import 'font_list.dart';

class FontHandler {
  //fetch and download the font
  // static Future<void> fetchAndDownload({String? family}) async {
  //   final getFontFamilyInfo = fontsMap()[family ?? fontFamily];
  //   GoogleFonts.cabinSketch();
  //   //print(GoogleFonts.cabinSketch().fontFamily);
  //   final info = getFontFamilyInfo!.call();
  //   String filename = "";
  //   if (info.fontTypes.isNotEmpty) {
  //     filename = "${info.fontName}-${FontType.Regular.name}.${info.ext}";
  //   } else {
  //     filename = "${info.fontName}.${info.ext}";
  //   }
  //   final fontUrl =
  //       "https://github.com/google/fonts/raw/main/ofl/${info.directoryName}/$filename";
  //   //cached the font file
  //   final fontLoader = FontLoader(family ?? fontFamily);
  //   fontLoader.addFont(_fetchByteData(fontUrl));

  //   //load the font
  //   await fontLoader.load();
  //   // //print(values.toList().map((e) => e.toString()).toList());
  // }

  //fetch the bytes data
  // static Future<ByteData> _fetchByteData(String uri) async {
  //   try {
  //     final response = await http.get(Uri.parse(uri), headers: {
  //       "Accept": "application/json",
  //       "Access-Control_Allow_Origin": "*"
  //     });
  //     if (response.statusCode == 200) {
  //       return ByteData.view(response.bodyBytes.buffer);
  //     } else {
  //       throw Exception("failed to load file data");
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
