import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/src/config/responsive.dart';
import 'package:egnimos/src/models/blog.dart';
import 'package:egnimos/src/models/style_models/styler.dart';
import 'package:egnimos/src/pages/profile_page.dart';
import 'package:egnimos/src/pages/search_delegate_page.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/user_node.dart';
import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:super_editor/super_editor.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../main.dart';
import '../config/k.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/style_provider.dart';
import '../widgets/buttons.dart';
import '../widgets/egnimos_nav.dart';
import '../widgets/menu.dart';
import 'about_page.dart';
import 'auth_pages/auth_page.dart';
import 'blog_page.dart';
import 'home.dart';
import 'write_blog_pages/custom_document_nodes/checkbox_node.dart';
import 'write_blog_pages/custom_document_nodes/html_node.dart';
import 'write_blog_pages/styles/header_styles.dart';
import 'write_blog_pages/styles/inlinetext_styles.dart';
import 'write_blog_pages/styles/main_layout.dart';
import 'write_blog_pages/styles/node_styles.dart';

class ViewBlogPage extends StatefulWidget {
  final Blog blogSnap;
  final BlogType blogType;
  const ViewBlogPage({
    Key? key,
    required this.blogSnap,
    required this.blogType,
  }) : super(key: key);

  @override
  State<ViewBlogPage> createState() => _ViewBlogPageState();
}

class _ViewBlogPageState extends State<ViewBlogPage> {
  final GlobalKey _docLayoutKey = GlobalKey();
  final GlobalKey _visibilityKey = GlobalKey();

  late Document _doc;
  late DocumentEditor _docEditor;
  late DocumentComposer _composer;
  late CommonEditorOperations _docOps;

  late FocusNode _editorFocusNode;

  ScrollController? _scrollController;
  User? userInfo;
  User? currentUserInfo;
  bool _isLoading = true;
  bool _isInit = true;
  LayoutStyler? layoutStyler;
  StyleRules styleRules = [];
  Timer? timer;

  // final _darkBackground = const Color(0xFF222222);
  // final _lightBackground = Colors.white;
  // bool _isLight = true;

  // OverlayEntry? _textFormatBarOverlayEntry;
  // final _textSelectionAnchor = ValueNotifier<Offset?>(null);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      currentUserInfo = Provider.of<AuthProvider>(context, listen: false).user;
      //redirect to login screen if you are not login
      if (currentUserInfo == null) {
        Navigator.of(context).pushNamed(AuthPage.routeName);
      }
      Provider.of<BlogProvider>(context, listen: false)
          .saveActiveUser(widget.blogSnap, currentUserInfo!);
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadInfo();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _editorFocusNode.dispose();
    _composer.dispose();
    timer!.cancel();
    BlogProvider.deleteActiveUser(widget.blogSnap, currentUserInfo!);
    super.dispose();
  }

  void loadInfo() async {
    try {
      //get the user info
      userInfo = await Provider.of<AuthProvider>(context, listen: false)
          .getUserInfo(widget.blogSnap.userId);
      //get the blog
      final mutableDoc =
          await Provider.of<BlogProvider>(context, listen: false).getBlog(
        widget.blogType,
        widget.blogSnap.id,
      );
      //add the user node
      mutableDoc.nodes.insert(
        0,
        UserNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(text: userInfo?.name ?? "no-name"),
          userInfo: userInfo!,
          blogUpdatedAt: widget.blogSnap.updatedAt.toDate(),
          blogInfo: widget.blogSnap,
        ),
      );
      //get the style info
      final styleMap = await Provider.of<StyleProvider>(context, listen: false)
          .getStyle(widget.blogSnap.id);
      layoutStyler = styleMap["layout_styler"] ??
          LayoutStyler(
            layoutId: DocumentEditor.createNodeId(),
            layoutColor: Colors.white,
            layoutBgUri: "",
          );
      styleRules = styleMap["style_rules"] ?? [];
      _doc = mutableDoc..addListener(() {});
      _docEditor = DocumentEditor(document: _doc as MutableDocument);
      _composer = DocumentComposer()..addListener(() {});
      _scrollController = ScrollController()..addListener(() {});
      _docOps = CommonEditorOperations(
        editor: _docEditor,
        composer: _composer,
        documentLayoutResolver: () =>
            _docLayoutKey.currentState as DocumentLayout,
      );
      _editorFocusNode = FocusNode();
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget blogWidget(BoxConstraints constraints) {
    return Expanded(
      child: VisibilityDetector(
        key: _visibilityKey,
        onVisibilityChanged: (value) {
          try {
            final visiblePercen = value.visibleFraction * 100.0;
            print(visiblePercen);
            if (visiblePercen >= 50.0) {
              print(visiblePercen);
              final minutes = widget.blogSnap.readingTime.round();
              timer ??= Timer(Duration(minutes: minutes), () {
                //update the view count
                print("sdkjhgsdjsadjsdjksdkja::: kjdhakdksaskdaskdasd");
                Provider.of<BlogProvider>(context, listen: false)
                    .saveViewCount(widget.blogSnap, currentUserInfo!);
              });
            }
          } catch (e) {
            print(e);
          }
        },
        child: SuperEditor(
          scrollController: _scrollController,
          editor: _docEditor,
          focusNode: _editorFocusNode,
          composer: _composer,
          documentLayoutKey: _docLayoutKey,
          componentBuilders: [
            ...defaultComponentBuilders,
            CheckBoxComponentBuilder(_docEditor),
            HtmlComponentBuilder(_docEditor),
            UserComponentBuilder(_docEditor),
          ],
          stylesheet: defaultStylesheet.copyWith(
            addRulesAfter: [
              ...initialLayout(),
              ...defaultHeaders(context),
              ...nodeStyles(),
            ],
            inlineTextStyler: inlinetextStyle,
          ).copyWith(addRulesAfter: [...styleRules]),
        ),
      ),
    );
  }

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
        : Container(
            decoration: BoxDecoration(
              image: layoutStyler?.layoutBgUri.isEmpty ?? true
                  ? null
                  : DecorationImage(
                      image: CachedNetworkImageProvider(
                        layoutStyler?.layoutBgUri ?? "",
                      ),
                      fit: BoxFit.fill,
                    ),
            ),
            child: ColoredBox(
              color: layoutStyler?.layoutColor ?? Colors.black.withOpacity(0.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return Scaffold(
                  drawer: const Menu(selectedOption: NavOptions.unknown),
                  endDrawer: Drawer(
                    width: Responsive.widthMultiplier * 50.0,
                    backgroundColor: Colors.grey.shade50,
                    child: UserProfileInfoWidget(
                      constraints: constraints,
                      userInfo: userInfo!,
                      blogInfo: widget.blogSnap,
                      isDrawer: true,
                    ),
                  ),
                  body: constraints.maxWidth < K.kTableteWidth
                      ? Column(
                          children: [
                            //nav
                            const Nav(
                              selectedOption: NavOptions.unknown,
                              isBlogNav: true,
                            ),

                            //blog
                            blogWidget(constraints),
                          ],
                        )
                      : Row(
                          children: [
                            //web app info
                            SidePanelWidget(
                              constraints: constraints,
                            ),
                            //blog
                            blogWidget(constraints),
                            //User Info with blogs written by user
                            //list of active user
                            UserProfileInfoWidget(
                              constraints: constraints,
                              userInfo: userInfo!,
                              blogInfo: widget.blogSnap,
                            ),
                          ],
                        ),
                );
              }),
            ),
          );
  }
}

class UserProfileInfoWidget extends StatelessWidget {
  final User userInfo;
  final Blog blogInfo;
  final BoxConstraints constraints;
  final bool isDrawer;
  UserProfileInfoWidget(
      {Key? key,
      required this.blogInfo,
      required this.userInfo,
      required this.constraints,
      this.isDrawer = false})
      : super(key: key);

  void loadInfo(BuildContext context) async {
    try {
      //load the blog
      blogs.value = await Provider.of<BlogProvider>(context, listen: false)
          .getUserBlogSnaps(Cat.all, userInfo.id);
      isLoading.value = false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  final isLoading = ValueNotifier<bool>(true);
  final blogs = ValueNotifier<List<Blog>>([]);
  final focusNode = FocusNode();

  Widget blogInfoWidget(Blog blogInfo) {
    final dateTime =
        DateFormat('EEE, MMM d, yyyy').format(blogInfo.updatedAt.toDate());
    return SizedBox(
      width: isDrawer
          ? Responsive.widthMultiplier * 35.0
          : Responsive.widthMultiplier * 20.0,
      // height: 40.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //category
          catInfoWidget(blogInfo),
          const SizedBox(
            height: 6,
          ),
          //title
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: Text(
              blogInfo.title,
              maxLines: 2,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.raleway(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: ColorTheme.bgColor,
              ),
            ),
          ),

          //description
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: Text(
              blogInfo.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          //date & reading time
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: Text(
              dateTime,
              style: GoogleFonts.openSans(
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget catInfoWidget(Blog blogInfo) {
    return Row(
      children: [
        //cat image
        Container(
          constraints: BoxConstraints.tight(
            const Size.square(30.0),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                blogInfo.category.image?.generatedUri.isEmpty ?? true
                    ? "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_960_720.png"
                    : blogInfo.category.image!.generatedUri,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(
          width: 10.0,
        ),

        //cat name
        Text(
          blogInfo.category.label,
          style: GoogleFonts.rubik(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  final selectedTag = ValueNotifier<String>("");

  // Stream<User?>? user() {
  //   return firebaseAuth.authStateChanges().;
  // }

  @override
  Widget build(BuildContext context) {
    loadInfo(context);
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 1.1,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        height: Responsive.heightMultiplier * 100.0,
        width: Responsive.widthMultiplier * 30.0,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // search
              SizedBox(
                width: isDrawer
                    ? Responsive.widthMultiplier * 40.0
                    : Responsive.widthMultiplier * 26.0,
                child: TextField(
                  focusNode: focusNode,
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: SearchScreen(),
                    );
                    focusNode.unfocus();
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                    ),
                    hintText: "search...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: BorderSide(
                        width: 1.2,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: BorderSide(
                        width: 1.2,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22.0),
                      borderSide: BorderSide(
                        width: 1.2,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 50.0,
              ),

              //Blog Tags

              Padding(
                padding: const EdgeInsets.symmetric(
                  // horizontal: 16.0,
                  vertical: 5.0,
                ),
                child: Text(
                  "#hashTags",
                  style: GoogleFonts.handlee(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade900,
                  ),
                ),
              ),

              if (blogInfo.tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    // horizontal: 16.0,
                    vertical: 5.0,
                  ),
                  child: Wrap(
                    children: blogInfo.tags
                        .map(
                          (tag) => //tag
                              MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (val) {
                              selectedTag.value = tag;
                            },
                            onExit: (val) {
                              selectedTag.value = "";
                            },
                            child: GestureDetector(
                              onTap: () {
                                print(tag);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return TagsBlogPage(
                                    tag: tag,
                                  );
                                }));
                              },
                              child: ValueListenableBuilder<String>(
                                valueListenable: selectedTag,
                                builder: (context, value, child) => Text(
                                  "$tag ",
                                  style: GoogleFonts.handlee(
                                    fontSize: 22.0,
                                    decoration: tag == value
                                        ? TextDecoration.underline
                                        : null,
                                    decorationThickness: 2.0,
                                    decorationColor: Colors.blue.shade600,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

              const SizedBox(
                height: 30.0,
              ),

              //user image
              Container(
                constraints: BoxConstraints.tight(
                  (constraints.maxWidth < K.kTableteWidth)
                      ? const Size.square(100.0)
                      : const Size.square(100.0),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      userInfo.image?.generatedUri.isEmpty ?? true
                          ? "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_960_720.png"
                          : userInfo.image!.generatedUri,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              //user name
              Text(
                userInfo.name,
                style: GoogleFonts.rubik(
                  fontSize: constraints.maxWidth > K.kDesktopWidth
                      ? 22.0
                      : constraints.maxWidth > K.kTableteWidth
                          ? 22.0
                          : constraints.maxWidth > K.kMobileWidth
                              ? 18.0
                              : 18.0,
                  fontWeight: FontWeight.w400,
                  color: ColorTheme.primaryTextColor,
                ),
              ),

              //const
              const SizedBox(height: 16.0),

              //views
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: firestoreInstance
                    .collection(BlogProvider.viewUserCollection)
                    .doc(blogInfo.userId)
                    .collection(BlogProvider.viewCounts)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data?.docs ?? [];
                    //get the blog id
                    if (data.isNotEmpty) {
                      final viewInfo =
                          data.firstWhere((d) => d.id == blogInfo.id);
                      return Text(
                        "${viewInfo.data()["view_count"]} Views",
                        style: GoogleFonts.rubik(
                          fontSize: 18.0,
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(
                height: 40.0,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //heading
                  Text(
                    "Active Readers",
                    style: GoogleFonts.rubik(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade900,
                    ),
                  ),

                  const SizedBox(
                    height: 15.0,
                  ),

                  //visiting active users
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: firestoreInstance
                          .collection(BlogProvider.activeUsers)
                          .doc(blogInfo.id)
                          .collection(BlogProvider.users)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data?.docs ?? [];
                          return SizedBox(
                            width: isDrawer
                                ? Responsive.widthMultiplier * 35.0
                                : Responsive.widthMultiplier * 20.0,
                            height: 70.0,
                            child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, i) {
                                  final info = data[i].data();
                                  final image = info["image"];
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      constraints: BoxConstraints.tight(
                                        const Size.square(60.0),
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1.2,
                                          color: ColorTheme.bgColor18,
                                        ),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image:
                                              CachedNetworkImageProvider(image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }

                        return const SizedBox.shrink();
                      }),
                ],
              ),

              const SizedBox(
                height: 30.0,
              ),

              //more from user
              ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, isLoading, __) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //heading
                      Text(
                        "More from ${userInfo.name}",
                        style: GoogleFonts.rubik(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade900,
                        ),
                      ),

                      const SizedBox(
                        height: 40.0,
                      ),

                      //blogs
                      ValueListenableBuilder<List<Blog>>(
                          valueListenable: blogs,
                          builder: (context, values, __) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...values
                                    .map(
                                      (b) => blogInfoWidget(b),
                                    )
                                    .toList()
                              ],
                            );
                          })
                    ],
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class SidePanelWidget extends StatelessWidget {
  final BoxConstraints constraints;
  const SidePanelWidget({
    Key? key,
    required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 1.1,
            color: Colors.grey.shade600,
          ),
        ),
      ),
      height: Responsive.heightMultiplier * 100.0,
      width: Responsive.widthMultiplier * 19.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //web app name & icon
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //icon
                Flexible(
                  child: Image.asset(
                    "assets/images/png/Group_392-4.png",
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.contain,
                  ),
                ),
                //app name
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.of(context)
                          .pushReplacementNamed(Home.routeName);
                    },
                    child: EgnimosNav(
                      height: 70.0,
                      constraints: constraints,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 180.0),

            //options
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.home,
            //     size: 40.0,
            //     color: Colors.grey.shade600,
            //   ),
            // ),
            // //blogs
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.article,
            //     size: 40.0,
            //     color: Colors.grey.shade600,
            //   ),
            // ),
            // //contacts
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.contact_page,
            //     size: 40.0,
            //     color: Colors.grey.shade600,
            //   ),
            // ),
            // //profile
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.person,
            //     size: 40.0,
            //     color: Colors.grey.shade600,
            //   ),
            // ),

            MenuSwitchButton(
              label: "Home",
              option: NavOptions.home.name,
              selectedOption: NavOptions.unknown.name,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Home.routeName);
              },
            ),
            SizedBox(
              height: (constraints.maxWidth / 100) * 1.5,
            ),
            MenuSwitchButton(
              label: "About",
              option: NavOptions.about.name,
              selectedOption: NavOptions.unknown.name,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(AboutPage.routeName);
              },
            ),
            SizedBox(
              height: (constraints.maxWidth / 100) * 1.5,
            ),
            MenuSwitchButton(
              label: "Blog",
              option: NavOptions.blog.name,
              selectedOption: NavOptions.unknown.name,
              onTap: () {
                Navigator.of(context).pushReplacementNamed(BlogPage.routeName);
              },
            ),
            SizedBox(
              height: (constraints.maxWidth / 100) * 1.5,
            ),
            const ContactButton(),
            SizedBox(
              height: (constraints.maxWidth / 100) * 1.5,
            ),
            //auth button
            StreamBuilder(
                stream: firebaseAuth.authStateChanges(),
                builder: (context, snapshot) {
                  WebAppAuthState().checkAuthState().then((value) {
                    // print(value);
                  });
                  if (snapshot.data == null) {
                    return MenuSwitchButton(
                      label: "Login",
                      option: NavOptions.loginregister.name,
                      selectedOption: NavOptions.unknown.name,
                      onTap: () {
                        //navigate to the login page
                        Navigator.of(context)
                            .pushReplacementNamed(AuthPage.routeName);
                      },
                    );
                  } else {
                    return MenuSwitchButton(
                      label: "Profile",
                      option: NavOptions.profile.name,
                      selectedOption: NavOptions.unknown.name,
                      onTap: () {
                        //navigate to the login page
                        Navigator.of(context)
                            .pushReplacementNamed(ProfilePage.routeName);
                      },
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
