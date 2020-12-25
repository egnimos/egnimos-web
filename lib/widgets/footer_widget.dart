import 'package:egnimos/config/responsive.dart';
import 'package:egnimos/legal/copyright_disclamier.dart';
import 'package:egnimos/legal/privacy_policy.dart';
import 'package:egnimos/legal/terms_condition.dart';
import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthMultiplier * 100,
      height: SizeConfig.heightMultiplier * 30,
      decoration: BoxDecoration(color: Color(0xFF121212)),
      alignment: Alignment.bottomCenter,
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
                Expanded(
                  child: Text(
                    "Learn Earn Grow",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: SizeConfig.textMultiplier * 1.8,
                          letterSpacing: 2.0,
                          // decoration: TextDecoration.underline,
                        ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: SizeConfig.widthMultiplier * 20,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 8.0),
                    child: Text(
                      "Label",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: SizeConfig.textMultiplier * 2.4,
                            // decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          TermsAndConditions.routeName,
                        );
                      },
                      child: Text(
                        "Terms & Condition",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2.0,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          PrivacyPolicy.routeName,
                        );
                      },
                      child: Text(
                        "Privacy Policy",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2.0,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: SizeConfig.widthMultiplier * 20,
          ),
          //copyright
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(
                  CopyrightInFregment.routeName,
                );
              },
              child: Text(
                "2020 egnimos copyright",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: SizeConfig.textMultiplier * 2.4,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
