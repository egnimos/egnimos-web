import 'package:flutter/material.dart';

import 'colorsTheme.dart';

class AppTheme {
  AppTheme._();

  //Light Theme
  static final ThemeData lightTheme = ThemeData(
    canvasColor: Colors.transparent,
    appBarTheme: appBarTheme,
    primaryColor: ColorsTheme.primaryColor,
    scaffoldBackgroundColor: ColorsTheme.backgroundColor,
    iconTheme: iconThemeData,
    textTheme: textTheme,
  );

  static final AppBarTheme appBarTheme = AppBarTheme(
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: ColorsTheme.primaryIconColor),
    color: ColorsTheme.appBarBackgroundColor,
    elevation: 0.0,
  );

  static final IconThemeData iconThemeData =
      IconThemeData(color: ColorsTheme.primaryIconColor);

  static final TextTheme textTheme = TextTheme(
    headline1: TextStyle(
      fontFamily: 'AstroSpace',
      color: ColorsTheme.primaryTextColor,
      fontWeight: FontWeight.w500,
    ),
    headline2: TextStyle(
      fontFamily: 'AstroSpace',
      color: ColorsTheme.primaryTextColor,
      fontWeight: FontWeight.w500,
    ),
    headline3: TextStyle(
      fontFamily: 'AstroSpace',
      color: ColorsTheme.primaryTextColor,
      fontWeight: FontWeight.w500,
    ),
    headline5: TextStyle(
      fontFamily: 'AstroSpace',
      color: ColorsTheme.secondaryTextColor,
      fontWeight: FontWeight.w500,
    ),
    headline6: TextStyle(
      fontFamily: 'AstroSpace',
      color: ColorsTheme.primaryTextColor,
      fontWeight: FontWeight.w500,
    ),
    bodyText1: TextStyle(
      fontFamily: 'AstroSpace',
      color: ColorsTheme.secondaryTextColor,
      fontWeight: FontWeight.w500,
    ),
    bodyText2: TextStyle(
      fontFamily: 'AstroSpace',
      color: ColorsTheme.primaryTextColor,
      fontWeight: FontWeight.w500,
    ),
  );
}
