import 'dart:math';

import 'package:egnimos/src/pages/write_blog_pages/custom_attribution/font_size_attribution.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/font_style_attribution_handler.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_editor/super_editor.dart';

import '../../../utility/enum.dart';
import '../custom_attribution/font_decoration_attribution.dart';
import '../custom_editor_comands/convert_command_list_node.dart';
import '../named_attributions.dart';

/// Small toolbar that is intended to display near some selected
/// text and offer a few text formatting controls.
///
/// [EditorToolbar] expects to be displayed in a [Stack] where it
/// will position itself based on the given [anchor]. This can be
/// accomplished, for example, by adding [EditorToolbar] to the
/// application [Overlay]. Any other [Stack] should work, too.
class EditorToolbar extends StatefulWidget {
  const EditorToolbar({
    Key? key,
    required this.anchor,
    required this.editor,
    required this.composer,
    required this.closeToolbar,
  }) : super(key: key);

  /// [EditorToolbar] displays itself horizontally centered and
  /// slightly above the given [anchor] value.
  ///
  /// [anchor] is a [ValueNotifier] so that [EditorToolbar] can
  /// reposition itself as the [Offset] value changes.
  final ValueNotifier<Offset?> anchor;

  /// The [editor] is used to alter document content, such as
  /// when the user selects a different block format for a
  /// text blob, e.g., paragraph, header, blockquote, or
  /// to apply styles to text.
  final DocumentEditor editor;

  /// The [composer] provides access to the user's current
  /// selection within the document, which dictates the
  /// content that is altered by the toolbar's options.
  final DocumentComposer composer;

  /// Delegate that instructs the owner of this [EditorToolbar]
  /// to close the toolbar, such as after submitting a URL
  /// for some text.
  final VoidCallback closeToolbar;
  @override
  State<EditorToolbar> createState() => _EditorToolbarState();
}

class _EditorToolbarState extends State<EditorToolbar> {
  bool _showUrlField = false;
  bool _showColorBox = false;
  ColorBoxType _colorBoxType = ColorBoxType.unknown;
  // bool _showFontSizeField = false;
  late final FocusNode _urlFocusNode;
  final FocusNode _fontSizeFocusNode = FocusNode();
  late final TextEditingController _urlController;
  late final TextEditingController _fontSizeController =
      TextEditingController(text: "18.0");
  num intialFontSize = 18.0;

  ///TEXT STYLE ATTRIBUTION PROPERTIES
  late num fontSize;
  late Color fontColor;
  late Color fontBackgroundColor;
  late Color decorationColor;
  late TextDecorationStyle decorationStyle;
  bool isBold = false;
  bool isItalic = false;
  bool isStrikeThrough = false;
  bool isUnderlineThrough = false;

  @override
  void initState() {
    super.initState();
    isBold = isBoldExistsOfSelectedNode(widget.composer, widget.editor);
    isItalic = isItalicExistsOfSelectedNode(widget.composer, widget.editor);
    isStrikeThrough =
        isStrikeThroughExistsOfSelectedNode(widget.composer, widget.editor);
    isUnderlineThrough =
        isunderlineThroughExistsOfSelectedNode(widget.composer, widget.editor);
    fontSize = getFontSizeOfSelectedNode(widget.composer, widget.editor);
    fontColor = getFontColorOfSelectedNode(widget.composer, widget.editor);
    fontBackgroundColor =
        getFontBackgroundColorOfSelectedNode(widget.composer, widget.editor);
    decorationStyle =
        getFontDecorationStyleOfSelectedNode(widget.composer, widget.editor);
    decorationColor =
        getFontDecorationColorOfSelectedNode(widget.composer, widget.editor);
    //print("FONT SIZE:: $fontSize");
    _urlFocusNode = FocusNode();
    _urlController = TextEditingController();
    _fontSizeController.value = TextEditingValue(text: fontSize.toString());
    // setState(() {});
  }

  @override
  void dispose() {
    _urlFocusNode.dispose();
    _urlController.dispose();
    super.dispose();
  }

  /// Returns true if the currently selected text node is capable of being
  /// transformed into a different type text node, returns false if
  /// multiple nodes are selected, no node is selected, or the selected
  /// node is not a standard text block.
  bool _isConvertibleNode() {
    final selection = widget.composer.selection;
    if (selection == null || selection.base.nodeId != selection.extent.nodeId) {
      return false;
    }

    final selectedNode =
        widget.editor.document.getNodeById(selection.extent.nodeId);
    return selectedNode is ParagraphNode ||
        selectedNode is ListItemNode ||
        selectedNode is ImageNode;
  }

  /// Returns the block type of the currently selected text node.
  ///
  /// Throws an exception if the currently selected node is not a text node.
  TextType _getCurrentTextType() {
    final selection = widget.composer.selection!;
    final selectedNode =
        widget.editor.document.getNodeById(selection.extent.nodeId);
    if (selectedNode is ParagraphNode) {
      final type = selectedNode.metadata['blockType'] as NamedAttribution;
      // //print(type.name);

      if (type == header1Attribution) {
        return TextType.header1;
      } else if (type == header2Attribution) {
        return TextType.header2;
      } else if (type == header3Attribution) {
        return TextType.header3;
      } else if (type == header4Attribution) {
        return TextType.header4;
      } else if (type == header5Attribution) {
        return TextType.header5;
      } else if (type == header6Attribution) {
        return TextType.header6;
      } else if (type == blockquoteAttribution) {
        return TextType.blockquote;
      } else {
        return TextType.paragraph;
      }
    } else if (selectedNode is ListItemNode) {
      return selectedNode.type == ListItemType.ordered
          ? TextType.orderedListItem
          : TextType.unorderedListItem;
    } else {
      throw Exception('Invalid node type: $selectedNode');
    }
  }

  /// Returns the text alignment of the currently selected text node.
  ///
  /// Throws an exception if the currently selected node is not a text node.
  TextAlign _getCurrentTextAlignment() {
    final selection = widget.composer.selection!;
    final selectedNode =
        widget.editor.document.getNodeById(selection.extent.nodeId);
    if (selectedNode is ParagraphNode) {
      final align = selectedNode.metadata['textAlign'] as String?;
      // //print("SELECTED NODE ALLIGNMENT :: $align");
      switch (align) {
        case 'left':
          return TextAlign.left;
        case 'center':
          return TextAlign.center;
        case 'right':
          return TextAlign.right;
        case 'justify':
          return TextAlign.justify;
        default:
          return TextAlign.left;
      }
    } else {
      throw Exception(
          'Alignment does not apply to node of type: $selectedNode');
    }
  }

  /// Returns true if a single text node is selected and that text node
  /// is capable of respecting alignment, returns false otherwise.
  bool _isTextAlignable() {
    final selection = widget.composer.selection;
    if (selection == null || selection.base.nodeId != selection.extent.nodeId) {
      return false;
    }

    final selectedNode =
        widget.editor.document.getNodeById(selection.extent.nodeId);
    return selectedNode is ParagraphNode;
  }

  /// Converts the currently selected text node into a new type of
  /// text node, represented by [newType].
  ///
  /// For example: convert a paragraph to a blockquote, or a header
  /// to a list item.
  void _convertTextToNewType(TextType? newType) {
    if (newType == null) {
      return;
    }

    final existingTextType = _getCurrentTextType();

    if (existingTextType == newType) {
      // The text is already the desired type. Return.
      return;
    }

    if (_isListItem(existingTextType) && _isListItem(newType)) {
      widget.editor.executeCommand(
        ChangeListItemTypeCustomCommand(
          nodeId: widget.composer.selection!.extent.nodeId,
          newType: newType == TextType.orderedListItem
              ? ListItemType.ordered
              : ListItemType.unordered,
        ),
      );
    } else if (_isListItem(existingTextType) && !_isListItem(newType)) {
      widget.editor.executeCommand(
        ConvertListItemToParagraphCommand(
          nodeId: widget.composer.selection!.extent.nodeId,
          paragraphMetadata: {
            'blockType': _getBlockTypeAttribution(newType),
          },
        ),
      );
    } else if (!_isListItem(existingTextType) && _isListItem(newType)) {
      widget.editor.executeCommand(
        ConvertParagraphToListItemCustomCommand(
          nodeId: widget.composer.selection!.extent.nodeId,
          type: newType == TextType.orderedListItem
              ? ListItemType.ordered
              : ListItemType.unordered,
        ),
      );
    } else {
      // //print(newType.name);
      // Apply a new block type to an existing paragraph node.
      final existingNode = widget.editor.document
          .getNodeById(widget.composer.selection!.extent.nodeId)!;
      (existingNode as ParagraphNode)
          .putMetadataValue('blockType', _getBlockTypeAttribution(newType));
    }
    // widget.closeToolbar();
  }

  /// Returns true if the given [_TextType] represents an
  /// ordered or unordered list item, returns false otherwise.
  bool _isListItem(TextType type) {
    return type == TextType.orderedListItem ||
        type == TextType.unorderedListItem;
  }

  /// Returns the text [Attribution] associated with the given
  /// [TextType], e.g., [TextType.header1] -> [header1Attribution].
  Attribution? _getBlockTypeAttribution(TextType newType) {
    switch (newType) {
      case TextType.header1:
        return header1Attribution;
      case TextType.header2:
        return header2Attribution;
      case TextType.header3:
        return header3Attribution;
      case TextType.header4:
        return header4Attribution;
      case TextType.header5:
        return header5Attribution;
      case TextType.header6:
        return header6Attribution;
      case TextType.blockquote:
        return blockquoteAttribution;
      case TextType.paragraph:
        return paragraphAttribution;
      default:
        return null;
    }
  }

  /// Toggles bold styling for the current selected text.
  void _toggleBold() {
    widget.editor.executeCommand(
      ToggleTextAttributionsCommand(
        documentSelection: widget.composer.selection!,
        attributions: {boldAttribution},
      ),
    );
    setState(() {
      isBold = !isBold;
    });
  }

  /// Toggles italic styling for the current selected text.
  void _toggleItalics() {
    widget.editor.executeCommand(
      ToggleTextAttributionsCommand(
        documentSelection: widget.composer.selection!,
        attributions: {italicsAttribution},
      ),
    );
    setState(() {
      isItalic = !isItalic;
    });
  }

  /// Toggles strikethrough styling for the current selected text.
  void _toggleStrikethrough() {
    widget.editor.executeCommand(
      ToggleTextAttributionsCommand(
        documentSelection: widget.composer.selection!,
        attributions: {strikethroughAttribution},
      ),
    );
    setState(() {
      isStrikeThrough = !isStrikeThrough;
    });
  }

  /// Toggles underlinethrough styling for the current selected text.
  void _toggleUnderlinethrough() {
    widget.editor.executeCommand(
      ToggleTextAttributionsCommand(
        documentSelection: widget.composer.selection!,
        attributions: {underlineAttribution},
      ),
    );
    setState(() {
      isUnderlineThrough = !isUnderlineThrough;
    });
  }

  void removeAttributionOfTheGivenSpanRange(Attribution attribution) {
    final selection = widget.composer.selection!;
    final selectedNode =
        widget.editor.document.getNodeById(selection.extent.nodeId);
    if (selectedNode is! TextNode) {
      return;
    }

    final extentOffset = (selection.extent.nodePosition as TextPosition).offset;
    final baseOffset = (selection.base.nodePosition as TextPosition).offset;
    final selectionStart = min(baseOffset, extentOffset);
    final selectionEnd = max(baseOffset, extentOffset);
    final attributions = selectedNode.text.getAllAttributionsThroughout(
      SpanRange(
        start: selectionStart,
        end: selectionEnd - 1,
      ),
    );

    for (var attr in attributions) {
      if (attr.id == attribution.id) {
        selectedNode.text.removeAttribution(
          attr,
          SpanRange(
            start: selectionStart,
            end: selectionEnd - 1,
          ),
        );
      }
    }
  }

  //apply the attribution spans to the selections
  void applyAttributionOfTheGivenSpanRange(Attribution attribution) {
    final selection = widget.composer.selection!;
    final selectedNode =
        widget.editor.document.getNodeById(selection.extent.nodeId);
    if (selectedNode is! TextNode) {
      return;
    }

    final extentOffset = (selection.extent.nodePosition as TextPosition).offset;
    final baseOffset = (selection.base.nodePosition as TextPosition).offset;
    final selectionStart = min(baseOffset, extentOffset);
    final selectionEnd = max(baseOffset, extentOffset);
    selectedNode.text.addAttribution(
      attribution,
      SpanRange(
        start: selectionStart,
        end: selectionEnd - 1,
      ),
    );
  }

  // void _removeFontSizeAttribution(double initialValue) {
  //   widget.editor.executeCommand(
  //     RemoveTextAttributionsCommand(
  //       documentSelection: widget.composer.selection!,
  //       attributions: {FontSizeDecorationAttribution(fontSize: initialValue)},
  //     ),
  //   );
  // }

  // void _setFontSize(double value) {
  //   widget.editor.executeCommand(
  //     AddTextAttributionsCommand(
  //       documentSelection: widget.composer.selection!,
  //       attributions: {
  //         FontSizeDecorationAttribution(
  //           fontSize: value,
  //         )
  //       },
  //     ),
  //   );
  // }

  /// Returns true if the current text selection includes part
  /// or all of a single link, returns false if zero links are
  /// in the selection or if 2+ links are in the selection.
  bool _isSingleLinkSelected() {
    return _getSelectedLinkSpans().length == 1;
  }

  /// Returns true if the current text selection includes 2+
  /// links, returns false otherwise.
  bool _areMultipleLinksSelected() {
    return _getSelectedLinkSpans().length >= 2;
  }

  /// Returns any link-based [AttributionSpan]s that appear partially
  /// or wholly within the current text selection.
  Set<AttributionSpan> _getSelectedLinkSpans() {
    final selection = widget.composer.selection;
    final baseOffset = (selection!.base.nodePosition as TextPosition).offset;
    final extentOffset = (selection.extent.nodePosition as TextPosition).offset;
    final selectionStart = min(baseOffset, extentOffset);
    final selectionEnd = max(baseOffset, extentOffset);
    final selectionRange =
        SpanRange(start: selectionStart, end: selectionEnd - 1);

    final textNode = widget.editor.document
        .getNodeById(selection.extent.nodeId)! as TextNode;
    final text = textNode.text;

    final overlappingLinkAttributions = text.getAttributionSpansInRange(
      attributionFilter: (Attribution attribution) =>
          attribution is LinkAttribution,
      range: selectionRange,
    );

    return overlappingLinkAttributions;
  }

  /// Takes appropriate action when the toolbar's link button is
  /// pressed.
  void _onLinkPressed() {
    final selection = widget.composer.selection;
    final baseOffset = (selection!.base.nodePosition as TextPosition).offset;
    final extentOffset = (selection.extent.nodePosition as TextPosition).offset;
    final selectionStart = min(baseOffset, extentOffset);
    final selectionEnd = max(baseOffset, extentOffset);
    final selectionRange =
        SpanRange(start: selectionStart, end: selectionEnd - 1);

    final textNode = widget.editor.document
        .getNodeById(selection.extent.nodeId)! as TextNode;
    final text = textNode.text;

    final overlappingLinkAttributions = text.getAttributionSpansInRange(
      attributionFilter: (Attribution attribution) =>
          attribution is LinkAttribution,
      range: selectionRange,
    );

    if (overlappingLinkAttributions.length >= 2) {
      // Do nothing when multiple links are selected.
      return;
    }

    if (overlappingLinkAttributions.isNotEmpty) {
      // The selected text contains one other link.
      final overlappingLinkSpan = overlappingLinkAttributions.first;
      final isLinkSelectionOnTrailingEdge =
          (overlappingLinkSpan.start >= selectionRange.start &&
                  overlappingLinkSpan.start <= selectionRange.end) ||
              (overlappingLinkSpan.end >= selectionRange.start &&
                  overlappingLinkSpan.end <= selectionRange.end);

      if (isLinkSelectionOnTrailingEdge) {
        // The selected text covers the beginning, or the end, or the entire
        // existing link. Remove the link attribution from the selected text.
        text.removeAttribution(overlappingLinkSpan.attribution, selectionRange);
      } else {
        // The selected text sits somewhere within the existing link. Remove
        // the entire link attribution.
        text.removeAttribution(
          overlappingLinkSpan.attribution,
          SpanRange(
              start: overlappingLinkSpan.start, end: overlappingLinkSpan.end),
        );
      }
    } else {
      // There are no other links in the selection. Show the URL text field.
      setState(() {
        _showUrlField = true;
        _urlFocusNode.requestFocus();
      });
    }
  }

  /// Takes the text from the [urlController] and applies it as a link
  /// attribution to the currently selected text.
  void _applyLink() {
    final url = _urlController.text;

    final selection = widget.composer.selection;
    final baseOffset = (selection!.base.nodePosition as TextPosition).offset;
    final extentOffset = (selection.extent.nodePosition as TextPosition).offset;
    final selectionStart = min(baseOffset, extentOffset);
    final selectionEnd = max(baseOffset, extentOffset);
    final selectionRange =
        SpanRange(start: selectionStart, end: selectionEnd - 1);

    final textNode = widget.editor.document
        .getNodeById(selection.extent.nodeId)! as TextNode;
    final text = textNode.text;

    final trimmedRange = _trimTextRangeWhitespace(text, selectionRange);

    final linkAttribution = LinkAttribution(url: Uri.parse(url));
    text.addAttribution(
      linkAttribution,
      trimmedRange,
    );

    //add it to the decoration holder
    // AttributionHolder.saveDecorations(
    //   composer: widget.composer,
    //   editor: widget.editor,
    //   attribution: linkAttribution,
    //   funcType: DecorationFunctionType.add,
    // );

    // Clear the field and hide the URL bar
    _urlController.clear();
    setState(() {
      _showUrlField = false;
      _urlFocusNode.unfocus(
          disposition: UnfocusDisposition.previouslyFocusedChild);
      // widget.closeToolbar();
    });
  }

  /// Given [text] and a [range] within the [text], the [range] is
  /// shortened on both sides to remove any trailing whitespace and
  /// the new range is returned.
  SpanRange _trimTextRangeWhitespace(AttributedText text, SpanRange range) {
    int startOffset = range.start;
    int endOffset = range.end;

    while (startOffset < range.end && text.text[startOffset] == ' ') {
      startOffset += 1;
    }
    while (endOffset > startOffset && text.text[endOffset] == ' ') {
      endOffset -= 1;
    }

    return SpanRange(start: startOffset, end: endOffset);
  }

  /// Changes the alignment of the current selected text node
  /// to reflect [newAlignment].
  void _changeAlignment(TextAlign? newAlignment) {
    String? newAlignmentValue;
    switch (newAlignment) {
      case TextAlign.left:
      case TextAlign.start:
        newAlignmentValue = 'left';
        break;
      case TextAlign.center:
        newAlignmentValue = 'center';
        break;
      case TextAlign.right:
      case TextAlign.end:
        newAlignmentValue = 'right';
        break;
      case TextAlign.justify:
        newAlignmentValue = 'justify';
        break;
      case null:
        // Do nothing.
        return;
    }

    final selectedNode = widget.editor.document
            .getNodeById(widget.composer.selection!.extent.nodeId)!
        as ParagraphNode;

    // selectedNode.metadata['textAlign'] = newAlignmentValue;
    selectedNode.putMetadataValue('textAlign', newAlignmentValue);
    // //print("SET ALIGNMENT :: $newAlignmentValue");

    //close the toolbar
    // widget.closeToolbar();
  }

  /// Returns the localized name for the given [_TextType], e.g.,
  /// "Paragraph" or "Header 1".
  String _getTextTypeName(TextType textType) {
    switch (textType) {
      case TextType.header1:
        return 'Header 1';
      case TextType.header2:
        return 'Header 2';
      case TextType.header3:
        return 'Header 3';
      case TextType.header4:
        return 'Header 4';
      case TextType.header5:
        return 'Header 5';
      case TextType.header6:
        return 'Header 6';
      case TextType.paragraph:
        return 'Paragraph';
      case TextType.blockquote:
        return 'Blockquote';
      case TextType.orderedListItem:
        return 'Ordered List Item';
      case TextType.unorderedListItem:
        return 'Unordered List Item';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.anchor,
      builder: (context, offset, child) {
        if (widget.anchor.value == null || widget.composer.selection == null) {
          // When no anchor position is available, or the user hasn't
          // selected any text, show nothing.
          return const SizedBox();
        }

        return SizedBox.expand(
          child: Stack(
            children: [
              // Conditionally display the URL text field below
              // the standard toolbar.
              if (_showUrlField)
                Positioned(
                  left: widget.anchor.value!.dx,
                  top: widget.anchor.value!.dy,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, 0.0),
                    child: _buildUrlField(),
                  ),
                ),

              if (_showColorBox)
                Positioned(
                  left: widget.anchor.value!.dx,
                  top: widget.anchor.value!.dy - 420.0,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, 0.0),
                    child: _buildColorBox(),
                  ),
                ),

              // The hard-coded clamp values are based on empirical checks
              // with the marketing website. The clamping behavior should be
              // generalized to use this toolbar in an app.
              Positioned(
                left: widget.anchor.value!.dx
                    .clamp(165, MediaQuery.of(context).size.width - 165)
                    .toDouble(),
                top: widget.anchor.value!.dy,
                child: FractionalTranslation(
                  translation: const Offset(-0.5, -1.4),
                  child: _buildToolbar(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColorBox() {
    return Material(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: SizedBox(
        // height: 550.0,
        child: IntrinsicWidth(
          child: Column(
            children: [
              //HEADING COLOR PICKER
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                title: const Text("Pick the Color"),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _showColorBox = false;
                      _colorBoxType = ColorBoxType.unknown;
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                    color: ColorTheme.primaryColor,
                  ),
                ),
              ),
              //COLOR PICKER
              HueRingPicker(
                colorPickerHeight: 300.0,
                enableAlpha: true,
                pickerColor: fontColor,
                onColorChanged: (color) {
                  if (_colorBoxType == ColorBoxType.fontColor) {
                    // widget.editor.executeCommand(
                    //   RemoveTextAttributionsCommand(
                    //     documentSelection: widget.composer.selection!,
                    //     attributions: {
                    //       FontColorDecorationAttribution(
                    //         fontColor: fontColor,
                    //       )
                    //     },
                    //   ),
                    // );
                    removeAttributionOfTheGivenSpanRange(
                      FontColorDecorationAttribution(
                        fontColor: fontColor,
                      ),
                    );

                    //set the updated value
                    // widget.editor.executeCommand(
                    //   AddTextAttributionsCommand(
                    //     documentSelection: widget.composer.selection!,
                    //     attributions: {
                    //       FontColorDecorationAttribution(
                    //         fontColor: color,
                    //       )
                    //     },
                    //   ),
                    // );
                    applyAttributionOfTheGivenSpanRange(
                      FontColorDecorationAttribution(
                        fontColor: color,
                      ),
                    );

                    //add it to the decoration holder
                    // AttributionHolder.saveDecorations(
                    //   composer: widget.composer,
                    //   editor: widget.editor,
                    //   attribution: FontColorDecorationAttribution(
                    //     fontColor: color,
                    //   ),
                    //   funcType: DecorationFunctionType.add,
                    // );

                    //update the intial font color value
                    fontColor = color;
                  }

                  //set background color
                  if (_colorBoxType == ColorBoxType.fontBackgroundColor) {
                    //remove intiial attribution
                    // widget.editor.executeCommand(
                    //   RemoveTextAttributionsCommand(
                    //     documentSelection: widget.composer.selection!,
                    //     attributions: {
                    //       FontBackgroundColorDecorationAttribution(
                    //         fontBackgroundColor: fontBackgroundColor,
                    //       )
                    //     },
                    //   ),
                    // );
                    removeAttributionOfTheGivenSpanRange(
                      FontBackgroundColorDecorationAttribution(
                        fontBackgroundColor: fontBackgroundColor,
                      ),
                    );
                    applyAttributionOfTheGivenSpanRange(
                      FontBackgroundColorDecorationAttribution(
                        fontBackgroundColor: color,
                      ),
                    );
                    //set the updated value
                    // widget.editor.executeCommand(
                    //   AddTextAttributionsCommand(
                    //     documentSelection: widget.composer.selection!,
                    //     attributions: {
                    //       FontBackgroundColorDecorationAttribution(
                    //         fontBackgroundColor: color,
                    //       )
                    //     },
                    //   ),
                    // );

                    //add it to the decoration holder
                    // AttributionHolder.saveDecorations(
                    //   composer: widget.composer,
                    //   editor: widget.editor,
                    //   attribution: FontBackgroundColorDecorationAttribution(
                    //     fontBackgroundColor: color,
                    //   ),
                    //   funcType: DecorationFunctionType.add,
                    // );

                    //update the intial font background color value
                    fontBackgroundColor = color;
                  }

                  //set the decoration color
                  if (_colorBoxType == ColorBoxType.decorationColor) {
                    //remove intiial attribution
                    // widget.editor.executeCommand(
                    //   RemoveTextAttributionsCommand(
                    //     documentSelection: widget.composer.selection!,
                    //     attributions: {
                    //       FontDecorationColorDecorationAttribution(
                    //         fontDecorationColor: decorationColor,
                    //       )
                    //     },
                    //   ),
                    // );
                    removeAttributionOfTheGivenSpanRange(
                      FontDecorationColorDecorationAttribution(
                        fontDecorationColor: decorationColor,
                      ),
                    );
                    applyAttributionOfTheGivenSpanRange(
                      FontDecorationColorDecorationAttribution(
                        fontDecorationColor: color,
                      ),
                    );
                    //set the updated value
                    // widget.editor.executeCommand(
                    //   AddTextAttributionsCommand(
                    //     documentSelection: widget.composer.selection!,
                    //     attributions: {
                    //       FontDecorationColorDecorationAttribution(
                    //         fontDecorationColor: color,
                    //       )
                    //     },
                    //   ),
                    // );

                    //add it to the decoration holder
                    // AttributionHolder.saveDecorations(
                    //   composer: widget.composer,
                    //   editor: widget.editor,
                    //   attribution: FontDecorationColorDecorationAttribution(
                    //     fontDecorationColor: color,
                    //   ),
                    //   funcType: DecorationFunctionType.add,
                    // );

                    //update the intial font decoration color value
                    decorationColor = color;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    // //print("FONT SIZE TOOLBAR VALUE :: " + _fontSizeController.text);
    return Material(
      shape: const StadiumBorder(),
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: MouseRegion(
        onEnter: (_) {},
        onExit: (_) {},
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Only allow the user to select a new type of text node if
              // the currently selected node can be converted.
              if (_isConvertibleNode()) ...[
                Tooltip(
                  message: 'Text block type',
                  child: DropdownButton<TextType>(
                    value: _getCurrentTextType(),
                    items: TextType.values
                        .map(
                          (textType) => DropdownMenuItem<TextType>(
                            value: textType,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(_getTextTypeName(textType)),
                            ),
                          ),
                        )
                        .toList(),
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    underline: const SizedBox(),
                    elevation: 0,
                    onChanged: _convertTextToNewType,
                  ),
                ),
                _buildVerticalDivider(),
              ],

              //BOLD TOGGLE
              Center(
                child: IconButton(
                  onPressed: () {
                    _toggleBold();
                    //add it to the decoration holder
                    // AttributionHolder.saveDecorations(
                    //   composer: widget.composer,
                    //   editor: widget.editor,
                    //   attribution: boldAttribution,
                    //   funcType: DecorationFunctionType.toggle,
                    // );
                  },
                  icon: Icon(
                    Icons.format_bold,
                    color: isBold ? ColorTheme.bgColor6 : null,
                    size: isBold ? 30.0 : null,
                  ),
                  splashRadius: 16,
                  tooltip: 'Bold',
                ),
              ),

              //ITALICS TOGGLE
              Center(
                child: IconButton(
                  onPressed: () {
                    _toggleItalics();
                    //add it to the decoration holder
                    // AttributionHolder.saveDecorations(
                    //   composer: widget.composer,
                    //   editor: widget.editor,
                    //   attribution: italicsAttribution,
                    //   funcType: DecorationFunctionType.toggle,
                    // );
                  },
                  icon: Icon(
                    Icons.format_italic,
                    color: isItalic ? ColorTheme.bgColor6 : null,
                    size: isItalic ? 30.0 : null,
                  ),
                  splashRadius: 16,
                  tooltip: 'Italics',
                ),
              ),

              //STRIKE THROUGH TOGGLE
              Center(
                child: IconButton(
                  onPressed: () {
                    _toggleStrikethrough();
                    //add it to the decoration holder
                    // AttributionHolder.saveDecorations(
                    //   composer: widget.composer,
                    //   editor: widget.editor,
                    //   attribution: strikethroughAttribution,
                    //   funcType: DecorationFunctionType.toggle,
                    // );
                  },
                  icon: Icon(
                    Icons.strikethrough_s,
                    color: isStrikeThrough ? ColorTheme.bgColor6 : null,
                    size: isStrikeThrough ? 30.0 : null,
                  ),
                  splashRadius: 16,
                  tooltip: 'Strikethrough',
                ),
              ),

              //UNDERLINE THROUGH TOGGLE
              Center(
                child: IconButton(
                  onPressed: () {
                    _toggleUnderlinethrough();
                    //add it to the decoration holder
                    // AttributionHolder.saveDecorations(
                    //   composer: widget.composer,
                    //   editor: widget.editor,
                    //   attribution: underlineAttribution,
                    //   funcType: DecorationFunctionType.toggle,
                    // );
                  },
                  icon: Icon(
                    Icons.format_underline_rounded,
                    color: isUnderlineThrough ? ColorTheme.bgColor6 : null,
                    size: isUnderlineThrough ? 30.0 : null,
                  ),
                  splashRadius: 16,
                  tooltip: 'Underlinethrough',
                ),
              ),

              _buildVerticalDivider(),

              //INCREMENT FONT SIZE BUTTON
              Center(
                child: IconButton(
                  onPressed: () {
                    final initialFontSize = num.parse(_fontSizeController.text);
                    final updatedFontSize = initialFontSize + 1;
                    _fontSizeController.value =
                        TextEditingValue(text: updatedFontSize.toString());
                    //remove intiial attribution
                    // _removeFontSizeAttribution(
                    //   initialFontSize.toDouble(),
                    // );
                    removeAttributionOfTheGivenSpanRange(
                      FontSizeDecorationAttribution(
                        fontSize: initialFontSize.toDouble(),
                      ),
                    );
                    //set the updated value
                    // _setFontSize(
                    //   updatedFontSize.toDouble(),
                    // );
                    applyAttributionOfTheGivenSpanRange(
                      FontSizeDecorationAttribution(
                        fontSize: updatedFontSize.toDouble(),
                      ),
                    );
                    //add it to the decoration holder
                    // AttributionHolder.saveDecorations(
                    //   composer: widget.composer,
                    //   editor: widget.editor,
                    //   attribution: FontSizeDecorationAttribution(
                    //     fontSize: updatedFontSize,
                    //   ),
                    //   funcType: DecorationFunctionType.add,
                    // );
                  },
                  icon: const Icon(Icons.add_rounded),
                  splashRadius: 16,
                  tooltip: 'increase font size by one',
                ),
              ),

              Center(
                child: buildFontSizeField(),
              ),

              //DECREMENT THE FONT SIZE
              Center(
                child: IconButton(
                  onPressed: () {
                    final initialFontSize = num.parse(_fontSizeController.text);
                    if (initialFontSize <= 0) return;
                    final updatedFontSize = initialFontSize - 1;
                    _fontSizeController.value =
                        TextEditingValue(text: updatedFontSize.toString());
                    //remove intiial attribution
                    // _removeFontSizeAttribution(
                    //   initialFontSize.toDouble(),
                    // );
                    removeAttributionOfTheGivenSpanRange(
                      FontSizeDecorationAttribution(
                        fontSize: initialFontSize.toDouble(),
                      ),
                    );
                    applyAttributionOfTheGivenSpanRange(
                      FontSizeDecorationAttribution(
                        fontSize: updatedFontSize.toDouble(),
                      ),
                    );
                  },
                  icon: Transform.translate(
                    offset: const Offset(0.0, -10.0),
                    child: const Icon(Icons.minimize_rounded),
                  ),
                  splashRadius: 16,
                  tooltip: 'decrement font size by one',
                ),
              ),

              _buildVerticalDivider(),

              //TEXT COLOR
              Center(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _showColorBox = true;
                      _colorBoxType = ColorBoxType.fontColor;
                    });
                  },
                  icon: Icon(
                    Icons.text_format,
                    color: fontColor,
                  ),
                  tooltip: 'text color',
                ),
              ),

              //TEXT BACKGROUND COLOR
              Center(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _showColorBox = true;
                      _colorBoxType = ColorBoxType.fontBackgroundColor;
                    });
                  },
                  icon: Icon(
                    Icons.colorize_rounded,
                    color: fontBackgroundColor,
                  ),
                  tooltip: 'text background color',
                ),
              ),

              //TEXT LINE Decoration STYLE\
              Tooltip(
                message: 'text line decoration',
                child: DropdownButton<TextDecorationStyle>(
                  value: decorationStyle,
                  items: TextDecorationStyle.values
                      .map((textDecorationStyle) =>
                          DropdownMenuItem<TextDecorationStyle>(
                            value: textDecorationStyle,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _buildTextDecorationStyleIcon(
                                  textDecorationStyle),
                            ),
                          ))
                      .toList(),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  underline: const SizedBox(),
                  elevation: 0,
                  onChanged: (decorationStyle) {
                    //remove intiial attribution
                    // widget.editor.executeCommand(
                    //   RemoveTextAttributionsCommand(
                    //     documentSelection: widget.composer.selection!,
                    //     attributions: {
                    //       FontDecorationStyleAttribution(
                    //         fontDecorationStyle: this.decorationStyle,
                    //       )
                    //     },
                    //   ),
                    // );
                    removeAttributionOfTheGivenSpanRange(
                      FontDecorationStyleAttribution(
                        fontDecorationStyle: this.decorationStyle,
                      ),
                    );
                    //set the updated value
                    // widget.editor.executeCommand(
                    //   AddTextAttributionsCommand(
                    //     documentSelection: widget.composer.selection!,
                    //     attributions: {
                    //       FontDecorationStyleAttribution(
                    //         fontDecorationStyle:
                    //             decorationStyle ?? TextDecorationStyle.solid,
                    //       )
                    //     },
                    //   ),
                    // );
                    applyAttributionOfTheGivenSpanRange(
                      FontDecorationStyleAttribution(
                        fontDecorationStyle:
                            decorationStyle ?? TextDecorationStyle.solid,
                      ),
                    );

                    //add it to the decoration holder
                    // AttributionHolder.saveDecorations(
                    //   composer: widget.composer,
                    //   editor: widget.editor,
                    //   attribution: FontDecorationStyleAttribution(
                    //     fontDecorationStyle:
                    //         decorationStyle ?? TextDecorationStyle.solid,
                    //   ),
                    //   funcType: DecorationFunctionType.add,
                    // );

                    //update the intial font decoration color value
                    setState(() {
                      this.decorationStyle =
                          decorationStyle ?? TextDecorationStyle.solid;
                    });
                  },
                ),
              ),

              //TEXT DECORATION COLOR
              Center(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _showColorBox = true;
                      _colorBoxType = ColorBoxType.decorationColor;
                    });
                  },
                  icon: Icon(
                    FontAwesomeIcons.paintbrush,
                    color: decorationColor,
                  ),
                  tooltip: 'text decoration color',
                ),
              ),

              _buildVerticalDivider(),

              //SET THE LINK
              Center(
                child: IconButton(
                  onPressed:
                      _areMultipleLinksSelected() ? null : _onLinkPressed,
                  icon: const Icon(Icons.link),
                  color: _isSingleLinkSelected()
                      ? const Color(0xFF007AFF)
                      : IconTheme.of(context).color,
                  splashRadius: 16,
                  tooltip: 'Link',
                ),
              ),
              // Only display alignment controls if the currently selected text
              // node respects alignment. List items, for example, do not.
              if (_isTextAlignable()) ...[
                _buildVerticalDivider(),
                Tooltip(
                  message: 'Text Alignment',
                  child: DropdownButton<TextAlign>(
                    value: _getCurrentTextAlignment(),
                    items: [
                      TextAlign.left,
                      TextAlign.center,
                      TextAlign.right,
                      TextAlign.justify
                    ]
                        .map((textAlign) => DropdownMenuItem<TextAlign>(
                              value: textAlign,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(_buildTextAlignIcon(textAlign)),
                              ),
                            ))
                        .toList(),
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    underline: const SizedBox(),
                    elevation: 0,
                    onChanged: _changeAlignment,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  IconData _buildTextAlignIcon(TextAlign align) {
    switch (align) {
      case TextAlign.left:
      case TextAlign.start:
        return Icons.format_align_left;
      case TextAlign.center:
        return Icons.format_align_center;
      case TextAlign.right:
      case TextAlign.end:
        return Icons.format_align_right;
      case TextAlign.justify:
        return Icons.format_align_justify;
    }
  }

  Widget _buildTextDecorationStyleIcon(TextDecorationStyle style) {
    switch (style) {
      case TextDecorationStyle.dashed:
        return Image.asset("assets/images/png/dashed_line.png");
      case TextDecorationStyle.dotted:
        return Image.asset("assets/images/png/dotted_line.png");
      case TextDecorationStyle.solid:
        return Image.asset("assets/images/png/line.png");
      case TextDecorationStyle.wavy:
        return Image.asset("assets/images/png/wavy_line.png");
      case TextDecorationStyle.double:
        return Image.asset("assets/images/png/double_line.png");
      default:
        return Image.asset("assets/images/png/line.png");
    }
  }

  //display the URL input field to take it as a input
  Widget _buildUrlField() {
    return Material(
      shape: const StadiumBorder(),
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: 400,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: _urlFocusNode,
                controller: _urlController,
                decoration: const InputDecoration(
                  hintText: 'enter url...',
                  border: InputBorder.none,
                ),
              ),
            ),

            //apply
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.greenAccent,
              ),
              iconSize: 20,
              splashRadius: 16,
              padding: EdgeInsets.zero,
              onPressed: _applyLink,
            ),

            //close
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.redAccent,
              ),
              iconSize: 20,
              splashRadius: 16,
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  _urlFocusNode.unfocus();
                  _showUrlField = false;
                  _urlController.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFontSizeField() {
    return Material(
      child: SizedBox(
        width: 50.0,
        height: 30.0,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: _fontSizeFocusNode,
                controller: _fontSizeController,
                style: GoogleFonts.rubik(
                  color: ColorTheme.primaryTextColor,
                ),
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
                onChanged: (updatedFontSize) {
                  final initialFontSizeValue = intialFontSize;
                  //print("Initial Value :: " + initialFontSizeValue.toString());
                  //print("final Value :: " + updatedFontSize.toString());
                  //remove intiial attribution
                  // _removeFontSizeAttribution(
                  //   initialFontSizeValue.toDouble(),
                  // );
                  removeAttributionOfTheGivenSpanRange(
                    FontSizeDecorationAttribution(
                      fontSize: initialFontSizeValue.toDouble(),
                    ),
                  );
                  //set the updated value
                  applyAttributionOfTheGivenSpanRange(
                    FontSizeDecorationAttribution(
                      fontSize: num.parse(updatedFontSize),
                    ),
                  );
                  // _setFontSize(
                  //   num.parse(updatedFontSize).toDouble(),
                  // );
                  //add it to the decoration holder
                  // AttributionHolder.saveDecorations(
                  //   composer: widget.composer,
                  //   editor: widget.editor,
                  //   attribution: FontSizeDecorationAttribution(
                  //     fontSize: num.parse(updatedFontSize),
                  //   ),
                  //   funcType: DecorationFunctionType.add,
                  // );
                  intialFontSize = num.parse(updatedFontSize);
                  _fontSizeFocusNode.requestFocus();
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    top: 14.0,
                    left: 8.0,
                  ),
                  hintText: "font...",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade700,
                      width: 0.9,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade700,
                      width: 0.9,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
