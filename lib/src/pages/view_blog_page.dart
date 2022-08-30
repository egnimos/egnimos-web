import 'package:cached_network_image/cached_network_image.dart';
import 'package:egnimos/src/config/responsive.dart';
import 'package:egnimos/src/models/blog.dart';
import 'package:egnimos/src/models/style_models/styler.dart';
import 'package:egnimos/src/pages/profile_page.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/user_node.dart';
import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:super_editor/super_editor.dart';

import '../../main.dart';
import '../config/k.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/style_provider.dart';
import '../widgets/buttons.dart';
import '../widgets/egnimos_nav.dart';
import 'auth_pages/auth_page.dart';
import 'blog_page.dart';
import 'home.dart';
import 'write_blog_pages/custom_document_nodes/checkbox_node.dart';
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

  late Document _doc;
  late DocumentEditor _docEditor;
  late DocumentComposer _composer;
  late CommonEditorOperations _docOps;

  late FocusNode _editorFocusNode;

  ScrollController? _scrollController;
  User? userInfo;
  bool _isLoading = true;
  bool _isInit = true;
  LayoutStyler? layoutStyler;
  StyleRules styleRules = [];

  // final _darkBackground = const Color(0xFF222222);
  // final _lightBackground = Colors.white;
  // bool _isLight = true;

  // OverlayEntry? _textFormatBarOverlayEntry;
  // final _textSelectionAnchor = ValueNotifier<Offset?>(null);

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
          category: widget.blogSnap.category,
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
      child: SuperEditor(
        scrollController: _scrollController,
        editor: _docEditor,
        focusNode: _editorFocusNode,
        composer: _composer,
        documentLayoutKey: _docLayoutKey,
        componentBuilders: [
          ...defaultComponentBuilders,
          CheckBoxComponentBuilder(_docEditor),
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
                  body: Row(
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
  final BoxConstraints constraints;
  UserProfileInfoWidget({
    Key? key,
    required this.userInfo,
    required this.constraints,
  }) : super(key: key);

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

  Widget blogInfo(Blog blogInfo) {
    final dateTime =
        DateFormat('EEE, MMM d, yyyy').format(blogInfo.updatedAt.toDate());
    return SizedBox(
      width: Responsive.widthMultiplier * 20.0,
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
              //blogs & profile
              Row(
                children: [
                  SizedBox(
                    width: (constraints.maxWidth / 100) * 1.5,
                  ),
                  MenuSwitchButton(
                    label: "Blog",
                    option: NavOptions.blog.name,
                    selectedOption: NavOptions.home.name,
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
                  StreamBuilder(
                      stream: firebaseAuth.authStateChanges(),
                      builder: (context, snapshot) {
                        // WebAppAuthState().checkAuthState().then((value) {
                        //   // print(value);
                        // });
                        if (snapshot.data == null) {
                          return MenuSwitchButton(
                            label: "Login",
                            option: NavOptions.loginregister.name,
                            selectedOption: NavOptions.home.name,
                            onTap: () {
                              //navigate to the login page
                              Navigator.of(context)
                                  .pushNamed(AuthPage.routeName);
                            },
                          );
                        } else {
                          return MenuSwitchButton(
                            label: "Profile",
                            option: NavOptions.profile.name,
                            selectedOption: NavOptions.home.name,
                            onTap: () {
                              //navigate to the login page
                              Navigator.of(context)
                                  .pushNamed(ProfilePage.routeName);
                            },
                          );
                        }
                      })
                ],
              ),

              const SizedBox(
                height: 180.0,
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

              const SizedBox(
                height: 60.0,
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
                    height: 40.0,
                  ),

                  //visiting active users
                ],
              ),

              const SizedBox(
                height: 60.0,
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
                                      (b) => blogInfo(b),
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
        ],
      ),
    );
  }
}
