import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/command_handler.dart';
import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/commands.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_attribution/font_decoration_attribution.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

class ExecuteCommand {
  ///Editor to check and add the attribution to the given text
  final DocumentEditor editor;
  final ValueNotifier<Offset?> anchor;
  final BuildContext context;

  //optional
  final DocumentComposer composer;

  //listens the nodes added to the mutable doc
  final MutableDocument mutableDoc;

  //get the overlay entry
  // final OverlayEntry optionOverlayEntry;
  final VoidCallback updateToolbarOffset;
  final VoidCallback restoreFocus;

  ExecuteCommand({
    required this.restoreFocus,
    required this.updateToolbarOffset,
    required this.anchor,
    required this.context,
    // required this.optionOverlayEntry,
    required this.composer,
    required this.editor,
    required this.mutableDoc,
  });

  CommandHandler getInstance() {
    return CommandHandler(
      restoreFocus: restoreFocus,
      updateToolbarOffset: updateToolbarOffset,
      anchor: anchor,
      context: context,
      composer: composer,
      editor: editor,
      mutableDoc: mutableDoc,
    );
  }

  //start the command
  void startCommandBasedActions() {
    final cmd = getInstance();
    //highlight with style
    cmd.setHighlighterWithStyle();
    //highlight tags
    tagHighlighter();
  }

  void tagHighlighter() {
    //get the caret position
    final nodeId = composer.selection!.extent.nodeId;
    //get the node on which the text is writter
    final node = mutableDoc.getNodeById(nodeId);
    //check if the given node is textnode
    if (node is! TextNode) {
      return;
    }

    final text = node.text.text;
    //get the regex
    final rex = RegExp(r'\B(\#[a-zA-Z]+\b)(?!;)');
    //check for the start character (#)
    if (rex.hasMatch(text)) {
      //check if there is more than one match
      final matches = rex.allMatches(text);
      final startIndex = matches.last.start;
      final endIndex = matches.last.end;
      //print("VALUE ==> ${matches.last.input.substring(startIndex, endIndex)}");
      //print("START INDEX ==> $startIndex");
      //print("END INDEX ==> $endIndex");
      if (node.text.text.characters.last == " ") {
        //print("you have given the space #######HELLO");
        applyAttributionOfTheGivenSpanRange(
          FontColorDecorationAttribution(fontColor: Colors.red),
          node.text,
          startOffset: startIndex,
          endOffset: endIndex,
        );
      }
    }
  }

  void removeAttributionOfTheGivenSpanRange(
    Attribution attribution,
    AttributedText text, {
    required int startOffset,
    required int endOffset,
  }) {
    final span = SpanRange(
      start: startOffset,
      end: endOffset - 1,
    );
    final attributions = text.getAllAttributionsThroughout(span);

    for (var attr in attributions) {
      if (attr.id == attribution.id) {
        text.removeAttribution(
          attr,
          span,
        );
      }
    }
  }

  //apply the attribution spans to the selections
  void applyAttributionOfTheGivenSpanRange(
    Attribution attribution,
    AttributedText text, {
    required int startOffset,
    required int endOffset,
  }) {
    final span = SpanRange(
      start: startOffset,
      end: endOffset - 1,
    );
    final hasAttribution = text
        .hasAttributionsThroughout(attributions: {attribution}, range: span);
    if (!hasAttribution) {
      text.addAttribution(
        attribution,
        span,
      );
    }
  }
}
