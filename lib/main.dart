import 'package:egnimos/config/responsive.dart';
import 'package:egnimos/legal/copyright_disclamier.dart';
import 'package:egnimos/legal/privacy_policy.dart';
import 'package:egnimos/legal/terms_condition.dart';
import 'package:egnimos/pages/about_page.dart';
import 'package:egnimos/pages/dev_page.dart';
import 'package:egnimos/pages/home_page.dart';
import 'package:egnimos/pages/next_page.dart';
import 'package:egnimos/theme/appTheme.dart';
import 'package:flutter/material.dart';

//parser import
// import 'package:html/parser.dart' show parse;
// import 'package:html/dom.dart';

import 'pages/news_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MaterialApp(
          title: 'egnimos',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: HomePage(),
          routes: {
            HomePage.routeName: (ctx) => HomePage(),
            NextPage.routeName: (ctx) => NextPage(),
            AboutPage.routeName: (ctx) => AboutPage(),
            DevPage.routeName: (ctx) => DevPage(),
            NewsPage.routeName: (ctx) => NewsPage(),
            CopyrightInFregment.routeName: (ctx) => CopyrightInFregment(),
            PrivacyPolicy.routeName: (ctx) => PrivacyPolicy(),
            TermsAndConditions.routeName: (ctx) => TermsAndConditions(),
          },
        );
      });
    });
  }
}
