import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egnimos/main.dart';
import 'package:egnimos/src/models/blog.dart';
import 'package:egnimos/src/models/category.dart';
import 'package:egnimos/src/pages/profile_page.dart';
import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/execute_command.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_attribution/attribution_holder.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_document_nodes/checkbox_node.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_editor_comands/checkbox_list_commands.dart';
import 'package:egnimos/src/pages/write_blog_pages/custom_editor_comands/shift_to_newline.dart';
import 'package:egnimos/src/pages/write_blog_pages/mutuable_doc_exmp.dart';
import 'package:egnimos/src/pages/write_blog_pages/parser_extension.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/header_styles.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/inlinetext_styles.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/main_layout.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/node_styles.dart';
import 'package:egnimos/src/pages/write_blog_pages/toolbar/image_editor_toolbar.dart';
import 'package:egnimos/src/providers/auth_provider.dart';
import 'package:egnimos/src/providers/blog_provider.dart';
import 'package:egnimos/src/providers/upload_provider.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/utility/prefs_keys.dart';
import 'package:egnimos/src/widgets/create_pop_up_modal_widget.dart';
import 'package:egnimos/src/widgets/drop_viewer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:super_editor/super_editor.dart';

import '../../models/user.dart';
import '../../widgets/indicator_widget.dart';
import 'toolbar/editor_tool_bar.dart';

class WriteBlogPage extends StatefulWidget {
  // final BlogAction action;
  final BlogType? blogType;
  final Blog? blog;
  // static const routeName = "/blog-page";
  const WriteBlogPage({
    Key? key,
    // required this.action,
    this.blog,
    this.blogType,
  }) : super(key: key);

  @override
  State<WriteBlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<WriteBlogPage> {
  final _docLayoutKey = GlobalKey();
  late DocumentEditor _documentEditor;
  late MutableDocument _doc;
  late DocumentComposer _composer;
  late FocusNode _editorFocusNode;
  late ScrollController _scrollController;
  bool _isLoading = true;
  final _isSaving = ValueNotifier<bool>(false);

  //Toolbar
  OverlayEntry? _formatBarOverlayEntry;
  OverlayEntry? _imageFormatBarOverlayEntry;

  final _imageSelectionAnchor = ValueNotifier<Offset?>(null);
  final _selectionAnchor = ValueNotifier<Offset?>(null);

  Future<MutableDocument> loadTheDoc() async {
    try {
      //to json
      final isExist = prefs?.containsKey(PrefsKey.docData) ?? false;
      if (isExist) {
        final docJson = prefs?.getString(PrefsKey.docData) ?? "";
        final doc = jsonDecode(docJson);
        return DocumentJsonParser.fromJson(doc);
      }
      //if the action is update
      if (widget.blog != null) {
        final doc = await Provider.of<BlogProvider>(context, listen: false)
            .getBlog(widget.blogType!, widget.blog!.id);
        await prefs?.setString(PrefsKey.docData,
            jsonEncode(DocumentJsonParser(doc).toJson(doc.nodes)));
        return doc;
      }
      final docData = DocumentJsonParser(doc).toJson(doc.nodes);
      return DocumentJsonParser.fromJson(docData);
    } catch (e) {
      print(e);
    }
    return doc;
  }

  @override
  void didChangeDependencies() {
    loadTheDoc().then((doc) {
      //create  the initial document content
      _doc = doc
        ..addListener(() async {
          // print(doc.nodes.last.copyMetadata());
          // if (doc.nodes.last is ParagraphNode) {
          //   final value = doc.nodes.last as ParagraphNode;
          //   print(value.metadata);
          //   final start = value.beginningPosition.offset;
          //   final end = value.endPosition.offset;
          //   final attributions =
          //       value.text.getAllAttributionsThroughout(SpanRange(
          //     start: start,
          //     end: end,
          //   ));
          //   final spanRanges = value.text.getAttributionSpansInRange(
          //       attributionFilter: (_) => true,
          //       range: SpanRange(
          //         start: start,
          //         end: end,
          //       ));
          //   print("SPAN RANGES WITH ATTRIBUTIONS:: $spanRanges");
          //   print("SPaN MARKER:: $attributions");
          // }

          // if (doc.nodes.last is ListItemNode) {
          //   final value = doc.nodes.last as ListItemNode;
          //   print(value.metadata);
          //   final start = value.beginningPosition.offset;
          //   final end = value.endPosition.offset;
          //   final attributions =
          //       value.text.getAllAttributionsThroughout(SpanRange(
          //     start: start,
          //     end: end,
          //   ));
          //   final spanRanges = value.text.getAttributionSpansInRange(
          //       attributionFilter: (_) => true,
          //       range: SpanRange(
          //         start: start,
          //         end: end,
          //       ));
          //   print("SPAN RANGES WITH FOR LISTITEM ATTRIBUTIONS:: $spanRanges");
          //   print("SPAN MARKER FOR LISTITEM:: $attributions");
          // }

          // print("JSON DECORATION HOLDER ${AttributionHolder.toJsonList()}");
          // _documentEditor.document.nodes.last.
          //update the tool bar display
          _updateToolbarDisplay();
          //set the command
          ExecuteCommand(
            restoreFocus: () {
              _editorFocusNode.requestFocus();
            },
            anchor: _selectionAnchor,
            context: context,
            updateToolbarOffset: () {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                _selectionAnchor.value = _updateToolbarOffset();
              });
            },
            composer: _composer,
            editor: _documentEditor,
            mutableDoc: doc,
          ).startCommandBasedActions();

          //update the doc
          _isSaving.value = true;
          await Future.delayed(const Duration(milliseconds: 2000), () async {
            await prefs?.setString(PrefsKey.docData,
                jsonEncode(DocumentJsonParser(_doc).toJson(_doc.nodes)));
            _isSaving.value = false;
          });
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
      _composer = DocumentComposer()..addListener(_updateToolbarDisplay);

      // Create a FocusNode so that we can explicitly toggle editor focus.
      _editorFocusNode = FocusNode();

      // Use our own ScrollController for the editor so that we can refresh
      // our popup toolbar position as the user scrolls the editor.
      _scrollController = ScrollController()
        ..addListener(_updateToolbarDisplay);

      docOps = CommonEditorOperations(
        editor: _documentEditor,
        composer: _composer,
        documentLayoutResolver: () =>
            _docLayoutKey.currentState as DocumentLayout,
      );

      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _formatBarOverlayEntry?.remove();
    _doc.dispose();
    _scrollController.dispose();
    _editorFocusNode.dispose();
    _composer.dispose();
    prefs?.remove(PrefsKey.docData);
    super.dispose();
  }

  //update toolbar display
  void _updateToolbarDisplay() {
    final selection = _composer.selection;
    //if the selection is null then don't show the toolbar
    if (selection == null) {
      _hideEditorToolbar();
      _hideImageEditorToolBar();
      return;
    }
    //if it is selected with more than one node then don't show the toolbar
    if (selection.base.nodeId != selection.extent.nodeId) {
      final selectedNode = _doc.getNodeById(selection.extent.nodeId);
      if (selectedNode is TextNode) {
        return;
      }
      _hideEditorToolbar();
      _hideImageEditorToolBar();
      return;
    }
    //we only want to show the toolbar when a span of text
    //is selected. therefore, we ignore collapsed selections
    if (selection.isCollapsed) {
      _hideEditorToolbar();
      _hideImageEditorToolBar();
      return;
    }

    final selectedNode = _doc.getNodeById(selection.extent.nodeId);

    //if the given node is image
    if (selectedNode is ImageNode) {
      _showImageEditorToolbar();
      _hideEditorToolbar();
      return;
    } else {
      _hideImageEditorToolBar();
    }

    //if the given node is text
    if (selectedNode is TextNode) {
      // The currently selected content is not a paragraph. We don't
      // want to show a toolbar in this case.
      _showEditorToolbar();
      _hideImageEditorToolBar();
      return;
    } else {
      _hideEditorToolbar();
    }

    // if (_formatBarOverlayEntry == null) {
    //   // Show the editor's toolbar for text styling.
    //   _showEditorToolbar();
    // } else {
    //   _updateToolbarOffset();
    // }
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
        if (_formatBarOverlayEntry == null) {
          return;
        }
        _selectionAnchor.value = _updateToolbarOffset();
      });
    }
  }

  Offset _updateToolbarOffset() {
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
    return offset;
  }

  ///this methods used to display the image editor
  ///to edit the image for e.g. marker, croper, overlaytext, replace,
  void _showImageEditorToolbar() {
    if (_imageFormatBarOverlayEntry == null) {
      _imageFormatBarOverlayEntry = OverlayEntry(builder: (context) {
        return ImageEditorToolbar(
          anchor: _imageSelectionAnchor,
          composer: _composer,
          editor: _documentEditor,
          setWidth: (nodeId, width) {
            //get the image node
            final imageNode = _documentEditor.document.getNodeById(nodeId);
            imageNode!.putMetadataValue("is_infinity", true);
            final currentStyles =
                SingleColumnLayoutComponentStyles.fromMetadata(imageNode);
            //apply the styles
            SingleColumnLayoutComponentStyles(
              width: width,
              padding: currentStyles.padding,
            ).applyTo(imageNode);
          },
          closeToolbar: _hideImageEditorToolBar,
        );
      });

      final overlay = Overlay.of(context);
      overlay!.insert(_imageFormatBarOverlayEntry!);

      // Schedule a callback after this frame to locate the selection
      // bounds on the screen and display the toolbar near the selected
      // text.
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _updateImageToolbarOffset();
      });
    }
  }

  void _updateImageToolbarOffset() {
    if (_imageFormatBarOverlayEntry == null) {
      return;
    }

    //get selected doc bound box
    final docBoundingBox =
        (_docLayoutKey.currentState! as DocumentLayout).getRectForSelection(
      _composer.selection!.base,
      _composer.selection!.extent,
    );
    //get the doc render box
    final docBound =
        _docLayoutKey.currentContext!.findRenderObject() as RenderBox;
    final overBoundingBox = Rect.fromPoints(
      docBound.localToGlobal(docBoundingBox!.topLeft),
      docBound.localToGlobal(docBoundingBox.bottomRight),
    );

    _imageSelectionAnchor.value = overBoundingBox.center;
  }

  void _hideImageEditorToolBar() {
    //if the selection anchor is not null
    //then set it to the null
    _imageSelectionAnchor.value = null;

    if (_imageFormatBarOverlayEntry != null) {
      //remove the toolbar oevrlay and null-out the entry
      //we null out the entry because we can't query whether
      //or not the entry exists in the overlay, so in our case
      //null implies the entry is not in the overlay, and non-null implies
      //the entry is in the overlay
      _imageFormatBarOverlayEntry!.remove();
      _imageFormatBarOverlayEntry = null;
    }

    //ensure that focus returns to the editor
    _editorFocusNode.requestFocus();
  }

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

  Future<void> saveTheBlog(BlogType type, User user) async {
    try {
      _isSaving.value = true;
      final json = DocumentJsonParser(_doc).toJson(_doc.nodes);
      final blogjson = DocumentJsonParser(_doc).getTitleDescription(_doc.nodes);
      await Provider.of<BlogProvider>(context, listen: false).saveBlog(
        type,
        blogInfo: Blog(
          id: widget.blog != null
              ? widget.blog!.id
              : DocumentEditor.createNodeId(),
          userId: widget.blog != null ? widget.blog!.userId : user.id,
          category: Category(
            id: "",
            label: "Article",
            description: "",
            image: UploadOutput(
              fileName: "",
              generatedUri: "",
            ),
            catEnum: Cat.books,
          ),
          title: blogjson["title"],
          description: blogjson["description"],
          coverImage: blogjson["image_uri"],
          tags: blogjson["tags"],
          createdAt:
              widget.blog != null ? widget.blog!.createdAt : Timestamp.now(),
          updatedAt: Timestamp.now(),
        ),
        json: json,
      );
      Navigator.of(context).pushReplacementNamed(ProfilePage.routeName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      _isSaving.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Scaffold(
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _isSaving,
        builder: (context, value, child) => FloatingActionButton(
          onPressed: () async {
            //if the blog is available
            if (widget.blog != null) {
              await saveTheBlog(widget.blogType!, user!);
              return;
            }
            IndicatorWidget.showCreateBlogModal(
              context,
              child: SaveBlogPopUpModalWidget(
                onSave: (type) async {
                  Navigator.pop;
                  saveTheBlog(type, user!);
                },
              ),
            );
          },
          child: value
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
        ),
      ),
      body: _isLoading
          ? Scaffold(
              body: Center(
                child: Lottie.asset(
                  "assets/json/home-loading.json",
                  repeat: true,
                ),
              ),
            )
          : DropViewerWidget(
              onDrop: _onDropImage,
              child: SuperEditor(
                composer: _composer,
                focusNode: _editorFocusNode,
                documentLayoutKey: _docLayoutKey,
                editor: _documentEditor,
                selectionStyle: SelectionStyles(
                  selectionColor: ColorTheme.primaryColor.shade200,
                ),
                keyboardActions: <DocumentKeyboardAction>[
                  backspaceToUnIndentCheckboxItem,
                  ...defaultKeyboardActions,
                  tabToIndentCheckboxItem,
                  shiftTabToUnIndentCheckbox,
                  splitCheckboxItemWhenEnterPressed,
                  enterToInsertBlockNewlineForCheckbox,
                  saveDocument,
                ],
                componentBuilders: [
                  ...defaultComponentBuilders,
                  CheckBoxComponentBuilder(_documentEditor),
                ],
                stylesheet: defaultStylesheet.copyWith(
                  addRulesAfter: [
                    ...initialLayout(),
                    ...headers(context),
                    ...nodeStyles(),
                  ],
                  inlineTextStyler: inlinetextStyle,
                ),
              ),
            ),
    );
  }
}

ExecutionInstruction saveDocument({
  required EditContext editContext,
  required RawKeyEvent keyEvent,
}) {
  if (keyEvent.logicalKey != LogicalKeyboardKey.save) {
    return ExecutionInstruction.continueExecution;
  }

  print("CTRL++SAVE");
  return false
      ? ExecutionInstruction.haltExecution
      : ExecutionInstruction.continueExecution;
}
