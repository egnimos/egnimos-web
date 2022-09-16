import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/main.dart';
import 'package:egnimos/src/models/blog.dart';
import 'package:egnimos/src/widgets/blog_post_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../providers/blog_provider.dart';

class SearchScreen extends SearchDelegate {
  SearchScreen();

  @override
  String get searchFieldLabel {
    return "enter your keyword";
  }

  //**buildActions
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      //clear the keyword
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  //**buildLeading
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  //**buildResults
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Blog>>(
        future: searchBlogs(),
        builder: (context, snapshot) {
          //waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final blogs = snapshot.data ?? [];
            return blogs.isEmpty
                ? Container(
                    width: double.infinity,
                    height: 250.0,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Expanded(
                          child: Lottie.asset(
                            "assets/json/not-found.json",
                            reverse: true,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "no blog post available",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  )
                : Wrap(
                    children: blogs
                        .map((bo) => BlogPostCard(
                              blog: bo,
                              showEditOptions: false,
                            ))
                        .toList(),
                  );
          }
          return const SizedBox.shrink();
        });
  }

  Future<List<Blog>> searchBlogs() async {
    try {
      if (query.isEmpty) {
        return <Blog>[];
      }

      final response = await firestoreInstance
          .collection(BlogProvider.publishedArticleSnapsCollection)
          .where(
            "search_chars",
            arrayContains: query.toLowerCase(),
          )
          .orderBy("created_at", descending: true)
          .get();

      List<Blog> results = [];
      for (var blog in response.docs) {
        final data = blog.data();
        results.add(Blog.fromJson(data));
      }
      return results;
    } catch (error) {
      //print(error);
      rethrow;
    }
  }

  //**buildSuggestions
  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreInstance
            .collection(BlogProvider.publishedArticleSnapsCollection)
            .where(
              "search_chars",
              arrayContains: query.toLowerCase(),
            )
            .orderBy("created_at", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data?.docs ?? [];
            final blogs = data.map((d) => Blog.fromJson(d.data())).toList();
            return Wrap(
              children: blogs
                  .map((bo) => BlogPostCard(
                        blog: bo,
                        showEditOptions: false,
                      ))
                  .toList(),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
