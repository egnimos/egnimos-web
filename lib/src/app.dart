import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/src/pages/blog.dart';
import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home.dart';

final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BlogProvider()),
      ],
      child: MaterialApp(
          title: 'egnimos',
          theme: ThemeData.light().copyWith(
            primaryColor: ColorTheme.primaryColor,
          ),
          debugShowCheckedModeBanner: false,
          home: const Home(),
          routes: {
            Blog.routeName: (ctx) => const Blog(),
            Home.routeName: (ctx) => const Home(),
          }),
    );
  }
}
