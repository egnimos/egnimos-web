import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontWeightWidget extends StatelessWidget {
  final TextStyle textStyle;
  final void Function(FontWeight weight) output;
  const FontWeightWidget({
    Key? key,
    required this.output,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontWeight =
        ValueNotifier<FontWeight>(textStyle.fontWeight ?? FontWeight.normal);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //heading
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Font Weight",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontSize: 18.0,
            ),
          ),
        ),
        //weight
        ValueListenableBuilder<FontWeight>(
            valueListenable: fontWeight,
            builder: (context, value, __) {
              return Tooltip(
                message: 'Choose font weight',
                child: DropdownButton<FontWeight>(
                  value: value,
                  items: FontWeight.values
                      .map(
                        (weight) => DropdownMenuItem<FontWeight>(
                          value: weight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                                weight.toString().split(".")[1].substring(1)),
                          ),
                        ),
                      )
                      .toList(),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                  underline: const SizedBox(),
                  elevation: 0,
                  onChanged: (value) {
                    fontWeight.value = value!;
                    output(value);
                  },
                ),
              );
            }),
      ],
    );
  }
}
