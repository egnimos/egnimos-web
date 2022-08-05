import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/command_handler.dart';
import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/commands.dart';
import 'package:flutter/cupertino.dart';
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
  void startCommand() {
    final cmd = getInstance();
    //highlight with style
    cmd.setHighlighterWithStyle();
  }
}
