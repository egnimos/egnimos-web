import 'package:egnimos/src/pages/blog_page.dart';
import 'package:egnimos/src/pages/profile_page.dart';
import 'package:flutter/material.dart';
import '/main.dart';
import '../pages/about_page.dart';
import '../pages/auth_pages/auth_page.dart';
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
          //header when it is login show the profile info
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
                    option: NavOptions.home.name,
                    selectedOption: selectedOption.name,
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
                    option: NavOptions.about.name,
                    selectedOption: selectedOption.name,
                    onTap: () {
                      Navigator.of(context).pushNamed(AboutPage.routeName);
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  MenuSwitchButton(
                    label: "Blog",
                    isDrawerButton: true,
                    option: NavOptions.blog.name,
                    selectedOption: selectedOption.name,
                    onTap: () {
                      Navigator.of(context).pushNamed(BlogPage.routeName);
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const ContactButton(),
                  const SizedBox(
                    height: 20.0,
                  ),
                  //auth button
                  StreamBuilder(
                      stream: firebaseAuth.authStateChanges(),
                      builder: (context, snapshot) {
                        // WebAppAuthState().checkAuthState().then((value) {
                        //   // //print(value);
                        // });
                        if (snapshot.data == null) {
                          return MenuSwitchButton(
                            label: "Login",
                            isDrawerButton: true,
                            option: NavOptions.loginregister.name,
                            selectedOption: selectedOption.name,
                            onTap: () {
                              //navigate to the auth screen
                              Navigator.of(context)
                                  .pushNamed(AuthPage.routeName);
                            },
                          );
                        } else {
                          return MenuSwitchButton(
                            label: "Profile",
                            isDrawerButton: true,
                            option: NavOptions.profile.name,
                            selectedOption: selectedOption.name,
                            onTap: () {
                              //navigate to the auth screen
                              Navigator.of(context)
                                  .pushNamed(ProfilePage.routeName);
                            },
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
