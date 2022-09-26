import 'package:egnimos/src/config/k.dart';
import 'package:egnimos/src/pages/home.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/widgets/egnimos_nav.dart';
import 'package:flutter/material.dart';

import 'auth_box.dart';

class AuthPage extends StatelessWidget {
  static const routeName = "/login-page";
  const AuthPage({Key? key}) : super(key: key);

  Widget authBox(BoxConstraints constraints, BuildContext context) {
    return Container(
      height: constraints.maxHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        children: [
          //web app name & icon
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).pushReplacementNamed(Home.routeName);
            },
            child: EgnimosNav(
              height: 90.0,
              constraints: constraints,
            ),
          ),

          //space
          SizedBox(
            height: (constraints.maxHeight / 100) * 20.0,
          ),

          //login box
          AuthBox(
              constraints: constraints,
            ),
        

          const SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        //tablet & mobile
        if (constraints.maxWidth < K.kTableteWidth) {
          return authBox(constraints, context);
        }
        return Row(
          children: [
            Expanded(
              child: authBox(constraints, context),
            ),
            //egnimos logo and info
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorTheme.bgColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //icon
                    Flexible(
                      child: Image.asset(
                        "assets/images/png/Group_392-2.png",
                        width: 150.0,
                        height: 150.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    //icon name
                    Flexible(
                      child: Text(
                        "EGNIMOS",
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: constraints.maxWidth > K.kMobileWidth
                              ? 40.0
                              : 30.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: Colors.grey.shade100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
