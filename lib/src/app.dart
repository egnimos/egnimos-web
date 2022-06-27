import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/src/pages/about.dart';
import 'package:egnimos/src/pages/blog.dart';
import 'package:egnimos/src/pages/profile_page.dart';
import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/responsive.dart';
import 'pages/auth_pages/auth_page.dart';
import 'pages/home.dart';

final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BlogProvider()),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        Responsive.init(constraints);
        return MaterialApp(
            title: 'egnimos',
            theme: ThemeData.light().copyWith(
              primaryColor: ColorTheme.primaryColor,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: ColorTheme.primaryColor,
                selectionColor: ColorTheme.primaryColor.withOpacity(0.4),
                selectionHandleColor: ColorTheme.primaryColor.withOpacity(0.4),
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: const Home(),
            routes: {
              Blog.routeName: (ctx) => const Blog(),
              Home.routeName: (ctx) => const Home(),
              ProfilePage.routeName: (ctx) => const ProfilePage(),
              AboutPage.routeName: (ctx) => const AboutPage(),
              AuthPage.routeName: (ctx) => const AuthPage(),
            });
      }),
    );
  }
}
