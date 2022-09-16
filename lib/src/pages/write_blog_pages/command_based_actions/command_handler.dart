import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/command_suggestion_handler.dart';
import 'package:egnimos/src/pages/write_blog_pages/toolbar/option_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'command_constants.dart';
import 'commands.dart';

class CommandHandler {
  ///Editor to check and add the attribution to the given text
  final DocumentEditor editor;

  // //optional
  final DocumentComposer composer;

  //listens the nodes added to the mutable doc
  final MutableDocument mutableDoc;
  final ValueNotifier<Offset?> anchor;
  final BuildContext context;
  final VoidCallback updateToolbarOffset;
  final VoidCallback restoreFocus;

  CommandHandler({
    required this.restoreFocus,
    required this.updateToolbarOffset,
    required this.context,
    required this.anchor,
    required this.editor,
    required this.composer,
    required this.mutableDoc,
  });

  //check whether the enter command is valid or not
  bool checkValidity() {
    // //print(mutableDoc.nodes.last.metadata);
    final node = mutableDoc.getNodeById(mutableDoc.nodes.last.id);
    if (node is! TextNode) {
      return false;
    }

    ///get the attributed text
    ///casting the given node to a [TextNode]
    ///after checking if the given node is [TextNode]
    // ignore: unnecessary_cast
    final textNode = node as TextNode;

    //if the attributed text doesn't contains the command text return false
    if (!commands.contains(textNode.text.text)) {
      return false;
    }

    return true;
  }

  //give the command highlighter statement
  void setHighlighterWithStyle() {
    //print("not text node");
    final nodeId = composer.selection!.extent.nodeId;
    final node = mutableDoc.getNodeById(nodeId);
    if (node is! TextNode) {
      //print("not text node");
      return;
    }

    ///check if the text have @
    // ignore: unnecessary_cast
    OverlayActions.anchor = anchor;
    OverlayActions.restoreFocus = restoreFocus;
    final textNode = node;
    // final extentOffset = (textNode.endPosition).offset;
    // final baseOffset = (selection.base.nodePosition as TextPosition).offset;
    // final selectionStart = min(baseOffset, extentOffset);
    // final selectionEnd = max(baseOffset, extentOffset);
    //print(textNode.text.text);
    if (textNode.text.text.contains(startCommand[0])) {
      //print(
          // "commands..........................................................");
      //get the cmd text
      final cmdText = textNode.text.text;

      CommandSuggestionHandler(cmdText, showOverlay: (suggestions) {
        OverlayActions.hideEditorToolbar(restoreFocus);
        OverlayActions.showEditorToolbar(
          context,
          cmdText: cmdText,
          composer: composer,
          updateToolbarOffset: updateToolbarOffset,
          suggestions: suggestions,
          mutableDoc: mutableDoc,
          editor: editor,
          cmdNode: textNode,
        );
      }).startSuggestion();
      return;
    }

    // OverlayActions.hideEditorToolbar(restoreFocus);s
  }
}

class OverlayActions {
  static ValueNotifier<Offset?> anchor = ValueNotifier(null);
  static VoidCallback? restoreFocus;
  // final VoidCallback closeToolbar;
  static OverlayEntry? _optionFormatOverlayEntry;
  // final String suggestion;
  // static String? cmdText;

  //hide the editor toolbar
  static void hideEditorToolbar(Function() restoreFocus) {
    //nul out the selection anchor so that when it re-appears,
    //the bar doesn't moentarily "flash" at its old anchor position
    anchor.value = null;

    if (_optionFormatOverlayEntry != null) {
      //remove the toolbar oevrlay and null-out the entry
      //we null out the entry because we can't query whether
      //or not the entry exists in the overlay, so in our case
      //null implies the entry is not in the overlay, and non-null implies
      //the entry is in the overlay
      _optionFormatOverlayEntry?.remove();
      _optionFormatOverlayEntry = null;
    }

    //ensure that focus returns to the editor
    restoreFocus();
  }

  //display the editor
  static void showEditorToolbar(
    BuildContext context, {
    required VoidCallback updateToolbarOffset,
    required List<String> suggestions,
    required MutableDocument mutableDoc,
    required DocumentEditor editor,
    required DocumentComposer composer,
    String? cmdText,
    required TextNode cmdNode,
  }) {
    if (_optionFormatOverlayEntry == null) {
      _optionFormatOverlayEntry ??= OverlayEntry(builder: (context) {
        return OptionToolbar(
          editor: editor,
          anchor: anchor,
          composer: composer,
          runAfterExecution: () {
            final nodeId = cmdNode.id;
            final docNode =
                mutableDoc.nodes.firstWhere((node) => node.id == nodeId);
            composer.selection = DocumentSelection.collapsed(
              position: DocumentPosition(
                nodeId: nodeId,
                nodePosition: docNode.endPosition,
              ),
            );
            hideEditorToolbar(restoreFocus!);
            // docOps?.insertBlockLevelNewline();
          },
          closeToolbar: () {
            hideEditorToolbar(restoreFocus!);
          },
          mutableDoc: mutableDoc,
          cmdNode: cmdNode,
          displayHiglight: true,
          suggestion: suggestions,
        );
      });

      // Display the toolbar in the application overlay
      final overlay = Overlay.of(context);
      overlay!.insert(_optionFormatOverlayEntry!);

      // Schedule a callback after this frame to locate the selection
      // bounds on the screen and display the toolbar near the selected
      // text.
      () {
        if (_optionFormatOverlayEntry == null) return;
        updateToolbarOffset();
      }();
    }
  }
}
