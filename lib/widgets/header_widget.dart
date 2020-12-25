import 'package:egnimos/config/responsive.dart';
import 'package:egnimos/pages/about_page.dart';
import 'package:egnimos/pages/dev_page.dart';
import 'package:egnimos/pages/home_page.dart';
import 'package:egnimos/pages/news_page.dart';
import 'package:egnimos/pages/next_page.dart';
import 'package:egnimos/theme/colorsTheme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//Header1 : this method returns the appbar
AppBar header1(
  BuildContext context, {
  @required String title,
  @required String selectedButtonKey,
}) {
  return AppBar(
    automaticallyImplyLeading: true,
    backgroundColor: Colors.transparent,
    elevation: 2.0,
    title: GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(
          HomePage.routeName,
        );
      },
      child: Text(
        "$title",
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: SizeConfig.textMultiplier * 3.5,
              fontWeight: FontWeight.w700,
              color: ColorsTheme.primaryColor,
            ),
      ),
    ),
    actions: <Widget>[
      //about
      IconButton(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        tooltip: "About egnimos",
        icon: Icon(
          FontAwesomeIcons.addressCard,
          color: selectedButtonKey == "about"
              ? ColorsTheme.triadicColor
              : ColorsTheme.darkBlueColor,
        ),
        onPressed: () async {
          await Navigator.of(context).pushReplacementNamed(AboutPage.routeName);
        },
      ),
      //update
      IconButton(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        tooltip: "Update or News",
        icon: Icon(
          FontAwesomeIcons.newspaper,
          color: selectedButtonKey == "news"
              ? ColorsTheme.triadicColor
              : ColorsTheme.darkBlueColor,
        ),
        onPressed: () async {
          await Navigator.of(context).pushReplacementNamed(NewsPage.routeName);
        },
      ),
      //dev
      IconButton(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        tooltip: "backbone developer",
        icon: Icon(
          FontAwesomeIcons.dev,
          color: selectedButtonKey == "dev"
              ? ColorsTheme.triadicColor
              : ColorsTheme.darkBlueColor,
        ),
        onPressed: () async {
          await Navigator.of(context).pushReplacementNamed(DevPage.routeName);
        },
      ),
      //what next
      IconButton(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        tooltip: "What's Next",
        icon: Icon(
          FontAwesomeIcons.neos,
          color: selectedButtonKey == "next"
              ? ColorsTheme.triadicColor
              : ColorsTheme.darkBlueColor,
        ),
        onPressed: () async {
          await Navigator.of(context).pushReplacementNamed(NextPage.routeName);
        },
      ),
    ],
  );
}

//Header2 : this header returns the appbar
AppBar header2(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: true,
    backgroundColor: Colors.transparent,
    elevation: 2.0,
    title: GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(
          HomePage.routeName,
        );
      },
      child: Text(
        "egnimos",
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: SizeConfig.textMultiplier * 3.5,
              fontWeight: FontWeight.w700,
              color: ColorsTheme.primaryColor,
            ),
      ),
    ),
  );
}
