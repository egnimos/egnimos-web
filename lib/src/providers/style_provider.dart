import 'package:egnimos/main.dart';
import 'package:egnimos/src/models/style_models/text_style_model.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/header_styles.dart';
import 'package:flutter/cupertino.dart';

import '../models/style_models/styler.dart';
import '../widgets/create_blog_widgets/layout_option_widget.dart';

class StyleProvider with ChangeNotifier {
  String stylesCollection = "styles";

  //save the styles
  Future<void> saveStyle(String blogId, Map<String, dynamic> json) async {
    try {
      await firestoreInstance
          .collection(stylesCollection)
          .doc(blogId)
          .set(json);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getStyle(String blogId) async {
    try {
      Map<String, dynamic> data = {};
      final response = await firestoreInstance
          .collection(stylesCollection)
          .doc(blogId)
          .get();
      //convert it to stylers
      print("STYLER JSON ${response.data()}");
      final stylerList = LayoutStyler.fromJsonToStylers(response.data());
      List<TextStyleModel> stylers = [];
      for (var style in stylerList) {
        if (style is LayoutStyler) {
          data["layout_styler"] = style;
          continue;
        }
        if (style is TextStyleModel) {
          stylers.add(style);
        }
      }
      data["text_stylers"] = stylers;
      final styleRules =
          LayoutStyler.fromStylerToStyleRules([layoutStyler, ...stylerList]);
      data["style_rules"] = styleRules;
      return data;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //delete the styles
  Future<void> deleteStyle(String blogId) async {
    try {
      await firestoreInstance.collection(stylesCollection).doc(blogId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
