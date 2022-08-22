import 'package:egnimos/src/config/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/color_theme.dart';

final decorations = <TextDecoration>[
  TextDecoration.lineThrough,
  TextDecoration.overline,
  TextDecoration.none,
  TextDecoration.underline,
];

class FontDecorationWidget extends StatefulWidget {
  final TextStyle textStyle;
  final void Function({
    double decorationThickness,
    TextDecorationStyle decorationStyle,
    Color decorationColor,
    TextDecoration textDecoration,
  }) output;
  const FontDecorationWidget({
    Key? key,
    required this.textStyle,
    required this.output,
  }) : super(key: key);

  @override
  State<FontDecorationWidget> createState() => _FontDecorationWidgetState();
}

class _FontDecorationWidgetState extends State<FontDecorationWidget> {
  final _thicknessController = TextEditingController();
  final _selectedDecorationStyle =
      ValueNotifier<TextDecorationStyle>(TextDecorationStyle.solid);
  final decorationColor = ValueNotifier<Color>(Colors.black);
  final showDecorationColorBox = ValueNotifier<bool>(false);
  final selectedDecoration = ValueNotifier<TextDecoration>(TextDecoration.none);

  // @override
  // void initState() {
  //   super.initState();
  //   _thicknessController.text =
  //       (widget.textStyle.decorationThickness ?? 1.0).toString();
  //   _selectedDecorationStyle.value =
  //       widget.textStyle.decorationStyle ?? TextDecorationStyle.solid;
  //   decorationColor.value = widget.textStyle.decorationColor ?? Colors.black;
  //   // setState(() {});
  // }

  void initialize() {
    _thicknessController.text =
        (widget.textStyle.decorationThickness ?? 1.0).toString();
    _selectedDecorationStyle.value =
        widget.textStyle.decorationStyle ?? TextDecorationStyle.solid;
    decorationColor.value = widget.textStyle.decorationColor ?? Colors.black;
  }

  Widget decorationThicknessWidget() {
    return Row(
      children: [
        //INCREMENT FONT SIZE BUTTON
        IconButton(
          onPressed: () {
            final initialthickness = num.parse(_thicknessController.text);
            final updatedThickness = initialthickness + 1;
            _thicknessController.value = TextEditingValue(
              text: updatedThickness.toString(),
            );
            widget.output(
              decorationColor: decorationColor.value,
              decorationStyle: _selectedDecorationStyle.value,
              decorationThickness: double.parse(_thicknessController.text),
              textDecoration: selectedDecoration.value,
            );
          },
          icon: const Icon(Icons.add_rounded),
          splashRadius: 16,
          tooltip: 'increase decoration thickness by one',
        ),

        SizedBox(
          width: 140.0,
          height: 40.0,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _thicknessController,
                  style: GoogleFonts.rubik(
                    color: ColorTheme.primaryTextColor,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                  onChanged: (thickness) {
                    widget.output(
                      decorationColor: decorationColor.value,
                      decorationStyle: _selectedDecorationStyle.value,
                      decorationThickness:
                          double.parse(_thicknessController.text),
                      textDecoration: selectedDecoration.value,
                    );
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      top: 14.0,
                      left: 8.0,
                    ),
                    hintText: "thickness...",
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

        //DECREMENT THE FONT SIZE
        IconButton(
          onPressed: () {
            final initialthickness = num.parse(_thicknessController.text);
            if (initialthickness > 0) {
              final updatedThickness = initialthickness - 1;
              _thicknessController.value = TextEditingValue(
                text: updatedThickness.toString(),
              );
              widget.output(
                decorationColor: decorationColor.value,
                decorationStyle: _selectedDecorationStyle.value,
                decorationThickness: double.parse(_thicknessController.text),
                textDecoration: selectedDecoration.value,
              );
            }
          },
          icon: Transform.translate(
            offset: const Offset(0.0, -10.0),
            child: const Icon(Icons.minimize_rounded),
          ),
          splashRadius: 16,
          tooltip: 'decrement decoration thickness by one',
        ),
      ],
    );
  }

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

  Widget addDecorationRadioButton(
    TextDecoration decoration,
    String title,
  ) {
    return ValueListenableBuilder<TextDecoration>(
      valueListenable: selectedDecoration,
      builder: (context, ted, __) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Radio<TextDecoration>(
            hoverColor: ColorTheme.primaryColor.shade50,
            activeColor: ColorTheme.primaryColor,
            focusColor: ColorTheme.primaryColor,
            value: decoration,
            groupValue: selectedDecoration.value,
            onChanged: (val) {
              selectedDecoration.value = val!;
              widget.output(
                decorationColor: decorationColor.value,
                decorationStyle: _selectedDecorationStyle.value,
                decorationThickness: double.parse(_thicknessController.text),
                textDecoration: selectedDecoration.value,
              );
            },
          ),
          Text(
            title,
            style: GoogleFonts.rubik(
              fontSize: 18.5,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget decorationWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: decorations
            .map(
              (e) => addDecorationRadioButton(e, e.toString().split(".")[1]),
            )
            .toList(),
      ),
    );
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
            "Font Decoration",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontSize: 20.0,
            ),
          ),
        ),

        const SizedBox(
          height: 16.0,
        ),

        ///text decoration
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Text Decorations",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ),

        decorationWidget(),
        const SizedBox(
          height: 10.0,
        ),

        //decoration thickness
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Decoration Thickness",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ),

        decorationThicknessWidget(),

        const SizedBox(
          height: 10.0,
        ),

        //decoration style
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Decoration Thickness",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ),

        ...TextDecorationStyle.values
            .map(
              (e) => ValueListenableBuilder<TextDecorationStyle>(
                  valueListenable: _selectedDecorationStyle,
                  builder: (context, style, __) {
                    return CheckboxListTile(
                      title: Text(e.name),
                      value: style == e,
                      onChanged: (val) {
                        _selectedDecorationStyle.value = e;
                        widget.output(
                          decorationColor: decorationColor.value,
                          decorationStyle: _selectedDecorationStyle.value,
                          decorationThickness:
                              double.parse(_thicknessController.text),
                          textDecoration: selectedDecoration.value,
                        );
                      },
                    );
                  }),
            )
            .toList(),

        const SizedBox(
          height: 10.0,
        ),

        //decoration color
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Decoration Color",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ),

        //set color box
        ValueListenableBuilder<Color>(
            valueListenable: decorationColor,
            builder: (context, color, __) {
              return displayColorBox(
                color,
                () {
                  showDecorationColorBox.value = !showDecorationColorBox.value;
                },
              );
            }),

        const SizedBox(
          height: 20.0,
        ),
        //display  color box
        ValueListenableBuilder<bool>(
            valueListenable: showDecorationColorBox,
            builder: (context, showBox, __) {
              return showBox
                  ? SizedBox(
                      width: Responsive.widthMultiplier * 25.0,
                      height: 200.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ColorPicker(
                          pickerColor: decorationColor.value,
                          onColorChanged: (color) {
                            decorationColor.value = color;
                            widget.output(
                              decorationColor: color,
                              decorationStyle: _selectedDecorationStyle.value,
                              decorationThickness:
                                  double.parse(_thicknessController.text),
                              textDecoration: selectedDecoration.value,
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
