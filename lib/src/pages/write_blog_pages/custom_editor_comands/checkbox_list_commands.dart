import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/checkbox_node.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_editor_comands/shift_to_newline.dart';
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';

//Indent Checkbox node command
class IndentCheckboxNodeCommand implements EditorCommand {
  IndentCheckboxNodeCommand({
    required this.nodeId,
  });

  final String nodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final checkbox = node as CheckboxNode;

    //if the indentation is greater than 6 then indentation is not possible
    if (checkbox.indent >= 6) {
      return;
    }

    checkbox.indent += 1;
  }
}

//UnIndent Checkbox node command
class UnIndentCheckboxNodeCommand implements EditorCommand {
  UnIndentCheckboxNodeCommand({
    required this.nodeId,
  });

  final String nodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final checkbox = node as CheckboxNode;
    if (checkbox.indent > 0) {
      checkbox.indent -= 1;
    } else {
      ConvertCheckboxToParagraphCommand(
        nodeId: nodeId,
      ).execute(document, transaction);
    }
  }
}

//convert the checkbox node to paragraph
class ConvertCheckboxToParagraphCommand implements EditorCommand {
  ConvertCheckboxToParagraphCommand({
    required this.nodeId,
    this.paragraphMetadata,
  });

  final String nodeId;
  final Map<String, dynamic>? paragraphMetadata;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final checkbox = node as CheckboxNode;

    final newParagraphNode = ParagraphNode(
      id: checkbox.id,
      text: checkbox.text,
      metadata: paragraphMetadata ?? {},
    );
    transaction.replaceNode(
      oldNode: checkbox,
      newNode: newParagraphNode,
    );
  }
}

//convert the paragraph node to checkbox
class ConvertParagraphToCheckboxCommand implements EditorCommand {
  ConvertParagraphToCheckboxCommand({
    required this.nodeId,
  });

  final String nodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final paragraphNode = node as ParagraphNode;

    final newListItemNode = CheckboxNode(
      id: paragraphNode.id,
      text: paragraphNode.text,
      isComplete: false,
    );
    transaction.replaceNode(
      oldNode: paragraphNode,
      newNode: newListItemNode,
    );
  }
}

//split the checkbox command
class SplitCheckboxCommand implements EditorCommand {
  SplitCheckboxCommand({
    required this.nodeId,
    required this.splitPosition,
    required this.newNodeId,
  });

  final String nodeId;
  final TextPosition splitPosition;
  final String newNodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    //get the existing node
    final node = document.getNodeById(nodeId);
    final checkboxNode = node as CheckboxNode;
    final text = checkboxNode.text;
    //get the starting text from range (0, splitPosition)
    final startText = text.copyText(0, splitPosition.offset);
    //get the ending text from starting splitPosition offset
    final endText = splitPosition.offset < text.text.length
        ? text.copyText(splitPosition.offset)
        : AttributedText();
    //update the existing node with the starting text
    checkboxNode.text = startText;
    //create the new node with the ending text
    final newNode = CheckboxNode(
      id: newNodeId,
      text: endText,
      isComplete: false,
    );

    //insert the new node to after the existing node
    transaction.insertNodeAfter(
      existingNode: checkboxNode,
      newNode: newNode,
    );
  }
}

///*****KEY EVENTS*****/
///
///INDENT CHECKBOX
ExecutionInstruction tabToIndentCheckboxItem({
  required EditContext editContext,
  required RawKeyEvent keyEvent,
}) {
  if (keyEvent.logicalKey != LogicalKeyboardKey.tab) {
    return ExecutionInstruction.continueExecution;
  }
  if (keyEvent.isShiftPressed) {
    return ExecutionInstruction.continueExecution;
  }

  final wasIndented = indentCheckboxItem(
    editor: editContext.editor,
    composer: editContext.composer,
  );

  return wasIndented
      ? ExecutionInstruction.haltExecution
      : ExecutionInstruction.continueExecution;
}

///UNINDENT CHECKBOX
ExecutionInstruction shiftTabToUnIndentCheckbox({
  required EditContext editContext,
  required RawKeyEvent keyEvent,
}) {
  if (keyEvent.logicalKey != LogicalKeyboardKey.tab) {
    return ExecutionInstruction.continueExecution;
  }
  if (!keyEvent.isShiftPressed) {
    return ExecutionInstruction.continueExecution;
  }

  final wasIndented = unindentCheckboxItem(
    editor: editContext.editor,
    composer: editContext.composer,
  );

  return wasIndented
      ? ExecutionInstruction.haltExecution
      : ExecutionInstruction.continueExecution;
}

//BACKSPACE To UnIndent Checkbox
ExecutionInstruction backspaceToUnIndentCheckboxItem({
  required EditContext editContext,
  required RawKeyEvent keyEvent,
}) {
  if (keyEvent.logicalKey != LogicalKeyboardKey.backspace) {
    return ExecutionInstruction.continueExecution;
  }

  if (editContext.composer.selection == null) {
    return ExecutionInstruction.continueExecution;
  }
  if (!editContext.composer.selection!.isCollapsed) {
    return ExecutionInstruction.continueExecution;
  }

  final node = editContext.editor.document
      .getNodeById(editContext.composer.selection!.extent.nodeId);
  if (node is! CheckboxNode) {
    return ExecutionInstruction.continueExecution;
  }
  if ((editContext.composer.selection!.extent.nodePosition as TextPosition)
          .offset >
      0) {
    return ExecutionInstruction.continueExecution;
  }

  final wasIndented = unindentCheckboxItem(
    editor: editContext.editor,
    composer: editContext.composer,
  );

  return wasIndented
      ? ExecutionInstruction.haltExecution
      : ExecutionInstruction.continueExecution;
}

ExecutionInstruction splitCheckboxItemWhenEnterPressed({
  required EditContext editContext,
  required RawKeyEvent keyEvent,
}) {
  if (keyEvent.logicalKey != LogicalKeyboardKey.enter) {
    return ExecutionInstruction.continueExecution;
  }

  final node = editContext.editor.document
      .getNodeById(editContext.composer.selection!.extent.nodeId);
  if (node is! CheckboxNode) {
    return ExecutionInstruction.continueExecution;
  }

  final didSplitCheckboxItem = insertBlockLevelNewline(
    editor: editContext.editor,
    composer: editContext.composer,
  );
  return didSplitCheckboxItem
      ? ExecutionInstruction.haltExecution
      : ExecutionInstruction.continueExecution;
}

ExecutionInstruction enterToInsertBlockNewlineForCheckbox({
  required EditContext editContext,
  required RawKeyEvent keyEvent,
}) {
  if (keyEvent.logicalKey != LogicalKeyboardKey.enter &&
      keyEvent.logicalKey != LogicalKeyboardKey.numpadEnter) {
    return ExecutionInstruction.continueExecution;
  }

  final didInsertBlockNewline = insertBlockLevelNewline(
    editor: editContext.editor,
    composer: editContext.composer,
  );

  return didInsertBlockNewline
      ? ExecutionInstruction.haltExecution
      : ExecutionInstruction.continueExecution;
}

/// Inserts a new [ParagraphNode], or splits an existing node into two.
///
/// If the [DocumentComposer] selection is collapsed, and the extent is
/// at the end of a node, such as the end of a paragraph, then a new
/// [ParagraphNode] is added after the current node and the selection
/// extent is moved to the new [ParagraphNode].
///
/// If the [DocumentComposer] selection is collapsed, and the extent is
/// in the middle of a node, such as in the middle of a paragraph, list
/// item, or blockquote, then the current node is split into two nodes
/// of the same type at that position.
///
/// If the current selection is not collapsed then the current selection
/// is first deleted, then the aforementioned operation takes place.
///
/// Returns [true] if a new node was inserted or a node was split into two.
/// Returns [false] if there was no selection.
bool insertBlockLevelNewline({
  required DocumentComposer composer,
  required DocumentEditor editor,
}) {
  if (composer.selection == null) {
    return false;
  }

  // Ensure that the entire selection sits within the same node.
  final baseNode =
      editor.document.getNodeById(composer.selection!.base.nodeId)!;
  final extentNode =
      editor.document.getNodeById(composer.selection!.extent.nodeId)!;
  if (baseNode.id != extentNode.id) {
    return false;
  }

  if (!composer.selection!.isCollapsed) {
    // The selection is not collapsed. Delete the selected content first,
    // then continue the process.
    final newSelectionPosition =
        CommonEditorOperations.getDocumentPositionAfterExpandedDeletion(
      document: editor.document,
      selection: composer.selection!,
    );

    // Delete the selected content.
    editor.executeCommand(
      DeleteSelectionCommand(documentSelection: composer.selection!),
    );

    composer.selection =
        DocumentSelection.collapsed(position: newSelectionPosition);
  }

  final newNodeId = DocumentEditor.createNodeId();

  if (extentNode is CheckboxNode) {
    if (extentNode.text.text.isEmpty) {
      // The checkbox item is empty. Convert it to a paragraph.
      return docOps!.convertToParagraph();
    }

    // Split the checkbox item into two.
    editor.executeCommand(
      SplitCheckboxCommand(
        nodeId: extentNode.id,
        splitPosition:
            composer.selection!.extent.nodePosition as TextNodePosition,
        newNodeId: newNodeId,
      ),
    );
  }
  // else if (extentNode is ParagraphNode) {
  //   // Split the paragraph into two. This includes headers, blockquotes, and
  //   // any other block-level paragraph.
  //   final currentExtentPosition =
  //       composer.selection!.extent.nodePosition as TextNodePosition;
  //   final endOfParagraph = extentNode.endPosition;

  //   editor.executeCommand(
  //     SplitParagraphCommand(
  //       nodeId: extentNode.id,
  //       splitPosition: currentExtentPosition,
  //       newNodeId: newNodeId,
  //       replicateExistingMetadata:
  //           currentExtentPosition.offset != endOfParagraph.offset,
  //     ),
  //   );
  // } else if (composer.selection!.extent.nodePosition
  //     is UpstreamDownstreamNodePosition) {
  //   final extentPosition = composer.selection!.extent.nodePosition
  //       as UpstreamDownstreamNodePosition;
  //   if (extentPosition.affinity == TextAffinity.downstream) {
  //     // The caret sits on the downstream edge of block-level content. Insert
  //     // a new paragraph after this node.
  //     editor.executeCommand(EditorCommandFunction((doc, transaction) {
  //       transaction.insertNodeAfter(
  //         existingNode: extentNode,
  //         newNode: ParagraphNode(
  //           id: newNodeId,
  //           text: AttributedText(text: ''),
  //         ),
  //       );
  //     }));
  //   } else {
  //     // The caret sits on the upstream edge of block-level content. Insert
  //     // a new paragraph before this node.
  //     editor.executeCommand(EditorCommandFunction((doc, transaction) {
  //       transaction.insertNodeBefore(
  //         existingNode: extentNode,
  //         newNode: ParagraphNode(
  //           id: newNodeId,
  //           text: AttributedText(text: ''),
  //         ),
  //       );
  //     }));
  //   }
  // }
  else {
    // We don't know how to handle this type of node position. Do nothing.
    return false;
  }

  // Place the caret at the beginning of the new node.
  composer.selection = DocumentSelection.collapsed(
    position: DocumentPosition(
      nodeId: newNodeId,
      nodePosition: const TextNodePosition(offset: 0),
    ),
  );

  return true;
}

/// Indents the checkbox item at the current selection extent, if the entire
/// selection sits within a [CheckboxNode].
///
/// Returns [true] if a checkbox item was indented. Returns [false] if
/// the selection extent did not sit in a checkbox item, or if the selection
/// included more than just a checkbox item.
bool indentCheckboxItem(
    {required DocumentComposer composer, required DocumentEditor editor}) {
  if (composer.selection == null) {
    return false;
  }

  final baseNode = editor.document.getNodeById(composer.selection!.base.nodeId);
  final extentNode =
      editor.document.getNodeById(composer.selection!.extent.nodeId);
  if (baseNode is! CheckboxNode || extentNode is! CheckboxNode) {
    return false;
  }

  editor.executeCommand(
    IndentCheckboxNodeCommand(nodeId: extentNode.id),
  );

  return true;
}

/// Indents the checkbox item at the current selection extent, if the entire
/// selection sits within a [CheckboxNode].
///
/// If the Checkbox item is not indented, the Checkbox item is converted to
/// a [ParagraphNode].
///
/// Returns [true] if a Checkbox item was un-indented. Returns [false] if
/// the selection extent did not sit in a Checkbox item, or if the selection
/// included more than just a Checkbox item.
bool unindentCheckboxItem(
    {required DocumentComposer composer, required DocumentEditor editor}) {
  if (composer.selection == null) {
    return false;
  }

  final baseNode = editor.document.getNodeById(composer.selection!.base.nodeId);
  final extentNode =
      editor.document.getNodeById(composer.selection!.extent.nodeId);
  if (baseNode!.id != extentNode!.id) {
    return false;
  }

  if (baseNode is! CheckboxNode) {
    return false;
  }

  editor.executeCommand(
    UnIndentCheckboxNodeCommand(nodeId: extentNode.id),
  );

  return true;
}
