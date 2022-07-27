import 'dart:collection';
import 'dart:math';

import 'package:egnimos/src/pages/write_blog_pages/custom_attribution/font_size_attribution.dart';
import 'package:flutter/cupertino.dart';
import 'package:super_editor/super_editor.dart';

double getFontSizeInfoOfSelectedNode(
    DocumentComposer composer, DocumentEditor editor) {
  final selection = composer.selection!;
  final selectedNode = editor.document.getNodeById(selection.extent.nodeId);
  if (selectedNode is! TextNode) {
    return 18.0;
  }

  final extentOffset = (selection.extent.nodePosition as TextPosition).offset;
  final baseOffset = (selection.base.nodePosition as TextPosition).offset;
  final selectionStart = min(baseOffset, extentOffset);
  final selectionEnd = max(baseOffset, extentOffset);

  final attributions = selectedNode.text.getAllAttributionsThroughout(
    SpanRange(
      start: selectionStart,
      end: selectionEnd-1,
    ),
  );
  for (var attribution in attributions) {
    print("SELECTED ATTRIBUTIONS ID " + attribution.id);
    if (attribution is FontSizeAttribution) {
      print("FONT SIZE ATTRIBUTION :: " + attribution.fontSize.toString());
      return attribution.fontSize.toDouble();
    }
  }

  final type = selectedNode.metadata['blockType'] as NamedAttribution;
  if (type == header1Attribution) {
    return 60.0;
  }
  if (type == header2Attribution) {
    return 50.0;
  }
  if (type == header3Attribution) {
    return 40.0;
  }
  if (type == header4Attribution) {
    return 35.0;
  }
  if (type == header5Attribution) {
    return 26.0;
  }
  if (type == header6Attribution) {
    return 18.0;
  } else {
    return 18.0;
  }
}

/// Applies the given `attributions` to the given `documentSelection`,
/// if none of the content in the selection contains any of the
/// given `attributions`. Otherwise, all the given `attributions`
/// are removed from the content within the `documentSelection`.
// class AddTextAttributionsCommand implements EditorCommand {
//   AddTextAttributionsCommand({
//     required this.documentSelection,
//     required this.attributions,
//   });

//   final DocumentSelection documentSelection;
//   final Set<Attribution> attributions;

//   @override
//   void execute(Document document, DocumentEditorTransaction transaction) {
//     editorDocLog.info('Executing ToggleTextAttributionsCommand');
//     final nodes = document.getNodesInside(
//         documentSelection.base, documentSelection.extent);
//     if (nodes.isEmpty) {
//       editorDocLog.shout(
//           ' - Bad DocumentSelection. Could not get range of nodes. Selection: $documentSelection');
//       return;
//     }

//     // Calculate a DocumentRange so we know which DocumentPosition
//     // belongs to the first node, and which belongs to the last node.
//     final nodeRange = document.getRangeBetween(
//         documentSelection.base, documentSelection.extent);
//     editorDocLog.info(' - node range: $nodeRange');

//     // ignore: prefer_collection_literals
//     final nodesAndSelections = LinkedHashMap<TextNode, SpanRange>();
//     bool alreadyHasAttributions = false;

//     for (final textNode in nodes) {
//       if (textNode is! TextNode) {
//         continue;
//       }

//       int startOffset = -1;
//       int endOffset = -1;

//       if (textNode == nodes.first && textNode == nodes.last) {
//         // Handle selection within a single node
//         editorDocLog
//             .info(' - the selection is within a single node: ${textNode.id}');
//         final baseOffset =
//             (documentSelection.base.nodePosition as TextPosition).offset;
//         final extentOffset =
//             (documentSelection.extent.nodePosition as TextPosition).offset;
//         startOffset = baseOffset < extentOffset ? baseOffset : extentOffset;
//         endOffset = baseOffset < extentOffset ? extentOffset : baseOffset;

//         // -1 because TextPosition's offset indexes the character after the
//         // selection, not the final character in the selection.
//         endOffset -= 1;
//       } else if (textNode == nodes.first) {
//         // Handle partial node selection in first node.
//         editorDocLog
//             .info(' - selecting part of the first node: ${textNode.id}');
//         startOffset = (nodeRange.start.nodePosition as TextPosition).offset;
//         endOffset = max(textNode.text.text.length - 1, 0);
//       } else if (textNode == nodes.last) {
//         // Handle partial node selection in last node.
//         editorDocLog.info(' - toggling part of the last node: ${textNode.id}');
//         startOffset = 0;

//         // -1 because TextPosition's offset indexes the character after the
//         // selection, not the final character in the selection.
//         endOffset = (nodeRange.end.nodePosition as TextPosition).offset - 1;
//       } else {
//         // Handle full node selection.
//         editorDocLog.info(' - toggling full node: ${textNode.id}');
//         startOffset = 0;
//         endOffset = max(textNode.text.text.length - 1, 0);
//       }

//       final selectionRange = SpanRange(start: startOffset, end: endOffset);

//       alreadyHasAttributions = alreadyHasAttributions ||
//           textNode.text.hasAttributionsWithin(
//             attributions: attributions,
//             range: selectionRange,
//           );

//       nodesAndSelections.putIfAbsent(textNode, () => selectionRange);
//     }

//     // Toggle attributions.
//     for (final entry in nodesAndSelections.entries) {
//       for (Attribution attribution in attributions) {
//         final node = entry.key;
//         final range = entry.value;
//         editorDocLog
//             .info(' - toggling attribution: $attribution. Range: $range');
//         node.text.addAttribution(
//           attribution,
//           range,
//         );
//       }
//     }

//     editorDocLog.info(' - done toggling attributions');
//   }
// }
