import 'package:egnimos/src/models/style_models/text_style_model.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../config/responsive.dart';
import '../pages/write_blog_pages/doc_to_custom_widget_generator.dart';

class ViewDocumentWidget extends StatelessWidget {
  final List<DocumentNode> doc;
  final List<TextStyleModel> textStylers;
  const ViewDocumentWidget({
    required this.textStylers,
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(physics: const ClampingScrollPhysics(), children: [
        Align(
          child: SizedBox(
            width: Responsive.widthMultiplier * 50.0,
            child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 50.0,
                  ),
                  ...DocToCustomWidgetGenerator.toWidget(doc, textStylers),
                  const SizedBox(
                    height: 50.0,
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
