import 'package:egnimos/main.dart';
import 'package:egnimos/src/models/category.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  static const catCollection = "categories";

  //save the category
  Future<void> saveCategory(Category cat) async {
    try {
      await firestoreInstance
          .collection(catCollection)
          .doc(cat.id)
          .set(cat.toJson());
      _categories.add(cat);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //get the category
  Future<void> getCategories() async {
    try {
      final response = await firestoreInstance.collection(catCollection).get();
      List<Category> result = [];
      for (var catDoc in response.docs) {
        result.add(Category.fromJson(catDoc.data()));
      }
      _categories = result;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
