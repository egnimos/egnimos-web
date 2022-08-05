import 'package:super_editor/super_editor.dart';

import 'shift_to_newline.dart';

class ConvertCommandToHeaderNode implements EditorCommand {
  ConvertCommandToHeaderNode({
    required this.namedAttribution,
    required this.nodeId,
  });
  final String nodeId;
  final NamedAttribution namedAttribution;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final textNode = node as TextNode;

    transaction.replaceNode(
      oldNode: textNode,
      newNode: ParagraphNode(
        id: node.id,
        text: AttributedText(text: namedAttribution.id),
        metadata: {
          'blockType': namedAttribution,
        },
      ),
    );

  }
}
