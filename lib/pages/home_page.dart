import 'package:egnimos/config/responsive.dart';
import 'package:egnimos/pages/about_page.dart';
import 'package:egnimos/pages/dev_page.dart';
import 'package:egnimos/pages/news_page.dart';
import 'package:egnimos/pages/next_page.dart';
import 'package:egnimos/theme/colorsTheme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const routeName = "home-page";

  //Nav Button
  Widget navButton(
    BuildContext context, {
    @required String title,
    @required Function onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "$title",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: SizeConfig.textMultiplier * 4.0,
                color: ColorsTheme.darkBlueColor,
                decoration: TextDecoration.underline,
                decorationColor: ColorsTheme.primaryColor,
                decorationThickness: 2.5,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 2.0,
        title: Text(
          "egnimos",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: SizeConfig.textMultiplier * 3.5,
                fontWeight: FontWeight.w700,
                color: ColorsTheme.primaryColor,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: SizeConfig.widthMultiplier * 100,
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 20.0,
              ),
              // egnimos Icon
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/em1.png",
                  width: SizeConfig.imageSizeMultiplier * 35,
                  height: SizeConfig.imageSizeMultiplier * 15,
                  fit: BoxFit.contain,
                ),
              ),

              // options
              Container(
                width: SizeConfig.widthMultiplier * 80,
                alignment: Alignment.center,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      navButton(context, title: "About", onPressed: () {
                        Navigator.of(context).pushNamed(AboutPage.routeName);
                      }),
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 2.5,
                      ),
                      navButton(context, title: "Updates/News", onPressed: () {
                        Navigator.of(context).pushNamed(NewsPage.routeName);
                      }),
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 2.5,
                      ),
                      navButton(context, title: "BackBone/Developers",
                          onPressed: () {
                        Navigator.of(context).pushNamed(DevPage.routeName);
                      }),
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 2.5,
                      ),
                      navButton(
                        context,
                        title: "What's Next",
                        onPressed: () {
                          Navigator.of(context).pushNamed(NextPage.routeName);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 20.0,
              ),

              //footer
              Divider(),
              Container(
                width: SizeConfig.widthMultiplier * 100,
                height: SizeConfig.heightMultiplier * 30,
                decoration: BoxDecoration(color: Color(0xFF121212)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //image icon...
                    Container(
                      alignment: Alignment.center,
                      width: SizeConfig.widthMultiplier * 20.0,
                      height: SizeConfig.heightMultiplier * 20.0,
                      child: Column(
                        children: [
                          // Expanded(
                          // child:
                          Image.asset(
                            "assets/images/em1.png",
                            width: SizeConfig.imageSizeMultiplier * 10.0,
                            height: SizeConfig.imageSizeMultiplier * 6.0,
                            fit: BoxFit.contain,
                          ),
                          // ),

                          //info
                          Text(
                            "Learn Earn Grow",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: SizeConfig.textMultiplier * 2.0,
                                      letterSpacing: 2.0,
                                      // decoration: TextDecoration.underline,
                                    ),
                          )
                        ],
                      ),
                    ),
                    //legal
                    Container(
                      alignment: Alignment.center,
                      width: SizeConfig.widthMultiplier * 20.0,
                      height: SizeConfig.heightMultiplier * 18.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //label
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 8.0),
                            child: Text(
                              "Label",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2.6,
                                    // decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Terms & Condition",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Privacy Policy",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //copyright
                    Text(
                      "2020 egnimos copyright",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: SizeConfig.textMultiplier * 2.5,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
