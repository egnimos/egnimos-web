import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/src/models/blog.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/blog_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:super_editor/super_editor.dart';

import '../pages/write_blog_pages/parser_extension.dart';
import '/main.dart';
import '../utility/convert.dart';

class BlogProvider with ChangeNotifier {
  List<Blog> _publishedBlogSnaps = [];
  List<Blog> _draftBlogSnaps = [];
  List<Blog> _userPublishedBlogSnaps = [];

  List<Blog> get userPublishedBlogSnaps => _userPublishedBlogSnaps;
  List<Blog> get draftBlogSnaps => _draftBlogSnaps;
  List<Blog> get publishedBlogSnaps => _publishedBlogSnaps;

  static const String publishedArticleSnapsCollection =
      "published_articles_snaps";
  static const String draftArticleSnapsCollection = "draft_articles_snaps";
  static const String publishedArticleCollection = "published_article";
  static const String draftArticleCollection = "draft_article";

  //get blogs snaps
  Future<DocumentSnapshot> getPublishedBlogSnaps(
      Cat catType, DocumentSnapshot? lastDoc) async {
    try {
      List<Blog> results = [];
      QuerySnapshot<Map<String, dynamic>> response;
      switch (catType) {
        case Cat.all:
          response = lastDoc != null
              ? await firestoreInstance
                  .collection(publishedArticleSnapsCollection)
                  .orderBy("created_at", descending: true)
                  .startAfterDocument(lastDoc)
                  .limit(40)
                  .get()
              : await firestoreInstance
                  .collection(publishedArticleSnapsCollection)
                  .orderBy("created_at", descending: true)
                  .limit(40)
                  .get();
          break;
        default:
          response = lastDoc != null
              ? await firestoreInstance
                  .collection(publishedArticleSnapsCollection)
                  .where(
                    "category.cat_enum",
                    isEqualTo:
                        Convert.enumTostring(Cat.values, catType, () => null),
                  )
                  .orderBy("created_at", descending: true)
                  .startAfterDocument(lastDoc)
                  .limit(40)
                  .get()
              : await firestoreInstance
                  .collection(publishedArticleSnapsCollection)
                  .where(
                    "category.cat_enum",
                    isEqualTo:
                        Convert.enumTostring(Cat.values, catType, () => null),
                  )
                  .orderBy("created_at", descending: true)
                  .limit(40)
                  .get();
      }
      if (response.docs.isEmpty) {
        throw Exception("Nothing to load");
      }
      for (var blog in response.docs) {
        final data = blog.data();
        results.add(Blog.fromJson(data));
      }
      if (lastDoc != null) {
        _publishedBlogSnaps.addAll(results);
      } else {
        _publishedBlogSnaps = results;
      }
      notifyListeners();
      return response.docs.last;
    } catch (error) {
      rethrow;
    }
  }

  //get the draft blog snaps based on user ID
  Future<void> getDraftBlogSnaps(Cat catType, String userId) async {
    try {
      List<Blog> results = [];
      QuerySnapshot<Map<String, dynamic>> response;
      switch (catType) {
        case Cat.all:
          response = await firestoreInstance
              .collection(draftArticleSnapsCollection)
              .where(
                "user_id",
                isEqualTo: userId,
              )
              .orderBy("created_at", descending: true)
              .get();
          break;
        default:
          response = await firestoreInstance
              .collection(draftArticleSnapsCollection)
              .where(
                "category.cat_enum",
                isEqualTo:
                    Convert.enumTostring(Cat.values, catType, () => null),
              )
              .where(
                "user_id",
                isEqualTo: userId,
              )
              .orderBy("created_at", descending: true)
              .get();
      }
      for (var blog in response.docs) {
        final data = blog.data();
        results.add(Blog.fromJson(data));
      }
      _draftBlogSnaps = results;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //get the user based published blog snaps based on user ID
  Future<void> getUserPublishedBlogSnaps(Cat catType, String userId) async {
    try {
      List<Blog> results = [];
      QuerySnapshot<Map<String, dynamic>> response;
      switch (catType) {
        case Cat.all:
          response = await firestoreInstance
              .collection(publishedArticleSnapsCollection)
              .where(
                "user_id",
                isEqualTo: userId,
              )
              .orderBy("created_at", descending: true)
              .get();
          break;
        default:
          response = await firestoreInstance
              .collection(publishedArticleSnapsCollection)
              .where(
                "category.cat_enum",
                isEqualTo:
                    Convert.enumTostring(Cat.values, catType, () => null),
              )
              .where(
                "user_id",
                isEqualTo: userId,
              )
              .orderBy("created_at", descending: true)
              .get();
      }
      for (var blog in response.docs) {
        final data = blog.data();
        results.add(Blog.fromJson(data));
      }
      _userPublishedBlogSnaps = results;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //get the complete article
  Future<MutableDocument> getBlog(BlogType blogType, String blogId) async {
    try {
      final response = blogType == BlogType.published
          ? await firestoreInstance
              .collection(publishedArticleSnapsCollection)
              .doc(blogId)
              .collection("blog")
              .doc(blogId)
              .get()
          : await firestoreInstance
              .collection(draftArticleSnapsCollection)
              .doc(blogId)
              .collection("blog")
              .doc(blogId)
              .get();
      return DocumentJsonParser.fromJson(response.data()!);
    } catch (error) {
      rethrow;
    }
  }

  //draft or publish the article
  Future<void> saveBlog(
    BlogType blogType, {
    required Blog blogInfo,
    required Map<String, dynamic> json,
  }) async {
    try {
      if (blogType == BlogType.published) {
        //save the blog info
        await firestoreInstance
            .collection(publishedArticleSnapsCollection)
            .doc(blogInfo.id)
            .set(blogInfo.toJson());
        //save the complete blog
        await firestoreInstance
            .collection(publishedArticleSnapsCollection)
            .doc(blogInfo.id)
            .collection("blog")
            .doc(blogInfo.id)
            .set(json);

        //add the blog snap into cache
        _userPublishedBlogSnaps.add(blogInfo);
      }

      if (blogType == BlogType.draft) {
        //save the blog info
        await firestoreInstance
            .collection(draftArticleSnapsCollection)
            .doc(blogInfo.id)
            .set(blogInfo.toJson());
        //save the complete blog
        await firestoreInstance
            .collection(draftArticleSnapsCollection)
            .doc(blogInfo.id)
            .collection("blog")
            .doc(blogInfo.id)
            .set(json);
        _draftBlogSnaps.add(blogInfo);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //update the article
  Future<void> updateBlog(
    BlogType blogType, {
    required Blog blogInfo,
    required Map<String, dynamic> json,
  }) async {
    try {
      if (blogType == BlogType.published) {
        //save the blog info
        await firestoreInstance
            .collection(publishedArticleSnapsCollection)
            .doc(blogInfo.id)
            .set(blogInfo.toJson());
        //save the complete blog
        await firestoreInstance
            .collection(publishedArticleSnapsCollection)
            .doc(blogInfo.id)
            .collection("blog")
            .doc(blogInfo.id)
            .set(json);

        //add the blog snap into cache
        _userPublishedBlogSnaps.add(blogInfo);
      }

      if (blogType == BlogType.draft) {
        //save the blog info
        await firestoreInstance
            .collection(draftArticleSnapsCollection)
            .doc(blogInfo.id)
            .set(blogInfo.toJson());
        //save the complete blog
        await firestoreInstance
            .collection(draftArticleSnapsCollection)
            .doc(blogInfo.id)
            .collection("blog")
            .doc(blogInfo.id)
            .set(json);
        _draftBlogSnaps.add(blogInfo);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //delete the article/blog
  Future<void> deleteBlog(
    BlogType blogType, {
    required String blogId,
  }) async {
    try {
      if (blogType == BlogType.published) {
        //save the blog info
        await firestoreInstance
            .collection(publishedArticleSnapsCollection)
            .doc(blogId)
            .delete();

        //add the blog snap into cache
        _userPublishedBlogSnaps.removeWhere((blog) => blog.id == blogId);
      }

      if (blogType == BlogType.draft) {
        //save the blog info
        await firestoreInstance
            .collection(draftArticleSnapsCollection)
            .doc(blogId)
            .delete();

        //add the blog snap into cache
        _draftBlogSnaps.removeWhere((blog) => blog.id == blogId);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  //publish the blog from the draft
  Future<void> publishBlog(Blog blog) async {
    try {
      final response = await firestoreInstance
          .collection(draftArticleSnapsCollection)
          .doc(blog.id)
          .collection("blog")
          .doc(blog.id)
          .get();
      final json = response.data()!;
      final updatedBlog = Blog(
        id: DocumentEditor.createNodeId(),
        userId: blog.userId,
        category: blog.category,
        title: blog.title,
        description: blog.description,
        coverImage: blog.coverImage,
        tags: blog.tags,
        createdAt: blog.createdAt,
        updatedAt: blog.updatedAt,
      );
      //save the blog
      await saveBlog(
        BlogType.published,
        blogInfo: updatedBlog,
        json: json,
      );
      //delete the blog
      await deleteBlog(
        BlogType.draft,
        blogId: blog.id,
      );
      // _draftBlogSnaps.removeWhere((e) => e.id == blog.id);
      _userPublishedBlogSnaps.add(updatedBlog);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
