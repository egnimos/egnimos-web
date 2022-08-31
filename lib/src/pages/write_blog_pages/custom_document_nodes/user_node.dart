import 'package:cached_network_image/cached_network_image.dart';
import 'package:egnimos/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:super_editor/super_editor.dart';

import '../../../models/blog.dart';
import '../../../theme/color_theme.dart';
import '../../blog_page.dart';

const userNodeAttribution = NamedAttribution("user_node");

class UserNode extends TextNode {
  UserNode({
    required String id,
    required AttributedText text,
    required User userInfo,
    required DateTime blogUpdatedAt,
    required Blog blogInfo,
    Map<String, dynamic>? metadata,
  })  : _userInfo = userInfo,
        _blogUpdatedAt = blogUpdatedAt,
        _blogInfo = blogInfo,
        super(id: id, text: text, metadata: metadata) {
    putMetadataValue("blockType", userNodeAttribution);
  }

  User get userInfo => _userInfo;
  Blog get blogInfo => _blogInfo;
  DateTime get blogUpdatedAt => _blogUpdatedAt;
  final User _userInfo;
  final Blog _blogInfo;
  final DateTime _blogUpdatedAt;

  //has equivalent content
  @override
  bool hasEquivalentContent(DocumentNode other) {
    return other is UserNode &&
        userInfo == other.userInfo &&
        text == other.text &&
        blogUpdatedAt == other.blogUpdatedAt &&
        blogInfo == other.blogInfo;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is UserNode &&
          runtimeType == other.runtimeType &&
          _userInfo == other.userInfo &&
          _blogUpdatedAt == other.blogUpdatedAt &&
          _blogInfo == other.blogInfo;

  @override
  int get hashCode =>
      super.hashCode ^
      _userInfo.hashCode ^
      _blogUpdatedAt.hashCode ^
      _blogInfo.hashCode;
}

/// Builds [UserNodeViewModel]s and
/// [UserComponent]s for every
/// [UserNode] in a document.
class UserComponentBuilder implements ComponentBuilder {
  UserComponentBuilder(this._editor);
  final DocumentEditor _editor;

  @override
  UserComponentViewModel? createViewModel(
      Document document, DocumentNode node) {
    if (node is! UserNode) {
      return null;
    }

    return UserComponentViewModel(
      nodeId: node.id,
      padding: EdgeInsets.zero,
      userInfo: node.userInfo,
      blogInfo: node.blogInfo,
      blogUpdatedAt: node.blogUpdatedAt,
      text: node.text,
      textStyleBuilder: noStyleBuilder,
      selectionColor: const Color(0x00000000),
    );
  }

  @override
  Widget? createComponent(SingleColumnDocumentComponentContext componentContext,
      SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! UserComponentViewModel) {
      return null;
    }

    return UserComponent(
      textKey: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

/// View model that configures the appearance of a [CheckboxComponent].
/// View models move through various style phases, which fill out
/// various properties in the view model. For example, one phase applies
/// all [StyleRule]s, and another phase configures content selection
/// and caret appearance.
class UserComponentViewModel extends SingleColumnLayoutComponentViewModel
    with TextComponentViewModel {
  UserComponentViewModel({
    required String nodeId,
    double? maxWidth,
    required this.blogInfo,
    required this.blogUpdatedAt,
    required this.userInfo,
    required EdgeInsetsGeometry padding,
    required this.text,
    required this.textStyleBuilder,
    this.textDirection = TextDirection.ltr,
    this.textAlignment = TextAlign.left,
    this.selection,
    required this.selectionColor,
    this.highlightWhenEmpty = false,
  }) : super(
          nodeId: nodeId,
          padding: padding,
          maxWidth: maxWidth,
        );

  User userInfo;
  DateTime blogUpdatedAt;
  Blog blogInfo;
  AttributedText text;

  @override
  bool highlightWhenEmpty;

  @override
  TextSelection? selection;

  @override
  Color selectionColor;

  @override
  TextAlign textAlignment;

  @override
  TextDirection textDirection;

  @override
  AttributionStyleBuilder textStyleBuilder;

  @override
  UserComponentViewModel copy() {
    return UserComponentViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
      userInfo: userInfo,
      blogUpdatedAt: blogUpdatedAt,
      blogInfo: blogInfo,
      text: text,
      textStyleBuilder: textStyleBuilder,
      textDirection: textDirection,
      selection: selection,
      selectionColor: selectionColor,
      highlightWhenEmpty: highlightWhenEmpty,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is UserComponentViewModel &&
          runtimeType == other.runtimeType &&
          userInfo == other.userInfo &&
          blogUpdatedAt == other.blogUpdatedAt &&
          blogInfo == other.blogInfo &&
          text == other.text &&
          textStyleBuilder == other.textStyleBuilder &&
          textDirection == other.textDirection &&
          textAlignment == other.textAlignment &&
          selection == other.selection &&
          selectionColor == other.selectionColor &&
          highlightWhenEmpty == other.highlightWhenEmpty;

  @override
  int get hashCode =>
      super.hashCode ^
      blogUpdatedAt.hashCode ^
      text.hashCode ^
      blogInfo.hashCode ^
      userInfo.hashCode ^
      textStyleBuilder.hashCode ^
      textDirection.hashCode ^
      textAlignment.hashCode ^
      selection.hashCode ^
      selectionColor.hashCode ^
      highlightWhenEmpty.hashCode;
}

//widget
class UserComponent extends StatelessWidget {
  const UserComponent({
    Key? key,
    required this.textKey,
    required this.viewModel,
    this.showDebugPaint = false,
  }) : super(key: key);

  final GlobalKey textKey;
  final UserComponentViewModel viewModel;
  final bool showDebugPaint;

  @override
  Widget build(BuildContext context) {
    final dateTime =
        intl.DateFormat('EEE, MMM d, yyyy').format(viewModel.blogUpdatedAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //category info
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CategoriesBlogPage(
                  categoryInfo: viewModel.blogInfo.category);
            }));
          },
          child: IntrinsicWidth(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.4,
                  color: ColorTheme.bgColor14,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Text(
                viewModel.blogInfo.category.label,
                style: GoogleFonts.rubik(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: ColorTheme.bgColor10,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 20.0,
        ),

        //user info
        Row(
          children: [
            //cat image
            Container(
              constraints: BoxConstraints.tight(
                const Size.square(80.0),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    viewModel.userInfo.image?.generatedUri.isEmpty ?? true
                        ? "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_960_720.png"
                        : viewModel.userInfo.image!.generatedUri,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(
              width: 10.0,
            ),

            //cat name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //user name
                TextComponent(
                  text: viewModel.text,
                  textStyleBuilder: viewModel.textStyleBuilder,
                  textSelection: viewModel.selection,
                  selectionColor: viewModel.selectionColor,
                  highlightWhenEmpty: viewModel.highlightWhenEmpty,
                  showDebugPaint: showDebugPaint,
                ),

                const SizedBox(
                  height: 5.0,
                ),

                //date of published
                TextComponent(
                  text: AttributedText(
                    text: dateTime,
                  ),
                  textStyleBuilder: (attributions) {
                    return GoogleFonts.openSans(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    );
                  },
                  textSelection: viewModel.selection,
                  selectionColor: viewModel.selectionColor,
                  highlightWhenEmpty: viewModel.highlightWhenEmpty,
                  showDebugPaint: showDebugPaint,
                ),

                const SizedBox(
                  height: 5.0,
                ),

                TextComponent(
                  text: AttributedText(
                    text:
                        "Reading time ${viewModel.blogInfo.readingTime.roundToDouble()} min",
                  ),
                  textStyleBuilder: (attributions) {
                    return GoogleFonts.openSans(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    );
                  },
                  textSelection: viewModel.selection,
                  selectionColor: viewModel.selectionColor,
                  highlightWhenEmpty: viewModel.highlightWhenEmpty,
                  showDebugPaint: showDebugPaint,
                ),
                const SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ],
        ),

        //share link

        //date of published
      ],
    );
  }
}
