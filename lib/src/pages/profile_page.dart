import 'package:egnimos/src/config/k.dart';
import 'package:egnimos/src/providers/auth_provider.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/edit_profile_widget.dart';
import 'package:egnimos/src/widgets/indicator_widget.dart';
import 'package:egnimos/src/widgets/profile_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../widgets/buttons.dart';
import '../widgets/footer.dart';
import 'home.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = "/profile-page";
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInfo();
  }

  void loadInfo() async {
    await Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Widget switchScreens(BoxConstraints constraints) {
    switch (_selectedOptions) {
      case ProfileOptions.edit:
        return Expanded(
          child: EditProfileWidget(
            constraints: constraints,
          ),
        );
      default:
        return Container();
    }
  }

  ProfileOptions _selectedOptions = ProfileOptions.blogs;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            body: Center(
              child: Lottie.asset(
                "assets/json/home-loading.json",
                repeat: true,
              ),
            ),
          )
        : LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
              drawer: NavigationRailWide(
                selectedOption: _selectedOptions,
                isDrawer: true,
                constraints: constraints,
                onTap: (option) {
                  setState(() {
                    _selectedOptions = option;
                  });
                },
              ),
              body: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Row(
                  children: [
                    //navigation
                    if (constraints.maxWidth > K.kTableteWidth)
                      Expanded(
                        child: NavigationRailWide(
                          selectedOption: _selectedOptions,
                          constraints: constraints,
                          onTap: (option) {
                            setState(() {
                              _selectedOptions = option;
                            });
                          },
                        ),
                      ),

                    //profile info
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          //nav
                          Consumer<AuthProvider>(
                            builder: (context, ap, __) => ProfileNavWidget(
                              constraints: constraints,
                              userInf: ap.user!,
                            ),
                          ),

                          //divider
                          Divider(
                            indent: 30,
                            endIndent: 30,
                            color: Colors.grey.shade800,
                            height: 0.0,
                          ),

                          //screen
                          switchScreens(constraints),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: ColorTheme.bgColor14,
                child: const Icon(
                  Icons.create,
                  color: Colors.white,
                ),
                onPressed: () {
                  IndicatorWidget.showCreateBlogModal(context);
                },
              ),
            );
          });
  }
}

class NavigationRailWide extends StatelessWidget {
  final BoxConstraints? constraints;
  final ProfileOptions selectedOption;
  final bool isDrawer;
  final void Function(ProfileOptions option) onTap;
  const NavigationRailWide({
    this.isDrawer = false,
    required this.onTap,
    required this.selectedOption,
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      width: isDrawer ? 300.0 : constraints!.maxWidth,
      height: isDrawer
          ? MediaQuery.of(context).size.height
          : constraints!.maxHeight,
      decoration: const BoxDecoration(
        color: ColorTheme.bgColor2,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 20.0,
        ),

        //heading
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Profile",
            style: GoogleFonts.rubik(
              fontSize: constraints!.maxWidth > K.kDesktopWidth
                  ? 42.0
                  : constraints!.maxWidth > K.kTableteWidth
                      ? 36.0
                      : constraints!.maxWidth > K.kMobileWidth
                          ? 24.0
                          : 22.0,
              fontWeight: FontWeight.w400,
              color: ColorTheme.secondaryTextColor,
            ),
          ),
        ),

        //divider
        const Divider(
          indent: 10.0,
          endIndent: 10.0,
          color: Colors.white,
        ),

        const SizedBox(
          height: 100.0,
        ),

        //options
        ListView(
          shrinkWrap: true,
          children: [
            //blogs
            ProfileMenuButton(
              value: "Blogs",
              icon: Icons.article,
              index: ProfileOptions.blogs.name,
              selectedIndex: selectedOption.name,
              onTap: () => onTap(ProfileOptions.blogs),
            ),

            const SizedBox(
              height: 20.0,
            ),
            //edit profile,
            ProfileMenuButton(
              value: "Edit Profile",
              icon: Icons.edit,
              index: ProfileOptions.edit.name,
              selectedIndex: selectedOption.name,
              onTap: () => onTap(ProfileOptions.edit),
            ),
          ],
        ),

        //spacer
        const Spacer(
          flex: 6,
        ),

        //divider
        const Divider(
          indent: 10.0,
          endIndent: 10.0,
          color: Colors.white,
        ),

        //footer
        //icon
        GestureDetector(
          onTap: () async {
            await Navigator.of(context).pushReplacementNamed(Home.routeName);
          },
          child: Flexible(
            child: Row(children: [
              const SizedBox(
                width: 8.0,
              ),
              Image.asset(
                "assets/images/png/Group_392-4.png",
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    "EGNIMOS",
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.raleway().copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),

        const SizedBox(
          height: 20.0,
        ),
      ]),
    );
  }
}
