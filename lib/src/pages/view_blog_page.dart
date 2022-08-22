import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:super_editor/super_editor.dart';

import '../models/user.dart';
import 'write_blog_pages/custom_document_nodes/checkbox_node.dart';
import 'write_blog_pages/styles/header_styles.dart';
import 'write_blog_pages/styles/inlinetext_styles.dart';
import 'write_blog_pages/styles/main_layout.dart';
import 'write_blog_pages/styles/node_styles.dart';

class ViewBlogPage extends StatefulWidget {
  final String blogId;
  final BlogType blogType;
  const ViewBlogPage({
    Key? key,
    required this.blogId,
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
      final mutableDoc =
          await Provider.of<BlogProvider>(context, listen: false).getBlog(
        widget.blogType,
        widget.blogId,
      );
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
        : Scaffold(
            body: SuperEditor(
              scrollController: _scrollController,
              editor: _docEditor,
              focusNode: _editorFocusNode,
              composer: _composer,
              documentLayoutKey: _docLayoutKey,
              componentBuilders: [
                ...defaultComponentBuilders,
                CheckBoxComponentBuilder(_docEditor),
              ],
              stylesheet: defaultStylesheet.copyWith(
                addRulesAfter: [
                  ...initialLayout(),
                  ...defaultHeaders(context),
                  ...nodeStyles(),
                ],
                inlineTextStyler: inlinetextStyle,
              ),
            ),
          );
  }
}
