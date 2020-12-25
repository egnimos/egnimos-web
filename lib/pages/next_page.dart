import 'package:egnimos/config/responsive.dart';
import 'package:egnimos/widgets/footer_widget.dart';
import 'package:egnimos/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  static const routeName = "next-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header1(
        context,
        title: "egnimos",
        selectedButtonKey: "next",
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
                      "What's Next ?",
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
