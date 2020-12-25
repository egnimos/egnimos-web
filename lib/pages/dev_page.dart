import 'package:egnimos/config/responsive.dart';
import 'package:egnimos/theme/colorsTheme.dart';
import 'package:egnimos/widgets/footer_widget.dart';
import 'package:egnimos/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class DevPage extends StatelessWidget {
  static const routeName = "dev-page";

  //DevCard : method creates dev widget
  Widget devCard(BuildContext context,
      {@required String photourl,
      @required String title,
      @required String content}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      width: SizeConfig.widthMultiplier * 80.0,
      height: SizeConfig.heightMultiplier * 20.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //photourl
          Container(
            constraints: BoxConstraints.tight(
                Size.square(SizeConfig.imageSizeMultiplier * 12)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  SizeConfig.imageSizeMultiplier * 12.0 / 10),
              image: DecorationImage(
                image: NetworkImage("$photourl"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //dev info
          FittedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$title",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.textMultiplier * 2.7,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "founder",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.textMultiplier * 2.5,
                          color: ColorsTheme.analogousColor1,
                        ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  width: SizeConfig.widthMultiplier * 60.0,
                  child: Text(
                    "$content",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontFamily: "NotoSansJP",
                          fontSize: SizeConfig.textMultiplier * 2.7,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Build : method creates the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header1(
        context,
        title: "egnimos",
        selectedButtonKey: "dev",
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 40),
                    child: Text(
                      "Backbone/Developers",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: SizeConfig.textMultiplier * 2.7,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 10.0,
                ),

                //list
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                  ),
                  child: Wrap(
                    spacing: 1.0,
                    runSpacing: 30.0,
                    children: [
                      //dev card
                      devCard(
                        context,
                        photourl:
                            "https://cdn.pixabay.com/photo/2020/12/18/19/11/teenager-5842706_960_720.jpg",
                        title: "Niteesh Kumar Dubey",
                        content:
                            "Hello myself niteesh kumar dubey and Iam the developer and Iam from the Whitehat junior",
                      ),
                      devCard(
                        context,
                        photourl:
                            "https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg",
                        title: "Harsh Singh",
                        content:
                            "Hello myself Harsh Singh and Iam the developer and Iam from the Whitehat junior",
                      ),
                    ],
                  ),
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
