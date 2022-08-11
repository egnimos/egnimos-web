import 'package:super_editor/super_editor.dart';

class ConvertCommandToListItemNode implements EditorCommand {
  ConvertCommandToListItemNode({
    required this.nodeId,
    required this.type,
  });

  final String nodeId;
  final ListItemType type;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final textNode = node as TextNode;

    transaction.replaceNode(
      oldNode: textNode,
      newNode: ListItemNode(
        id: textNode.id,
        itemType: type,
        text: AttributedText(),
      ),
    );
  }
}
