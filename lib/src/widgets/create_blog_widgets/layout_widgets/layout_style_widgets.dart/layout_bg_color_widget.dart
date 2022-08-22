import 'package:egnimos/src/widgets/create_blog_widgets/layout_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/responsive.dart';

class LayoutBgColorWidget extends StatefulWidget {
  final void Function(Color wallpaperColor) output;
  const LayoutBgColorWidget({
    Key? key,
    required this.output,
  }) : super(key: key);

  @override
  State<LayoutBgColorWidget> createState() => _LayoutBgColorWidgetState();
}

class _LayoutBgColorWidgetState extends State<LayoutBgColorWidget> {
  final layoutColor = ValueNotifier<Color>(Colors.white);
  final showLayoutColorBox = ValueNotifier<bool>(false);

  Widget displayColorBox(Color color, VoidCallback onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 70.0,
        height: 70.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    layoutColor.value = layoutStyler.value.layoutColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //heading
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Layout Color",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontSize: 18.0,
            ),
          ),
        ),

        //set color box
        ValueListenableBuilder<Color>(
            valueListenable: layoutColor,
            builder: (context, color, __) {
              return displayColorBox(
                color,
                () {
                  showLayoutColorBox.value = !showLayoutColorBox.value;
                },
              );
            }),

        const SizedBox(
          height: 20.0,
        ),
        //display  color box
        ValueListenableBuilder<bool>(
            valueListenable: showLayoutColorBox,
            builder: (context, showBox, __) {
              return showBox
                  ? SizedBox(
                      width: Responsive.widthMultiplier * 25.0,
                      height: 200.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ColorPicker(
                          pickerColor: layoutColor.value,
                          onColorChanged: (color) {
                            layoutColor.value = color;
                            widget.output(color);
                          },
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
      ],
    );
  }
}
