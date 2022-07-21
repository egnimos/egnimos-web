import 'package:egnimos/src/pages/write_blog_pages/editor_style_sheet.dart';
import 'package:egnimos/src/pages/write_blog_pages/mutuable_doc_exmp.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/widgets/drop_viewer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:super_editor/super_editor.dart';

import 'editor_tool_bar.dart';

class BlogPage extends StatefulWidget {
  static const routeName = "/blog-page";
  const BlogPage({Key? key}) : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final _docLayoutKey = GlobalKey();
  late DocumentEditor _documentEditor;
  late MutableDocument _doc;
  late DocumentComposer _composer;
  late CommonEditorOperations _docOps;
  late FocusNode _editorFocusNode;
  late ScrollController _scrollController;

  OverlayEntry? _formatBarOverlayEntry;

  final _selectionAnchor = ValueNotifier<Offset?>(null);

  @override
  void initState() {
    super.initState();

    //create  the initial document content
    _doc = doc
      ..addListener(() {
        print(doc.nodes.last.metadata);
        final node = doc.getNodeById(doc.nodes.last.id);
        if (node is TextNode) {
          // ignore: unnecessary_cast
          final textNode = node as TextNode;
          print(textNode.text);
        }
        //update the tool bar display
        _updateToolbarDisplay();
      });

    // Create the DocumentEditor, which is responsible for applying all
    // content changes to the Document.
    _documentEditor = DocumentEditor(
      document: doc,
    );
    print(_documentEditor.document.toString());
    // Create the DocumentComposer, which keeps track of the user's text
    // selection and the current input styles, e.g., bold or italics.
    //
    // This DocumentComposer is created because we want explicit control
    // over the initial caret position. If you don't need any external
    // control over content selection then you don't need to create your
    // own DocumentComposer. The Editor widget will do that on your behalf.
    _composer = DocumentComposer(
      initialSelection: DocumentSelection.collapsed(
        position: DocumentPosition(
          nodeId: _doc.nodes.last.id,
          nodePosition: (_doc.nodes.last as TextNode).endPosition,
        ),
      ),
    )..addListener(_updateToolbarDisplay);

    // Create a FocusNode so that we can explicitly toggle editor focus.
    _editorFocusNode = FocusNode();

    // Use our own ScrollController for the editor so that we can refresh
    // our popup toolbar position as the user scrolls the editor.
    _scrollController = ScrollController()..addListener(_updateToolbarDisplay);
  }

  @override
  void dispose() {
    _formatBarOverlayEntry?.remove();
    _doc.dispose();
    _scrollController.dispose();
    _editorFocusNode.dispose();
    _composer.dispose();

    super.dispose();
  }

  //update toolbar display
  void _updateToolbarDisplay() {
    final selection = _composer.selection;
    //if the selection is null then don't show the toolbar
    if (selection == null) {
      _hideEditorToolbar();
      return;
    }
    //if it is selected with more than one node then don't show the toolbar
    if (selection.base.nodeId != selection.extent.nodeId) {
      _hideEditorToolbar();
      return;
    }
    //we only want to show the toolbar when a span of text
    //is selected. therefore, we ignore collapsed selections
    if (selection.isCollapsed) {
      _hideEditorToolbar();
      return;
    }

    final textNode = _doc.getNodeById(selection.extent.nodeId);
    if (textNode is! TextNode) {
      // The currently selected content is not a paragraph. We don't
      // want to show a toolbar in this case.
      _hideEditorToolbar();

      return;
    }

    if (_formatBarOverlayEntry == null) {
      // Show the editor's toolbar for text styling.
      _showEditorToolbar();
    } else {
      _updateToolbarOffset();
    }
  }

  //hide the editor toolbar
  void _hideEditorToolbar() {
    //nul out the selection anchor so that when it re-appears,
    //the bar doesn't moentarily "flash" at its old anchor position
    _selectionAnchor.value = null;

    if (_formatBarOverlayEntry != null) {
      //remove the toolbar oevrlay and null-out the entry
      //we null out the entry because we can't query whether
      //or not the entry exists in the overlay, so in our case
      //null implies the entry is not in the overlay, and non-null implies
      //the entry is in the overlay
      _formatBarOverlayEntry?.remove();
      _formatBarOverlayEntry = null;
    }

    //ensure that focus returns to the editor
    _editorFocusNode.requestFocus();
  }

  //display the editor
  void _showEditorToolbar() {
    if (_formatBarOverlayEntry == null) {
      _formatBarOverlayEntry ??= OverlayEntry(builder: (context) {
        return EditorToolbar(
          anchor: _selectionAnchor,
          editor: _documentEditor,
          composer: _composer,
          closeToolbar: _hideEditorToolbar,
        );
      });

      // Display the toolbar in the application overlay
      final overlay = Overlay.of(context);
      overlay!.insert(_formatBarOverlayEntry!);

      // Schedule a callback after this frame to locate the selection
      // bounds on the screen and display the toolbar near the selected
      // text.
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _updateToolbarOffset();
      });
    }
  }

  void _updateToolbarOffset() {
    if (_formatBarOverlayEntry == null) {
      return;
    }

    final docBoundingBox =
        (_docLayoutKey.currentState! as DocumentLayout).getRectForSelection(
      _composer.selection!.base,
      _composer.selection!.extent,
    );

    final parentBox = context.findRenderObject()! as RenderBox;
    final docBox =
        _docLayoutKey.currentContext!.findRenderObject()! as RenderBox;
    final parentInOverlayOffset = parentBox.localToGlobal(Offset.zero);
    final overlayBoundingBox = Rect.fromPoints(
      docBox.localToGlobal(docBoundingBox!.topLeft, ancestor: parentBox),
      docBox.localToGlobal(docBoundingBox.bottomRight, ancestor: parentBox),
    ).translate(parentInOverlayOffset.dx, parentInOverlayOffset.dy);

    final offset = overlayBoundingBox.topCenter;
    _selectionAnchor.value = offset;
  }

  ///this methods used to display the image editor
  ///to edit the image for e.g. marker, croper, overlaytext, replace,
  void _showImageEditor() {}

  ///this method activates when the given file is droped
  ///on the active screen
  void _onDropImage(String uri) {
    _documentEditor.document.nodes.add(
      ImageNode(
        id: DocumentEditor.createNodeId(),
        imageUrl: uri.isNotEmpty
            ? uri
            : "https://miro.medium.com/max/1200/1*GLS12MFNCzofmNDt-i4Alw.gif",
      ),
    );

    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    _documentEditor.document.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DropViewerWidget(
        onDrop: _onDropImage,
        child: SuperEditor(
          composer: _composer,
          focusNode: _editorFocusNode,
          documentLayoutKey: _docLayoutKey,
          editor: _documentEditor,
          selectionStyle: SelectionStyles(
            caretColor: ColorTheme.bgColor8,
            selectionColor: ColorTheme.primaryColor.shade200,
          ),
          stylesheet: EditorStyleSheet(context, _composer).wideStyleSheet(),
        ),
      ),
    );
  }
}
