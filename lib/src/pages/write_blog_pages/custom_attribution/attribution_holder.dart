import 'dart:math';
import 'dart:ui';

import 'package:super_editor/super_editor.dart';

class AttributedTextDecorationHolder<T> {
  final String nodeId;
  final T attributedType;
  final int startOffset;
  final int endOffset;

  AttributedTextDecorationHolder({
    required this.nodeId,
    required this.attributedType,
    required this.endOffset,
    required this.startOffset,
  });

  Map<String, dynamic> toJson() => {
        "node_id": nodeId,
        "attribution": (attributedType as Attribution).id,
        "start_offset": startOffset,
        "end_offset": endOffset,
      };
}

enum DecorationFunctionType {
  toggle,
  add,
}

class AttributionHolder {
  static List<AttributedTextDecorationHolder<Attribution>> decorationsHolders =
      [];

  //update
  static void _updateDecorationList({
    required Attribution attributionDecoration,
    required SpanRange range,
    required String nodeId,
    required DecorationFunctionType funcType,
  }) {
    if (decorationsHolders.isEmpty) {
      decorationsHolders.add(
        AttributedTextDecorationHolder(
          nodeId: nodeId,
          attributedType: attributionDecoration,
          endOffset: range.end,
          startOffset: range.start,
        ),
      );
      return;
    }

    //if the decoration holder list is not empty
    //get the decorations of the given node id
    final decorations =
        decorationsHolders.where((hol) => hol.nodeId == nodeId).toList();
    //if there is no decorations of the given node id then add the decoration
    if (decorations.isEmpty) {
      decorationsHolders.add(
        AttributedTextDecorationHolder(
          nodeId: nodeId,
          attributedType: attributionDecoration,
          endOffset: range.end,
          startOffset: range.start,
        ),
      );
      return;
    }

    //get the decorations of the given attribution id
    final attributionDecorations = decorations
        .where((hol) => hol.attributedType.id == attributionDecoration.id)
        .toList();
    //if there is no decorations of the given attribution id then add the decoration
    if (attributionDecorations.isEmpty) {
      decorationsHolders.add(
        AttributedTextDecorationHolder(
          nodeId: nodeId,
          attributedType: attributionDecoration,
          endOffset: range.end,
          startOffset: range.start,
        ),
      );
      return;
    }

    for (var deco in decorations) {
      if (deco.attributedType.id == attributionDecoration.id) {
        //check for span range, if the span range is same then don't update it
        //if one of the spanRange is different then add the new span
        if (deco.endOffset != range.end || deco.startOffset != range.start) {
          decorationsHolders.add(
            AttributedTextDecorationHolder(
              nodeId: nodeId,
              attributedType: attributionDecoration,
              endOffset: range.end,
              startOffset: range.start,
            ),
          );
          return;
        } else {
          decorationsHolders.removeWhere((element) =>
              element.nodeId == nodeId &&
              element.attributedType.id == attributionDecoration.id &&
              element.endOffset == range.end &&
              element.startOffset == range.start);
          if (funcType == DecorationFunctionType.add) {
            decorationsHolders.add(
              AttributedTextDecorationHolder(
                nodeId: nodeId,
                attributedType: attributionDecoration,
                endOffset: range.end,
                startOffset: range.start,
              ),
            );
          }
        }
      }
    }
  }

  static List<Map<String, dynamic>> toJsonList() {
    return decorationsHolders.map((e) => e.toJson()).toList();
  }

  static void saveDecorations({
    required DocumentComposer composer,
    required DocumentEditor editor,
    required Attribution attribution,
    required DecorationFunctionType funcType,
  }) {
    final selection = composer.selection!;
    final selectedNode = editor.document.getNodeById(selection.extent.nodeId);
    if (selectedNode is! TextNode) {
      return;
    }

    final extentOffset = (selection.extent.nodePosition as TextPosition).offset;
    final baseOffset = (selection.base.nodePosition as TextPosition).offset;
    final selectionStart = min(baseOffset, extentOffset);
    final selectionEnd = max(baseOffset, extentOffset);
    final spanRange = SpanRange(
      start: selectionStart,
      end: selectionEnd - 1,
    );

    _updateDecorationList(
      attributionDecoration: attribution,
      range: spanRange,
      nodeId: selectedNode.id,
      funcType: funcType,
    );
  }
}
