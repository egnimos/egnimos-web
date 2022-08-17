import 'package:egnimos/src/config/responsive.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

/// Small toolbar that is intended to display over an image and
/// offer controls to expand or contract the size of the image & edit image.
///
/// [ImageFormatToolbar] expects to be displayed in a [Stack] where it
/// will position itself based on the given [anchor]. This can be
/// accomplished, for example, by adding [ImageFormatToolbar] to the
/// application [Overlay]. Any other [Stack] should work, too.
class ImageEditorToolbar extends StatefulWidget {
  const ImageEditorToolbar({
    Key? key,
    required this.anchor,
    required this.composer,
    required this.editor,
    required this.setWidth,
    required this.closeToolbar,
  }) : super(key: key);

  /// The [composer] provides access to the user's current
  /// selection within the document, which dictates the
  /// content that is altered by the toolbar's options.
  final DocumentComposer composer;

  final DocumentEditor editor;

  /// [ImageEditorToolbar] displays itself horizontally centered and
  /// slightly above the given [anchor] value.
  ///
  /// [anchor] is a [ValueNotifier] so that [ImageEditorToolbar] can
  /// reposition itself as the [Offset] value changes.
  final ValueNotifier<Offset?> anchor;
  final VoidCallback closeToolbar;
  final void Function(String nodeId, double? width) setWidth;

  @override
  State<ImageEditorToolbar> createState() => _ImageEditorToolbarState();
}

class _ImageEditorToolbarState extends State<ImageEditorToolbar> {
  void _makeImageConfined() {
    widget.setWidth(widget.composer.selection!.extent.nodeId, null);
  }

  void _makeImageFullBleed() {
    widget.setWidth(
      widget.composer.selection!.extent.nodeId,
      Responsive.widthMultiplier * 100.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _PositionedToolbar(
      anchor: widget.anchor,
      composer: widget.composer,
      child: ValueListenableBuilder<DocumentSelection?>(
          valueListenable: widget.composer.selectionNotifier,
          builder: (context, selection, __) {
            if (selection == null) {
              return const SizedBox();
            }
            if (selection.extent.nodePosition
                is! UpstreamDownstreamNodePosition) {
              // The user selected non-image content. This toolbar is probably
              // about to disappear. Until then, build nothing, because the
              // toolbar needs to inspect selected image to build correctly.
              return const SizedBox();
            }
            return _buildToolbar();
          }),
    );
  }

  Widget _buildToolbar() {
    return Material(
      shape: const StadiumBorder(),
      elevation: 5,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: IconButton(
                  onPressed: _makeImageConfined,
                  icon: const Icon(Icons.photo_size_select_large),
                  splashRadius: 16,
                  tooltip: "confined",
                ),
              ),
              Center(
                child: IconButton(
                  onPressed: _makeImageFullBleed,
                  icon: const Icon(Icons.photo_size_select_actual),
                  splashRadius: 16,
                  tooltip: "full width",
                ),
              ),
              //edit image
              Center(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mode_edit_outline_rounded),
                  splashRadius: 16,
                  tooltip: "full width",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//positioned the toolbar based on offset
class _PositionedToolbar extends StatelessWidget {
  final ValueNotifier<Offset?> anchor;
  final DocumentComposer composer;
  final Widget child;

  const _PositionedToolbar({
    required this.anchor,
    required this.composer,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset?>(
        valueListenable: anchor,
        builder: (context, offset, __) {
          //if the given anchor or selection is null display nothing
          if (offset == null || composer.selection == null) {
            return const SizedBox.shrink();
          }

          //display the positioned toolbar
          return SizedBox.expand(
            child: Stack(
              children: [
                //editor display
                Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, -1.4),
                    child: child,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
