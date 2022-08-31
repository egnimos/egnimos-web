import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:super_editor/super_editor.dart';

const htmlNodeAttribution = NamedAttribution("html_node");

class HtmlNode extends BlockNode with ChangeNotifier {
  HtmlNode({
    required this.id,
    required String html,
    Map<String, dynamic>? metadata,
  }) : _html = html {
    this.metadata = metadata;
    putMetadataValue("blockType", htmlNodeAttribution);
  }

  final String _html;
  String get html => _html;

  //has equivalent content
  @override
  bool hasEquivalentContent(DocumentNode other) {
    return other is HtmlNode && html == other.html;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is HtmlNode &&
          runtimeType == other.runtimeType &&
          _html == other.html;

  @override
  // ignore: unnecessary_overrides
  int get hashCode => id.hashCode ^ _html.hashCode;

  @override
  String? copyContent(NodeSelection selection) {
    if (selection is! UpstreamDownstreamNodeSelection) {
      throw Exception(
          'HtmlNode can only copy content from a UpstreamDownstreamNodeSelection.');
    }

    return !selection.isCollapsed ? _html : null;
  }

  @override
  final String id;
}

/// Builds [HtmlNodeViewModel]s and
/// [HtmlComponent]s for every
/// [HtmlNode] in a document.
class HtmlComponentBuilder implements ComponentBuilder {
  HtmlComponentBuilder(this._editor);
  final DocumentEditor _editor;

  @override
  HtmlNodeViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! HtmlNode) {
      return null;
    }

    return HtmlNodeViewModel(
      nodeId: node.id,
      padding: EdgeInsets.zero,
      html: node.html,
      selectionColor: const Color(0x00000000),
    );
  }

  @override
  Widget? createComponent(SingleColumnDocumentComponentContext componentContext,
      SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! HtmlNodeViewModel) {
      return null;
    }

    return HtmlComponent(
      componentKey: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

/// View model that configures the appearance of a [CheckboxComponent].
/// View models move through various style phases, which fill out
/// various properties in the view model. For example, one phase applies
/// all [StyleRule]s, and another phase configures content selection
/// and caret appearance.
class HtmlNodeViewModel extends SingleColumnLayoutComponentViewModel {
  HtmlNodeViewModel({
    required String nodeId,
    double? maxWidth,
    required EdgeInsetsGeometry padding,
    required this.html,
    this.selection,
    required this.selectionColor,
  }) : super(
          nodeId: nodeId,
          padding: padding,
          maxWidth: maxWidth,
        );

  String html;
  UpstreamDownstreamNodeSelection? selection;
  Color selectionColor;

  @override
  HtmlNodeViewModel copy() {
    return HtmlNodeViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
      html: html,
      selection: selection,
      selectionColor: selectionColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is HtmlNodeViewModel &&
          runtimeType == other.runtimeType &&
          nodeId == other.nodeId &&
          html == other.html &&
          selection == other.selection &&
          selectionColor == other.selectionColor;

  @override
  int get hashCode =>
      super.hashCode ^
      nodeId.hashCode ^
      html.hashCode ^
      selection.hashCode ^
      selectionColor.hashCode;
}

class HtmlComponent extends StatelessWidget {
  final GlobalKey componentKey;
  final HtmlNodeViewModel viewModel;
  final bool showDebugPaint;
  const HtmlComponent({
    Key? key,
    required this.componentKey,
    required this.viewModel,
    this.showDebugPaint = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final html = HtmlWidget(
      viewModel.html,
      // ignore: deprecated_member_use
      webView: true,
      // ignore: deprecated_member_use
      webViewJs: true,
      // ignore: deprecated_member_use
      webViewMediaPlaybackAlwaysAllow: true,
      isSelectable: true,
    );
    return Center(
      child: SelectableBox(
        selection: viewModel.selection,
        selectionColor: viewModel.selectionColor,
        child: BoxComponent(
          key: componentKey,
          child: html,
        ),
      ),
    );
  }
}
