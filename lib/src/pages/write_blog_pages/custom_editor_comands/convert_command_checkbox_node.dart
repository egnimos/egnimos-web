import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/checkbox_node.dart';
import 'package:super_editor/super_editor.dart';

class ConvertCommandToCheckboxNode implements EditorCommand {
  ConvertCommandToCheckboxNode({
    required this.nodeId,
  });

  final String nodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final textNode = node as TextNode;

    transaction.replaceNode(
      oldNode: textNode,
      newNode: CheckboxNode(
        id: textNode.id,
        text: AttributedText(),
        isComplete: false,
      ),
    );
  }
}
