import 'package:egnimos/src/config/k.dart';
import 'package:egnimos/src/providers/auth_provider.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/utility/verify_for_admin.dart';
import 'package:egnimos/src/widgets/category_list_widget.dart';
import 'package:egnimos/src/widgets/create_pop_up_modal_widget.dart';
import 'package:egnimos/src/widgets/edit_profile_widget.dart';
import 'package:egnimos/src/widgets/file_collection_list.dart';
import 'package:egnimos/src/widgets/indicator_widget.dart';
import 'package:egnimos/src/widgets/profile_nav_widget.dart';
import 'package:egnimos/src/widgets/user_blogs_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../widgets/buttons.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final routeInfo =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _selectedOptions = routeInfo?["profile_option"] ?? ProfileOptions.blogs;
      setState(() {});
    });
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
      case ProfileOptions.blogs:
        return Expanded(
          child: UserBlogsWidget(
            constraints: constraints,
            blogType: BlogType.published,
          ),
        );
      case ProfileOptions.drafts:
        return Expanded(
          child: UserBlogsWidget(
            constraints: constraints,
            blogType: BlogType.draft,
          ),
        );
      case ProfileOptions.category:
        return Expanded(
          child: CategoryListWidget(
            constraints: constraints,
          ),
        );
      case ProfileOptions.publishedBlogs:
        return Expanded(
          child: UserBlogsWidget(
            constraints: constraints,
            blogType: BlogType.published,
            isAdmin: true,
          ),
        );
      case ProfileOptions.messages:
        return Container();
      case ProfileOptions.collections:
        return Expanded(
          child: FileCollectionList(
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
    // final user = Provider.of<AuthProvider>(context, listen: false).user;
    return _isLoading
        ? Scaffold(
            body: Center(
              child: Lottie.asset(
                "assets/json/home-loading.json",
                repeat: true,
              ),
            ),
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onTap: () {
                  enableEditingFile.value = "";
                },
                child: Scaffold(
                  drawer: NavigationRailWide(
                    selectedOption: _selectedOptions,
                    isDrawer: true,
                    constraints: constraints,
                    onTap: (option) {
                      if (_selectedOptions == option) return;
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
                                if (_selectedOptions == option) return;
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
                  floatingActionButton: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //upload image
                      FloatingActionButton(
                        backgroundColor: Colors.blue.shade400,
                        child: const Icon(
                          Icons.file_upload,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          IndicatorWidget.showCreateBlogModal(
                            context,
                            barrierDismissible: false,
                            child: UploadFilePopUpModel(
                              constraints: constraints,
                            ),
                          );
                        },
                      ),

                      if (VerifyAdminForUser.isVerified(context))
                        const SizedBox(
                          height: 20.0,
                        ),
                      if (VerifyAdminForUser.isVerified(context))
                        //create category
                        FloatingActionButton(
                          backgroundColor: Colors.grey.shade900,
                          child: const Icon(
                            Icons.category,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            IndicatorWidget.showCreateBlogModal(
                              context,
                              child: CreateCategoryPopupModel(
                                  constraints: constraints),
                            );
                          },
                        ),

                      const SizedBox(
                        height: 20.0,
                      ),
                      //create
                      FloatingActionButton(
                        backgroundColor: ColorTheme.bgColor14,
                        child: const Icon(
                          Icons.create,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          IndicatorWidget.showCreateBlogModal(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
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
    // final user = Provider.of<AuthProvider>(context, listen: false).user;
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
      child: ListView(shrinkWrap: true, children: [
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
        ProfileMenuButton(
          value: "Drafts",
          icon: Icons.drafts,
          index: ProfileOptions.drafts.name,
          selectedIndex: selectedOption.name,
          onTap: () => onTap(ProfileOptions.drafts),
        ),
        if (VerifyAdminForUser.isVerified(context))
          const SizedBox(
            height: 20.0,
          ),
        if (VerifyAdminForUser.isVerified(context))
          ProfileMenuButton(
            value: "Published Blogs",
            icon: Icons.article_outlined,
            index: ProfileOptions.publishedBlogs.name,
            selectedIndex: selectedOption.name,
            onTap: () => onTap(ProfileOptions.publishedBlogs),
          ),
        if (VerifyAdminForUser.isVerified(context))
          const SizedBox(
            height: 20.0,
          ),
        if (VerifyAdminForUser.isVerified(context))
          //categories,
          ProfileMenuButton(
            value: "Categories",
            icon: Icons.category,
            index: ProfileOptions.category.name,
            selectedIndex: selectedOption.name,
            onTap: () => onTap(ProfileOptions.category),
          ),

        const SizedBox(
          height: 20.0,
        ),
        //categories,
        ProfileMenuButton(
          value: "Collections",
          icon: Icons.collections,
          index: ProfileOptions.collections.name,
          selectedIndex: selectedOption.name,
          onTap: () => onTap(ProfileOptions.collections),
        ),

        // const SizedBox(
        //   height: 20.0,
        // ),
        // //messages,
        // ProfileMenuButton(
        //   value: "Messages",
        //   icon: Icons.message,
        //   index: ProfileOptions.messages.name,
        //   selectedIndex: selectedOption.name,
        //   onTap: () => onTap(ProfileOptions.messages),
        // ),

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

        const SizedBox(
          height: 20.0,
        ),

        //logout,
        ProfileMenuButton(
          value: "Logout",
          icon: Icons.logout,
          index: "",
          selectedIndex: "logout",
          onTap: () async {
            await Provider.of<AuthProvider>(context, listen: false).logout();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Home.routeName, (route) => true);
          },
        ),

        //spacer
        const SizedBox(
          height: 60,
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
          ]),
        ),

        const SizedBox(
          height: 20.0,
        ),
      ]),
    );
  }
}
