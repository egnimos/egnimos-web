import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/src/models/blog.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:flutter/cupertino.dart';

import '/main.dart';
import '../utility/convert.dart';

class BlogProvider with ChangeNotifier {
  List<Blog> _blogs = [];
  List<Blog> _updates = [];

  List<Blog> get updates => _updates;
  List<Blog> get blogs => _blogs;

  static const String publishedArticleCollection = "published_articles";

  //getBlogs
  Future<void> getBlogs(Cat catType) async {
    try {
      List<Blog> results = [];
      QuerySnapshot<Map<String, dynamic>> response;
      switch (catType) {
        case Cat.all:
          response = await firestoreInstance
              .collection(publishedArticleCollection)
              .orderBy("created_at", descending: true)
              .get();
          break;
        default:
          response = await firestoreInstance
              .collection(publishedArticleCollection)
              .where(
                "category.cat_enum",
                isEqualTo:
                    Convert.enumTostring(Cat.values, catType, () => null),
              )
              .orderBy("created_at", descending: true)
              .get();
      }
      for (var blog in response.docs) {
        final data = blog.data();
        results.add(Blog.fromJson(data));
      }
      _blogs = results;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getEgnimosUpdates(Cat catType) async {
    try {
      List<Blog> results = [];
      QuerySnapshot<Map<String, dynamic>> response;
      switch (catType) {
        case Cat.all:
          response = await firestoreInstance
              .collection(publishedArticleCollection)
              .orderBy("created_at", descending: true)
              .get();
          break;
        default:
          response = await firestoreInstance
              .collection(publishedArticleCollection)
              .where(
                "category.cat_enum",
                isEqualTo:
                    Convert.enumTostring(Cat.values, catType, () => null),
              )
              .orderBy("created_at", descending: true)
              .get();
      }
      for (var blog in response.docs) {
        final data = blog.data();
        results.add(Blog.fromJson(data));
      }

      _blogs = results;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
