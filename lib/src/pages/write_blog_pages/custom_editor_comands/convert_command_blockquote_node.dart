import 'package:super_editor/super_editor.dart';

class ConvertCommandToBlockquoteNode implements EditorCommand {
  ConvertCommandToBlockquoteNode({
    required this.nodeId,
  });
  final String nodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final textNode = node as TextNode;

    transaction.replaceNode(
      oldNode: textNode,
      newNode: ParagraphNode(
        id: node.id,
        text: AttributedText(text: "add your quote"),
        metadata: {
          'blockType': blockquoteAttribution,
        },
      ),
    );

  }
}
