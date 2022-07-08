import 'package:egnimos/src/pages/about.dart';
import 'package:egnimos/src/pages/blog.dart';
import 'package:egnimos/src/pages/profile_page.dart';
import 'package:egnimos/src/providers/auth_provider.dart';
import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/theme/color_theme.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'config/responsive.dart';
import 'pages/auth_pages/auth_page.dart';
import 'pages/home.dart';
import 'providers/upload_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool _isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   loadInfo();
  // }

  // void loadInfo() async {
  //   await Future.delayed(const Duration(seconds: 5), () {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UploadProvider>(
          create: (context) => UploadProvider(),
        ),
        ChangeNotifierProxyProvider<UploadProvider, AuthProvider>(
          create: (context) => AuthProvider(),
          update: (context, up, ap) => ap!..update(up),
        ),
        ChangeNotifierProvider(
          create: (context) => BlogProvider(),
        ),
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
