import 'package:egnimos/src/config/k.dart';
import 'package:egnimos/src/pages/about_page.dart';
import 'package:egnimos/src/pages/auth_pages/auth_page.dart';
import 'package:egnimos/src/pages/blog_page.dart';
import 'package:egnimos/src/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/main.dart';
import '../pages/auth_pages/auth_page.dart';
import '../pages/home.dart';
import '../theme/color_theme.dart';
import '../utility/enum.dart';

class MenuSwitchButton extends StatefulWidget {
  final String option;
  final String label;
  final String selectedOption;
  final bool isDrawerButton;
  final void Function() onTap;
  const MenuSwitchButton({
    required this.label,
    required this.option,
    required this.selectedOption,
    required this.onTap,
    this.isDrawerButton = false,
    Key? key,
  }) : super(key: key);

  @override
  State<MenuSwitchButton> createState() => _MenuSwitchButtonState();
}

class _MenuSwitchButtonState extends State<MenuSwitchButton> {
  double width = 0.0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        //highlight
        if (widget.isDrawerButton && (widget.option == widget.selectedOption))
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.green.shade200,
            ),
          ),
        SizedBox(
          width: 100.0,
          height: 50.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MouseRegion(
                onEnter: (value) {
                  setState(() {
                    width = 60.0;
                  });
                },
                onExit: (value) {
                  setState(() {
                    width = 0.0;
                  });
                },
                child: TextButton(
                  onPressed: widget.onTap,
                  style: TextButton.styleFrom(
                    primary: !widget.isDrawerButton
                        ? widget.option == widget.selectedOption
                            ? ColorTheme.bgColor6
                            : ColorTheme.primaryTextColor
                        : ColorTheme.primaryTextColor,
                    textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  child: Text(
                    widget.label,
                    style: GoogleFonts.rubik().copyWith(
                      fontSize: 25.0,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              //on hover
              AnimatedContainer(
                margin: const EdgeInsets.only(top: 4.0),
                duration: const Duration(milliseconds: 330),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: ColorTheme.bgColor16,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: 4.0,
                width: width,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//Navigation Buttons
class NavButtons extends StatelessWidget {
  final NavOptions selectedOption;
  final BoxConstraints constraints;

  const NavButtons({
    required this.selectedOption,
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: constraints.maxWidth < K.kTableteWidth
          ? MainAxisAlignment.end
          : MainAxisAlignment.center,
      children: constraints.maxWidth < K.kTableteWidth
          ? <Widget>[
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
            ]
          : <Widget>[
              MenuSwitchButton(
                label: "Home",
                option: NavOptions.home.name,
                selectedOption: selectedOption.name,
                onTap: () {
                  Navigator.of(context).pushNamed(Home.routeName);
                },
              ),
              SizedBox(
                width: (constraints.maxWidth / 100) * 1.5,
              ),
              MenuSwitchButton(
                label: "About",
                option: NavOptions.about.name,
                selectedOption: selectedOption.name,
                onTap: () {
                  Navigator.of(context).pushNamed(AboutPage.routeName);
                },
              ),
              SizedBox(
                width: (constraints.maxWidth / 100) * 1.5,
              ),
              MenuSwitchButton(
                label: "Blog",
                option: NavOptions.blog.name,
                selectedOption: selectedOption.name,
                onTap: () {
                  Navigator.of(context).pushNamed(BlogPage.routeName);
                },
              ),
              SizedBox(
                width: (constraints.maxWidth / 100) * 1.5,
              ),
              const ContactButton(),
              SizedBox(
                width: (constraints.maxWidth / 100) * 1.5,
              ),
              //auth button
              StreamBuilder<User?>(
                  stream: firebaseAuth.authStateChanges(),
                  builder: (context, snapshot) {
                    WebAppAuthState().checkAuthState().then((value) {
                      // print(value);
                    });
                    if (snapshot.data == null) {
                      return MenuSwitchButton(
                        label: "Login",
                        option: NavOptions.loginregister.name,
                        selectedOption: selectedOption.name,
                        onTap: () {
                          //navigate to the login page
                          Navigator.of(context).pushNamed(AuthPage.routeName);
                        },
                      );
                    } else {
                      return MenuSwitchButton(
                        label: "Profile",
                        option: NavOptions.profile.name,
                        selectedOption: selectedOption.name,
                        onTap: () {
                          //navigate to the login page
                          Navigator.of(context)
                              .pushNamed(ProfilePage.routeName);
                        },
                      );
                    }
                  })
            ],
    );
  }
}

class ContactButton extends StatefulWidget {
  const ContactButton({Key? key}) : super(key: key);

  @override
  State<ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<ContactButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Color textColor = ColorTheme.bgColor10;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        _animationController.animateTo(1.0);
        setState(() {
          textColor = Colors.white;
        });
      },
      onExit: (value) {
        _animationController.animateBack(0.0);
        setState(() {
          textColor = ColorTheme.bgColor10;
        });
      },
      child: AnimatedBuilder(
          child: Text(
            "Contact",
            style: GoogleFonts.rubik().copyWith(
              fontSize: 22.0,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          animation: _animationController,
          builder: (c, child) {
            return Container(
              width: 150.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: ColorTheme.bgColor16
                    .withOpacity(_animationController.value),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: ColorTheme.bgColor16,
                  width: 2.0,
                ),
              ),
              alignment: Alignment.center,
              child: child,
            );
          }),
    );
  }
}

class SocialAuthButton extends StatelessWidget {
  final BoxConstraints constraints;
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color labelColor;
  final Color iconColor;
  final Color bgColor;
  const SocialAuthButton({
    required this.constraints,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.labelColor,
    required this.iconColor,
    required this.bgColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0,
        ),
        elevation: 4.0,
        child: Container(
          height: 54.0,
          width: constraints.maxWidth > K.kMobileWidth ? 300.0 : 200.0,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //icon
              Icon(
                icon,
                color: iconColor,
                size: 28.0,
              ),
              const SizedBox(
                width: 10.0,
              ),
              //icon name
              Text(
                label,
                style: GoogleFonts.rubik().copyWith(
                  fontSize: 18.0,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuButton extends StatelessWidget {
  final String index;
  final String selectedIndex;
  final String value;
  final VoidCallback onTap;
  final IconData icon;

  const ProfileMenuButton({
    required this.index,
    required this.icon,
    required this.onTap,
    required this.value,
    required this.selectedIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectedIndex == index
          ? () {
              Navigator.pop(context);
            }
          : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: selectedIndex == index ? Colors.white24 : Colors.transparent,
          border: Border(
            right: BorderSide(
              color: selectedIndex == index
                  ? ColorTheme.primaryColor
                  : Colors.transparent,
              width: 5.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: GoogleFonts.rubik().copyWith(
                  fontSize: 20.0,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
