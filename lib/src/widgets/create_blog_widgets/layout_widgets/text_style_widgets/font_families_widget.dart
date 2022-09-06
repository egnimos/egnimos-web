import 'package:dropdown_search/dropdown_search.dart';
import 'package:egnimos/src/models/style_models/text_style_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final fontFamilyInfo = FontFamily(
  fontFamilyName: "Open Sans",
  selectedFontFamily: "OpenSans_regular",
);

// final headingFontFamily = FontFamily(
//   fontFamilyName: 'Raleway',
//   selectedFontFamily: 'Raleway_regular',
// );

class FontFamilyWidget extends StatefulWidget {
  final FontFamily fntFamily;
  final void Function(FontFamily family) output;
  const FontFamilyWidget({
    Key? key,
    required this.output,
    required this.fntFamily,
  }) : super(key: key);

  @override
  State<FontFamilyWidget> createState() => _FontFamilyWidgetState();
}

class _FontFamilyWidgetState extends State<FontFamilyWidget> {
  final selectedFonFamily = ValueNotifier<FontFamily>(fontFamilyInfo);
  @override
  Widget build(BuildContext context) {
    selectedFonFamily.value = widget.fntFamily;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //font familiy heading
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Font Families",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontSize: 18.0,
            ),
          ),
        ),

        const SizedBox(
          height: 16.0,
        ),

        //drop down search
        ValueListenableBuilder<FontFamily>(
            valueListenable: selectedFonFamily,
            builder: (context, value, __) {
              return DropdownSearch<String>(
                clearButtonProps: const ClearButtonProps(isVisible: true),
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                ),
                items: GoogleFonts.asMap().keys.toList(),
                onChanged: (val) {
                  final styleInfo = GoogleFonts.asMap()[val]?.call();
                  selectedFonFamily.value = FontFamily(
                    fontFamilyName: val ?? "",
                    selectedFontFamily: styleInfo?.fontFamily ?? "",
                  );
                  widget.output(selectedFonFamily.value);
                },
                selectedItem: value.fontFamilyName,
                validator: (String? item) {
                  if (item == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
              );
            }),
      ],
    );
  }
}
