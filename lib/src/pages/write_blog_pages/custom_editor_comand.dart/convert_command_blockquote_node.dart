import 'package:egnimos/src/pages/write_blog_pages/custom_editor_comand.dart/shift_to_newline.dart';
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
