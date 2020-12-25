import 'package:egnimos/config/responsive.dart';
import 'package:egnimos/pages/about_page.dart';
import 'package:egnimos/pages/dev_page.dart';
import 'package:egnimos/pages/news_page.dart';
import 'package:egnimos/pages/next_page.dart';
import 'package:egnimos/theme/colorsTheme.dart';
import 'package:egnimos/widgets/footer_widget.dart';
import 'package:egnimos/widgets/header_widget.dart';
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
      appBar: header2(context),
      body: SingleChildScrollView(
        child: Container(
          width: SizeConfig.widthMultiplier * 100,
          constraints:
              BoxConstraints(minHeight: SizeConfig.heightMultiplier * 100),
          child: IntrinsicHeight(
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
                          Navigator.of(context)
                              .pushReplacementNamed(AboutPage.routeName);
                        }),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 2.5,
                        ),
                        navButton(context, title: "Updates/News",
                            onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(NewsPage.routeName);
                        }),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 2.5,
                        ),
                        navButton(context, title: "BackBone/Developers",
                            onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(DevPage.routeName);
                        }),
                        SizedBox(
                          width: SizeConfig.widthMultiplier * 2.5,
                        ),
                        navButton(
                          context,
                          title: "What's Next",
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(NextPage.routeName);
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
                Spacer(),
                FooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
