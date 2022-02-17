import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

import '../widgets/rich_text_viewer.dart';

class ViewBlog extends StatefulWidget {
  final Future<NotusDocument> Function() getDoc;
  static const routeName = "/read-doc";
  const ViewBlog({
    required this.getDoc,
    Key? key,
  }) : super(key: key);

  @override
  _ViewBlogState createState() => _ViewBlogState();
}

class _ViewBlogState extends State<ViewBlog> {
  ZefyrController? _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _preloadInfo();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _preloadInfo() {
    setState(() {
      _initialLoadedData();
    });
  }

  Future<void> _initialLoadedData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final doc = await widget.getDoc();
      setState(() {
        _controller = ZefyrController(doc);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade800,
          content: Text(error.toString()),
        ),
      );
    } finally {
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _isLoading) {
      return const Scaffold(body: Center(child: Text('Loading...')));
    }
    
    return Scaffold(
      body: RichEditor(
        hideToolBar: true,
        controller: _controller!,
        focusNode: _focusNode,
        isDarkTheme: false,
      ),
    );
  }
}