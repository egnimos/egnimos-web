import 'package:egnimos/src/pages/blog.dart';
import 'package:flutter/material.dart';

import '../pages/home.dart';
import '../theme/color_theme.dart';
import '../utility/enum.dart';
import 'buttons.dart';

class Menu extends StatelessWidget {
  final NavOptions selectedOption;
  const Menu({
    required this.selectedOption,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green.shade50,
      elevation: 6.0,
      semanticLabel: "menu drawer",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Menu",
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: ColorTheme.bgColor2,
                  ),
            ),
          ),

          const Divider(
            color: Colors.white,
            indent: 10.0,
            endIndent: 10.0,
          ),

          //body
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  MenuSwitchButton(
                    label: "Home",
                    isDrawerButton: true,
                    option: NavOptions.home,
                    selectedOption: selectedOption,
                    onTap: () {
                      Navigator.of(context).pushNamed(Home.routeName);
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  MenuSwitchButton(
                    label: "About",
                    isDrawerButton: true,
                    option: NavOptions.about,
                    selectedOption: selectedOption,
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  MenuSwitchButton(
                    label: "Blog",
                    isDrawerButton: true,
                    option: NavOptions.blog,
                    selectedOption: selectedOption,
                    onTap: () {
                      Navigator.of(context).pushNamed(Blog.routeName);
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const ContactButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
