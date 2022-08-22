import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontStyleWidget extends StatefulWidget {
  final TextStyle textStyle;
  final void Function(FontStyle style) output;
  const FontStyleWidget({
    Key? key,
    required this.textStyle,
    required this.output,
  }) : super(key: key);

  @override
  State<FontStyleWidget> createState() => _FontStyleWidgetState();
}

class _FontStyleWidgetState extends State<FontStyleWidget> {
  final selectedFontStyle = ValueNotifier<FontStyle>(FontStyle.normal);

  // @override
  // void initState() {
  //   super.initState();
  //   selectedFontStyle.value = widget.textStyle.fontStyle ?? FontStyle.normal;
  // }

  @override
  Widget build(BuildContext context) {
    selectedFontStyle.value = widget.textStyle.fontStyle ?? FontStyle.normal;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //heading
      Padding(
        padding: const EdgeInsets.all(
          10.0,
        ),
        child: Text(
          "Font Style",
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            fontSize: 18.0,
          ),
        ),
      ),

      //font style
      ...FontStyle.values
          .map(
            (e) => ValueListenableBuilder(
                valueListenable: selectedFontStyle,
                builder: (context, style, __) {
                  return CheckboxListTile(
                    title: Text(e.name),
                    value: style == e,
                    onChanged: (val) {
                      selectedFontStyle.value = e;
                      widget.output(selectedFontStyle.value);
                    },
                  );
                }),
          )
          .toList(),
    ]);
  }
}
