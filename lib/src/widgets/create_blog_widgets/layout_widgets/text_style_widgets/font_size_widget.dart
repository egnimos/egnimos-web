import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/color_theme.dart';

class FontSizeWidget extends StatefulWidget {
  final TextStyle textStyle;
  final void Function(double size) output;
  const FontSizeWidget({
    Key? key,
    required this.textStyle,
    required this.output,
  }) : super(key: key);

  @override
  State<FontSizeWidget> createState() => _FontSizeWidgetState();
}

class _FontSizeWidgetState extends State<FontSizeWidget> {
  final _fontSizeController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   _fontSizeController.text = (widget.textStyle.fontSize ?? 18.0).toString();
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    _fontSizeController.text = (widget.textStyle.fontSize ?? 18.0).toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Font Size heading
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Font Size",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontSize: 18.0,
            ),
          ),
        ),
        //Font Size
        Row(
          children: [
            //INCREMENT FONT SIZE BUTTON
            IconButton(
              onPressed: () {
                final initialFontSize = double.parse(_fontSizeController.text);
                final updatedFontSize = initialFontSize + 1;
                _fontSizeController.value = TextEditingValue(
                  text: updatedFontSize.toString(),
                );
                widget.output(updatedFontSize);
              },
              icon: const Icon(Icons.add_rounded),
              splashRadius: 16,
              tooltip: 'increase font size by one',
            ),

            SizedBox(
              width: 180.0,
              height: 30.0,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _fontSizeController,
                      style: GoogleFonts.rubik(
                        color: ColorTheme.primaryTextColor,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      onChanged: (updatedFontSize) {
                        widget.output(double.parse(updatedFontSize));
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          top: 14.0,
                          left: 8.0,
                        ),
                        hintText: "font size",
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
                final initialFontSize = double.parse(_fontSizeController.text);
                if (initialFontSize > 0) {
                  final updatedFontSize = initialFontSize - 1;
                  _fontSizeController.value = TextEditingValue(
                    text: updatedFontSize.toString(),
                  );
                  widget.output(updatedFontSize);
                }
              },
              icon: Transform.translate(
                offset: const Offset(0.0, -10.0),
                child: const Icon(Icons.minimize_rounded),
              ),
              splashRadius: 16,
              tooltip: 'decrement font size by one',
            ),
          ],
        ),
      ],
    );
  }
}
