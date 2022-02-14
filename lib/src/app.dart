import 'package:egnimos/src/theme/color_theme.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'egnimos',
      theme: ThemeData.light().copyWith(
        primaryColor: ColorTheme.primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
