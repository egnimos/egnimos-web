import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/responsive.dart';

class FontColorWidget extends StatefulWidget {
  final TextStyle textStyle;
  final void Function({Color fontColor, Color backgroundColor}) output;
  const FontColorWidget({
    Key? key,
    required this.textStyle,
    required this.output,
  }) : super(key: key);

  @override
  State<FontColorWidget> createState() => _FontColorWidgetState();
}

class _FontColorWidgetState extends State<FontColorWidget> {
  final fontColor = ValueNotifier<Color>(Colors.black);
  final backgroundColor = ValueNotifier<Color>(Colors.transparent);
  final showFontColorBox = ValueNotifier<bool>(false);
  final showBackgroundColorBox = ValueNotifier<bool>(false);

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
          border: Border.all(color: Colors.grey.shade100),
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   fontColor.value = widget.textStyle.color ?? Colors.black;
  //   backgroundColor.value = widget.textStyle.color ?? Colors.black;
  // }

  void initialize() {
    fontColor.value = widget.textStyle.color ?? Colors.black;
    backgroundColor.value = widget.textStyle.color ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    initialize();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Font Color heading
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Font Color",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontSize: 18.0,
            ),
          ),
        ),

        //set color box
        ValueListenableBuilder<Color>(
            valueListenable: fontColor,
            builder: (context, color, __) {
              return displayColorBox(
                color,
                () {
                  showFontColorBox.value = !showFontColorBox.value;
                },
              );
            }),
        const SizedBox(
          height: 10.0,
        ),
        //display  color box
        ValueListenableBuilder<bool>(
            valueListenable: showFontColorBox,
            builder: (context, showBox, __) {
              return showBox
                  ? SizedBox(
                      width: Responsive.widthMultiplier * 25.0,
                      height: 200.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ColorPicker(
                          pickerColor: fontColor.value,
                          onColorChanged: (color) {
                            fontColor.value = color;
                            widget.output(
                              fontColor: color,
                              backgroundColor: backgroundColor.value,
                            );
                          },
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),

        //Font Background Color heading
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Background Color",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontSize: 18.0,
            ),
          ),
        ),
        //set color box
        ValueListenableBuilder<Color>(
            valueListenable: backgroundColor,
            builder: (context, color, __) {
              return displayColorBox(
                color,
                () {
                  showBackgroundColorBox.value = !showBackgroundColorBox.value;
                },
              );
            }),

        const SizedBox(
          height: 10.0,
        ),
        //display  color box
        ValueListenableBuilder<bool>(
            valueListenable: showBackgroundColorBox,
            builder: (context, showBox, __) {
              return showBox
                  ? SizedBox(
                      width: Responsive.widthMultiplier * 25.0,
                      height: 200.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ColorPicker(
                          pickerColor: backgroundColor.value,
                          onColorChanged: (color) {
                            backgroundColor.value = color;
                            widget.output(
                              fontColor: fontColor.value,
                              backgroundColor: color,
                            );
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
