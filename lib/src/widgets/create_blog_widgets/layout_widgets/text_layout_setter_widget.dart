import 'package:egnimos/src/models/style_models/text_style_model.dart';
import 'package:egnimos/src/pages/write_blog_pages/named_attributions.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/default_text_styles.dart';
import 'package:egnimos/src/widgets/create_blog_widgets/layout_option_widget.dart';
import 'package:egnimos/src/widgets/create_blog_widgets/layout_widgets/text_style_widgets/font_color_widget.dart';
import 'package:egnimos/src/widgets/create_blog_widgets/layout_widgets/text_style_widgets/font_decoration_widget.dart';
import 'package:egnimos/src/widgets/create_blog_widgets/layout_widgets/text_style_widgets/font_size_widget.dart';
import 'package:egnimos/src/widgets/create_blog_widgets/layout_widgets/text_style_widgets/font_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_editor/super_editor.dart';
import '../../../utility/enum.dart';
import 'text_style_widgets/font_weight_widget.dart';

class TextLayoutSetter extends StatelessWidget {
  final String blockHeading;
  final TextStyle textStyle;
  final Function(TextStyleModel model) styleModel;
  const TextLayoutSetter({
    Key? key,
    required this.textStyle,
    required this.blockHeading,
    required this.styleModel,
  }) : super(key: key);

  Widget spaceWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 15.0,
        ),
        Divider(
          color: Colors.grey.shade700,
          thickness: 1.1,
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textType = ValueNotifier<TextTypes>(TextTypes.header1);
    final textStyle = ValueNotifier<TextStyle>(h1TextStyle);
    textStyle.value = getTextStyleBasedOnTextType(textType.value);
    //get the text style model if it is there
    TextStyleModel textStyleModel = TextStyleModel(
      blockId: getId(textType.value),
      fontSize: textStyle.value.fontSize,
      fontStyle: textStyle.value.fontStyle,
      fontColor: textStyle.value.color,
      backgroundColor: textStyle.value.backgroundColor,
      textDecorationStyle: textStyle.value.decorationStyle,
      textDecorationThickness: textStyle.value.decorationThickness,
      textDecorationColor: textStyle.value.decorationColor,
      letterSpacing: textStyle.value.letterSpacing,
      fontWeight: textStyle.value.fontWeight,
      wordSpacing: textStyle.value.wordSpacing,
      textDecoration: textStyle.value.decoration,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Block Heading
        ValueListenableBuilder<TextTypes>(
            valueListenable: textType,
            builder: (context, value, __) {
              return Tooltip(
                message: 'Choose Text type',
                child: DropdownButton<TextTypes>(
                  value: value,
                  items: TextTypes.values
                      .map(
                        (textType) => DropdownMenuItem<TextTypes>(
                          value: textType,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(textType.name.toUpperCase()[0] +
                                textType.name.substring(1)),
                          ),
                        ),
                      )
                      .toList(),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                    fontSize: 22.0,
                  ),
                  underline: const SizedBox(),
                  elevation: 0,
                  onChanged: (value) {
                    textType.value = value!;
                    final blockId = getId(value);
                    // final values = stylers.value.where(
                    //   (e) => e.blockId == blockId,
                    // );
                    // final initialTextStyleMode =
                    //     values.isEmpty ? textStyle : values.first;
                    // textStyleModel
                    textStyle.value = getTextStyleBasedOnTextType(value);
                    textStyleModel = TextStyleModel(
                      blockId: blockId,
                      fontSize: textStyle.value.fontSize,
                      fontStyle: textStyle.value.fontStyle,
                      fontColor: textStyle.value.color,
                      backgroundColor: textStyle.value.backgroundColor,
                      textDecorationStyle: textStyle.value.decorationStyle,
                      textDecorationThickness:
                          textStyle.value.decorationThickness,
                      textDecorationColor: textStyle.value.decorationColor,
                      letterSpacing: textStyle.value.letterSpacing,
                      fontWeight: textStyle.value.fontWeight,
                      wordSpacing: textStyle.value.wordSpacing,
                      textDecoration: textStyleModel.textDecoration,
                    );
                    styleModel(textStyleModel);
                  },
                ),
              );
            }),

        //space widget
        spaceWidget(),

        //font Size widget
        ValueListenableBuilder<TextStyle>(
            valueListenable: textStyle,
            builder: (context, textStyle, __) {
              return FontSizeWidget(
                textStyle: textStyle,
                output: (size) {
                  textStyleModel = TextStyleModel(
                    blockId: textStyleModel.blockId,
                    fontSize: size,
                    fontStyle: textStyleModel.fontStyle,
                    fontColor: textStyleModel.fontColor,
                    backgroundColor: textStyleModel.backgroundColor,
                    textDecorationStyle: textStyleModel.textDecorationStyle,
                    textDecorationThickness:
                        textStyleModel.textDecorationThickness,
                    textDecorationColor: textStyleModel.textDecorationColor,
                    letterSpacing: textStyleModel.letterSpacing,
                    fontWeight: textStyleModel.fontWeight,
                    wordSpacing: textStyleModel.wordSpacing,
                    textDecoration: textStyleModel.textDecoration,
                  );
                  styleModel(textStyleModel);
                },
              );
            }),

        //space widget
        spaceWidget(),

        //font Size widget
        ValueListenableBuilder<TextStyle>(
            valueListenable: textStyle,
            builder: (context, textStyle, __) {
              return FontWeightWidget(
                textStyle: textStyle,
                output: (weight) {
                  textStyleModel = TextStyleModel(
                    blockId: textStyleModel.blockId,
                    fontSize: textStyleModel.fontSize,
                    fontStyle: textStyleModel.fontStyle,
                    fontColor: textStyleModel.fontColor,
                    backgroundColor: textStyleModel.backgroundColor,
                    textDecorationStyle: textStyleModel.textDecorationStyle,
                    textDecorationThickness:
                        textStyleModel.textDecorationThickness,
                    textDecorationColor: textStyleModel.textDecorationColor,
                    letterSpacing: textStyleModel.letterSpacing,
                    fontWeight: weight,
                    wordSpacing: textStyleModel.wordSpacing,
                    textDecoration: textStyleModel.textDecoration,
                  );
                  styleModel(textStyleModel);
                },
              );
            }),

        //space widget
        spaceWidget(),

        //font Style Widget
        ValueListenableBuilder<TextStyle>(
            valueListenable: textStyle,
            builder: (context, textStyle, __) {
              return FontStyleWidget(
                textStyle: textStyle,
                output: (style) {
                  textStyleModel = TextStyleModel(
                    blockId: textStyleModel.blockId,
                    fontSize: textStyleModel.fontSize,
                    fontStyle: style,
                    fontColor: textStyleModel.fontColor,
                    backgroundColor: textStyleModel.backgroundColor,
                    textDecorationStyle: textStyleModel.textDecorationStyle,
                    textDecorationThickness:
                        textStyleModel.textDecorationThickness,
                    textDecorationColor: textStyleModel.textDecorationColor,
                    letterSpacing: textStyleModel.letterSpacing,
                    fontWeight: textStyleModel.fontWeight,
                    wordSpacing: textStyleModel.wordSpacing,
                    textDecoration: textStyleModel.textDecoration,
                  );
                  styleModel(textStyleModel);
                },
              );
            }),

        //space widget
        spaceWidget(),

        //font Color & Background Widget
        ValueListenableBuilder<TextStyle>(
            valueListenable: textStyle,
            builder: (context, textStyle, __) {
              return FontColorWidget(
                textStyle: textStyle,
                output: ({Color? backgroundColor, Color? fontColor}) {
                  textStyleModel = TextStyleModel(
                    blockId: textStyleModel.blockId,
                    fontSize: textStyleModel.fontSize,
                    fontStyle: textStyleModel.fontStyle,
                    fontColor: fontColor,
                    backgroundColor: backgroundColor,
                    textDecorationStyle: textStyleModel.textDecorationStyle,
                    textDecorationThickness:
                        textStyleModel.textDecorationThickness,
                    textDecorationColor: textStyleModel.textDecorationColor,
                    letterSpacing: textStyleModel.letterSpacing,
                    fontWeight: textStyleModel.fontWeight,
                    wordSpacing: textStyleModel.wordSpacing,
                    textDecoration: textStyleModel.textDecoration,
                  );
                  styleModel(textStyleModel);
                },
              );
            }),

        //space widget
        spaceWidget(),

        //font Decoration
        ValueListenableBuilder<TextStyle>(
            valueListenable: textStyle,
            builder: (context, textStyle, __) {
              return FontDecorationWidget(
                textStyle: textStyle,
                output: ({
                  Color? decorationColor,
                  TextDecorationStyle? decorationStyle,
                  double? decorationThickness,
                  TextDecoration? textDecoration,
                }) {
                  textStyleModel = TextStyleModel(
                    blockId: textStyleModel.blockId,
                    fontSize: textStyleModel.fontSize,
                    fontStyle: textStyleModel.fontStyle,
                    fontColor: textStyleModel.fontColor,
                    backgroundColor: textStyleModel.backgroundColor,
                    textDecorationStyle: decorationStyle,
                    textDecorationThickness: decorationThickness,
                    textDecorationColor: decorationColor,
                    letterSpacing: textStyleModel.letterSpacing,
                    fontWeight: textStyleModel.fontWeight,
                    wordSpacing: textStyleModel.wordSpacing,
                    textDecoration: textDecoration,
                  );
                  styleModel(textStyleModel);
                },
              );
            }),

        //space widget
        spaceWidget(),

        //letter spacing
        //word spacing,
      ],
    );
  }
}
