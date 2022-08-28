import 'package:egnimos/main.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/header_styles.dart';

import '../models/style_models/styler.dart';
import '../widgets/create_blog_widgets/layout_option_widget.dart';

class StyleProvider {
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
      final stylerList = LayoutStyler.fromJsonToStylers(response.data()!);
      for (var style in stylerList) {
        if (style is LayoutStyler) {
          data["layout_styler"] = style;
        }
      }
      final styleRules =
          LayoutStyler.fromStylerToStyleRules([layoutStyler, ...stylerList]);
      data["style_rules"] = styleRules;
      return data;
    } catch (e) {
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
