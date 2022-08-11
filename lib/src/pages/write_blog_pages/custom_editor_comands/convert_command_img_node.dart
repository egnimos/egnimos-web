import 'package:super_editor/super_editor.dart';

import 'shift_to_newline.dart';

class ConvertCommandToIMGNode implements EditorCommand {
  ConvertCommandToIMGNode({
    required this.nodeId,
    required this.uri,
  });
  final String uri;

  final String nodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final textNode = node as TextNode;

    transaction.replaceNode(
      oldNode: textNode,
      newNode: ImageNode(
        id: textNode.id,
        imageUrl: uri.isNotEmpty
            ? uri
            : "https://miro.medium.com/max/1200/1*GLS12MFNCzofmNDt-i4Alw.gif",
      ),
    );

  }
}
