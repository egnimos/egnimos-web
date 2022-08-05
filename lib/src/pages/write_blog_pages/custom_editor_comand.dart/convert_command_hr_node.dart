import 'package:super_editor/super_editor.dart';

import 'shift_to_newline.dart';

class ConvertCommandToHRNode implements EditorCommand {
  ConvertCommandToHRNode({
    required this.nodeId,
  });

  final String nodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final textNode = node as TextNode;

    transaction.replaceNode(
      oldNode: textNode,
      newNode: HorizontalRuleNode(id: textNode.id),
    );

  }
}
