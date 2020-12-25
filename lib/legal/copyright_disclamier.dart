import 'package:egnimos/config/responsive.dart';
import 'package:egnimos/localData/copyright_data.dart';
import 'package:egnimos/theme/colorsTheme.dart';
import 'package:egnimos/widgets/footer_widget.dart';
import 'package:egnimos/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class CopyrightInFregment extends StatelessWidget {
  static const routeName = "/copyright-screen";

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //notice
                Container(
                  padding:
                      const EdgeInsets.only(left: 40.0, top: 10, bottom: 10.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.3),
                      border: Border(
                        left: BorderSide(
                          color: Colors.redAccent,
                        ),
                        right: BorderSide(
                          color: Colors.redAccent,
                        ),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //heading....
                      Text(
                        "Notice:",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2.7,
                            ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier,
                      ),
                      //main content...
                      Text(
                        "These Policies are undergoing renewal process so these points will change after some time as egnimos strictly follows the privacy of each and every user so all the policies will be oriented with the user security. So keep checking the legal terms of the egnimos as egnimos and there products hold different legal terms. Keep supporting Us Thank you",
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontFamily: "NotoSansJP",
                              fontSize: SizeConfig.textMultiplier * 2.5,
                              // fontWeight: FontWeight.w500,
                            ),
                      )
                    ],
                  ),
                ),
                //Heading
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 40),
                    child: Text(
                      "CopyRight Policy",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: SizeConfig.textMultiplier * 2.7,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 8.0,
                ),

                //content
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      // vertical: 30.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: copyrightContent
                          .map((copyright) => Container(
                                child: RichText(
                                  text: TextSpan(
                                      text: "${copyright.heading}\n\n\n",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 2.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                      children: [
                                        TextSpan(
                                          text: "${copyright.content}\n\n\n",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                fontFamily: "NotoSansJP",
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        2.2,
                                                // fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ]),
                                ),
                              ))
                          .toList(),
                    )),
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
