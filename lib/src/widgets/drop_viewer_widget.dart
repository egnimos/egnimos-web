import 'package:dotted_border/dotted_border.dart';
import 'package:egnimos/src/config/responsive.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:google_fonts/google_fonts.dart';

class DropViewerWidget extends StatefulWidget {
  final Widget child;
  final void Function(String uri) onDrop;
  const DropViewerWidget({
    required this.child,
    required this.onDrop,
    Key? key,
  }) : super(key: key);

  @override
  State<DropViewerWidget> createState() => _DropViewerWidgetState();
}

class _DropViewerWidgetState extends State<DropViewerWidget> {
  late DropzoneViewController _controller;
  bool _highlight = false;

  Widget _dropAction() {
    return DropzoneView(
      operation: DragOperation.copy,
      // cursor: CursorType.text,
      onCreated: (DropzoneViewController ctrl) => _controller = ctrl,
      onLoaded: () => print('Zone 1 loaded'),
      onError: (ev) {
        setState(() => _highlight = false);
        print('Zone 1 error: $ev');
      },
      onHover: () {
        setState(() => _highlight = true);
        print('Zone 1 hovered');
      },
      onLeave: () {
        setState(() => _highlight = false);
        print('Zone 1 left');
      },
      onDrop: (ev) async {
        print('Zone 1 drop: ${ev.name}');
        setState(() {
          // final message = '${ev.name} dropped';
          _highlight = false;
        });
        print('${ev.name} dropped');
        final bytes = await _controller.getFileData(ev);
        print(bytes.sublist(0, 20));
        widget.onDrop(await _controller.createFileUrl(ev));
      },
      onDropMultiple: (ev) async {
        print('Zone 1 drop multiple: $ev');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(Responsive.heightMultiplier * 100.0);
    print(Responsive.widthMultiplier * 100.0);
    return Stack(
      children: [
        //drop action widget
        _dropAction(),
        // else
        //   //child
        widget.child,

        //tools
        Positioned(
          right: 0.0,
          top: (Responsive.heightMultiplier * 50.0) - 150.0,
          child: Container(
            width: 80.0,
            height: 300.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 30,
                  spreadRadius: -5,
                  offset: const Offset(0, 10),
                )
              ],
              color: ColorTheme.secondaryTextColor,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 18.0,
                ),
                //file collection
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.collections,
                    color: Colors.grey.shade800,
                    size: 40.0,
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                ),
                Divider(
                  height: 10.0,
                  color: Colors.grey.shade800,
                ),
                //save
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.save,
                    color: Colors.grey.shade800,
                    size: 40.0,
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                ),
                Divider(
                  height: 10.0,
                  color: Colors.grey.shade800,
                ),
                //layout
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.design_services,
                    color: Colors.grey.shade800,
                    size: 40.0,
                  ),
                ),
              ],
            ),
          ),
        ),

        //show indicator
        if (_highlight)
          Container(
            width: Responsive.widthMultiplier * 100.0,
            height: Responsive.heightMultiplier * 100.0,
            color: Colors.white70,
            padding: const EdgeInsets.all(40.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //image
                Image.asset(
                  'assets/images/png/drag_drop.png',
                  width: 200,
                  height: 200,
                ),

                //drag image here statement
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Drag image here",
                    style: GoogleFonts.rubik(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
