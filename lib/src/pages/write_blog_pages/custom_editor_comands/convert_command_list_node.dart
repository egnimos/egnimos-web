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
          text: AttributedText(),
          itemType: type,
          metadata: {
            'blockType': const NamedAttribution("listItem"),
          },
        ));
  }
}

///Convert the paragraph to list item node
class ConvertParagraphToListItemCustomCommand implements EditorCommand {
  ConvertParagraphToListItemCustomCommand({
    required this.nodeId,
    required this.type,
  });

  final String nodeId;
  final ListItemType type;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final paragraphNode = node as ParagraphNode;

    final newListItemNode = ListItemNode(
      id: paragraphNode.id,
      itemType: type,
      text: paragraphNode.text,
      metadata: {
        'blockType': const NamedAttribution("listItem"),
      },
    );
    transaction.replaceNode(oldNode: paragraphNode, newNode: newListItemNode);
  }
}

//Change the listitem type command
class ChangeListItemTypeCustomCommand implements EditorCommand {
  ChangeListItemTypeCustomCommand({
    required this.nodeId,
    required this.newType,
  });

  final String nodeId;
  final ListItemType newType;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final existingListItem = document.getNodeById(nodeId) as ListItemNode;

    final newListItemNode = ListItemNode(
      id: existingListItem.id,
      itemType: newType,
      text: existingListItem.text,
      metadata: {
        'blockType': const NamedAttribution("listItem"),
      },
    );
    transaction.replaceNode(
        oldNode: existingListItem, newNode: newListItemNode);
  }
}

// type == ListItemType.unordered
//           ? ListItemNode.unordered(
//               id: textNode.id,
//               text: AttributedText(),
//               metadata: {
//         'blockType': const NamedAttribution("listItem"),
//       },
//             )
//           : ListItemNode.ordered(
//               id: textNode.id,
//               text: AttributedText(),
//             ),
