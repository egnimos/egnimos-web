import 'package:cross_file/cross_file.dart';
import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/command_constants.dart';
import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/command_suggestion_constants.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_editor_comands/convert_command_img_node.dart';
import 'package:egnimos/src/services/picker_service.dart';
import 'package:egnimos/src/widgets/indicator_widget.dart';
import 'package:egnimos/src/widgets/nav.dart';
import 'package:egnimos/src/widgets/write_html_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_editor/super_editor.dart';
import '../custom_editor_comands/convert_command_blockquote_node.dart';
import '../custom_editor_comands/convert_command_checkbox_node.dart';
import '../custom_editor_comands/convert_command_header_node.dart';
import '../custom_editor_comands/convert_command_hr_node.dart';
import '../custom_editor_comands/convert_command_list_node.dart';
import '../custom_editor_comands/convert_command_to_html_node.dart';

class OptionToolbar extends StatefulWidget {
  final ValueNotifier<Offset?> anchor;
  final bool displayHiglight;
  final DocumentEditor editor;
  final MutableDocument mutableDoc;
  final TextNode cmdNode;
  final List<String> suggestion;
  final DocumentComposer composer;
  final Function() runAfterExecution;
  final Function() closeToolbar;

  const OptionToolbar({
    Key? key,
    required this.runAfterExecution,
    required this.mutableDoc,
    required this.cmdNode,
    required this.editor,
    required this.anchor,
    required this.suggestion,
    required this.displayHiglight,
    required this.composer,
    required this.closeToolbar,
  }) : super(key: key);

  @override
  State<OptionToolbar> createState() => _OptionToolbarState();
}

class _OptionToolbarState extends State<OptionToolbar> {
  @override
  void initState() {
    super.initState();
    executeCommand();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.anchor,
      builder: (context, offset, child) {
        if (widget.anchor.value == null) {
          // When no anchor position is available, or the user hasn't
          // selected any text, show nothing.
          return const SizedBox();
        }

        return SizedBox.expand(
          child: Stack(
            children: [
              // The hard-coded clamp values are based on empirical checks
              // with the marketing website. The clamping behavior should be
              // generalized to use this toolbar in an app.
              Positioned(
                left: widget.anchor.value!.dx
                    .clamp(165, MediaQuery.of(context).size.width - 165)
                    .toDouble(),
                top: widget.anchor.value!.dy + 50,
                child: FractionalTranslation(
                  translation: const Offset(-0.5, -1.4),
                  child: _buildHighlight(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onSetCommandBasedImage(String uri) {
    widget.editor.executeCommand(
      ConvertCommandToIMGNode(
        nodeId: widget.cmdNode.id,
        uri: uri,
      ),
    );
    // // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    // widget.editor.document.notifyListeners();
  }

  void executeCommand() async {
    final cmdText = widget.cmdNode.text.text;

    //Horizontal Ruler
    if (cmdText == hr) {
      widget.editor.executeCommand(
        ConvertCommandToHRNode(
          nodeId: widget.cmdNode.id,
        ),
      );
      widget.runAfterExecution();
    }

    //Header
    if (cmdText == h1 ||
        cmdText == h2 ||
        cmdText == h3 ||
        cmdText == h4 ||
        cmdText == h5 ||
        cmdText == h6) {
      switch (cmdText) {
        case h1:
          widget.editor.executeCommand(
            ConvertCommandToHeaderNode(
              nodeId: widget.cmdNode.id,
              namedAttribution: header1Attribution,
            ),
          );
          break;
        case h2:
          widget.editor.executeCommand(
            ConvertCommandToHeaderNode(
              nodeId: widget.cmdNode.id,
              namedAttribution: header2Attribution,
            ),
          );
          break;
        case h3:
          widget.editor.executeCommand(
            ConvertCommandToHeaderNode(
              nodeId: widget.cmdNode.id,
              namedAttribution: header3Attribution,
            ),
          );
          break;
        case h4:
          widget.editor.executeCommand(
            ConvertCommandToHeaderNode(
              nodeId: widget.cmdNode.id,
              namedAttribution: header4Attribution,
            ),
          );
          break;
        case h5:
          widget.editor.executeCommand(
            ConvertCommandToHeaderNode(
              nodeId: widget.cmdNode.id,
              namedAttribution: header5Attribution,
            ),
          );
          break;
        case h6:
          widget.editor.executeCommand(
            ConvertCommandToHeaderNode(
              nodeId: widget.cmdNode.id,
              namedAttribution: header6Attribution,
            ),
          );
          break;
        default:
      }
      widget.runAfterExecution();
    }

    //Blockquote
    if (cmdText == blockquote) {
      widget.editor.executeCommand(
        ConvertCommandToBlockquoteNode(
          nodeId: widget.cmdNode.id,
        ),
      );
      widget.runAfterExecution();
    }

    //checkbox
    if (cmdText == checkbox) {
      widget.editor.executeCommand(
        ConvertCommandToCheckboxNode(
          nodeId: widget.cmdNode.id,
        ),
      );
      widget.runAfterExecution();
    }

    //ordered list
    if (cmdText == ol) {
      widget.editor.executeCommand(
        ConvertCommandToListItemNode(
          nodeId: widget.cmdNode.id,
          type: ListItemType.ordered,
        ),
      );
      widget.runAfterExecution();
    }

    //unordered list
    if (cmdText == ul) {
      widget.editor.executeCommand(
        ConvertCommandToListItemNode(
          nodeId: widget.cmdNode.id,
          type: ListItemType.unordered,
        ),
      );
      widget.runAfterExecution();
    }

    //html
    if (cmdText == html || cmdText == iframe) {
      //activate the pop up modal
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        IndicatorWidget.showPopUpModalWidget(
          context,
          child: WriteHtmlWidget(
            onClick: (value) {
              widget.editor.executeCommand(
                ConvertCommandToHtmlNode(
                  nodeId: widget.cmdNode.id,
                  doc: value,
                ),
              );
              widget.runAfterExecution();
            },
          ),
        );
      });
      widget.closeToolbar();
    }

    //Horizontal Image
    if (cmdText == img) {
      //pick image
      final imgFile = await PickerService().pick(
        context,
        fileType: FileType.image,
      );
      //print(imgFile?.extension ?? "no-extension");
      //print(imgFile?.size ?? 0);
      // //print(imgFile.)
      if (imgFile != null) {
        final file = XFile.fromData(imgFile.bytes!);
        //set the node
        onSetCommandBasedImage(file.path);
      }
      widget.runAfterExecution();
    }
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    // widget.editor.document.notifyListeners();
  }

  Widget _buildHighlight() {
    return Material(
      elevation: 5.0,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(22.0),
        bottomLeft: Radius.circular(22.0),
        topRight: Radius.circular(22.0),
      ),
      child: SizedBox(
        height: 220.0,
        width: 200.0,
        child: ListView(shrinkWrap: true, children: [
          //text command
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 17.0,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              "Suggestions " + widget.cmdNode.text.text,
              style: GoogleFonts.rubik(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          //command list
          ...widget.suggestion
              .map(
                (suggest) => GestureDetector(
                  onTap: executeCommand,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 17.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      commandNames[suggest] ?? "",
                      style: GoogleFonts.rubik(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ]),
      ),
    );
  }
}
