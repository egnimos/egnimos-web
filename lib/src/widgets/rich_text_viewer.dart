import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zefyr/zefyr.dart';

class RichEditor extends StatelessWidget {
  final Widget topWidget;
  final ZefyrController controller;
  final bool hideToolBar;
  final FocusNode focusNode;
  final bool isDarkTheme;

  const RichEditor({
    this.topWidget = const SizedBox(),
    this.hideToolBar = true,
    required this.controller,
    required this.focusNode,
    this.isDarkTheme = false,
    Key? key,
  }) : super(key: key);

  void _launchUrl(String? url) async {
    final result = await canLaunch(url!);
    if (result) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topWidget,
        //toolbar
        if (!hideToolBar)
        ZefyrToolbar.basic(controller: controller),
        Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
        //article
        Expanded(
          child: Container(
            color: isDarkTheme ? Colors.grey.shade900 : Colors.white,
            padding: const EdgeInsets.only(left: 16.0, right: 0.0),
            child: ZefyrEditor(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              showCursor: !hideToolBar,
              expands: true,
              readOnly: hideToolBar,
              keyboardAppearance: Brightness.dark,
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 14.0,
              ),
              onLaunchUrl: _launchUrl,
              maxContentWidth: 1000,
            ),
          ),
        ),
      ],
    );
  }
}