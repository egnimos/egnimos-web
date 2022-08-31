import 'package:super_editor/super_editor.dart';

import '../custom_document_nodes/html_node.dart';

class ConvertCommandToHtmlNode implements EditorCommand {
  ConvertCommandToHtmlNode({
    required this.nodeId,
    required this.doc,
  });

  final String nodeId;
  final String doc;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final paragraphNode = node as ParagraphNode;

    final newHtmlNode = HtmlNode(
      id: paragraphNode.id,
      html: doc,
      metadata: {
        'blockType': htmlNodeAttribution,
      },
    );
    transaction.replaceNode(
      oldNode: paragraphNode,
      newNode: newHtmlNode,
    );
  }
}
