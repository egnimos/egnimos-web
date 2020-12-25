import 'package:egnimos/config/responsive.dart';
import 'package:egnimos/widgets/footer_widget.dart';
import 'package:egnimos/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  static const routeName = "news-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header1(
        context,
        title: "egnimos",
        selectedButtonKey: "news",
      ),
      body: SingleChildScrollView(
        child: Container(
          width: SizeConfig.widthMultiplier * 100,
          constraints:
              BoxConstraints(minHeight: SizeConfig.heightMultiplier * 100),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Heading
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, top: 40),
                  child: Text(
                    "Updates/News",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: SizeConfig.textMultiplier * 2.7,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                // SizedBox(
                //   height: SizeConfig.heightMultiplier * 10.0,
                // ),

                Container(
                  width: SizeConfig.widthMultiplier * 100,
                  // alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/undraw_towing_6yy4.png",
                    width: SizeConfig.imageSizeMultiplier * 30.0,
                    height: SizeConfig.imageSizeMultiplier * 30.0,
                    fit: BoxFit.contain,
                  ),
                ),

                // Container(
                //   width: SizeConfig.widthMultiplier * 30.0,
                //   padding: const EdgeInsets.all(8.0),
                //   child: Expanded(
                //     child: Text(
                //       "No Update By egnimos, Soon we will reach with some new and hot updates for you stay connected to egnimos",
                //       style: Theme.of(context).textTheme.bodyText2.copyWith(
                //             fontSize: SizeConfig.textMultiplier * 3.5,
                //           ),
                //     ),
                //   ),
                // ),

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
