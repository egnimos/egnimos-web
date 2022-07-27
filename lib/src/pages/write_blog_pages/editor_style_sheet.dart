import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_editor/super_editor.dart';

// The editor does not yet have an underline attribution and style by
// default. Until it does, we create our own attribution here and then
// we style the text ourselves in the "text style builders" that we
// provide to the Editor widget.

const paragraphAttribution = NamedAttribution('paragraph');

class EditorStyleSheet {
  final BuildContext context;
  final DocumentComposer composer;
  EditorStyleSheet(this.context, this.composer);

  static const underlineAttribution = NamedAttribution('underline');

  final TextStyle _baseTextStyle = GoogleFonts.rubik(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 27 / 18,
    color: const Color(0xFF003F51),
  );

  List<StyleRule> wideStyleSheet() {
    return [
      //all text style
      StyleRule(
        BlockSelector.all,
        (doc, docNode) => {
          'textStyle': _baseTextStyle,
        },
      ),

      //header4
      StyleRule(
        BlockSelector(header4Attribution.name),
        (doc, docNode) {
          return {
            'textStyle': Theme.of(context).textTheme.headline4!.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                )
          };
        },
      ),

      //header5
      StyleRule(
        BlockSelector(header5Attribution.name),
        (doc, docNode) {
          return {
            'textStyle': Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                )
          };
        },
      ),

      //header6
      StyleRule(
        BlockSelector(header6Attribution.name),
        (doc, docNode) {
          return {
            'textStyle': Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                )
          };
        },
      ),

      //block quote style
      StyleRule(
        BlockSelector(blockquoteAttribution.name),
        (doc, docNode) {
          return {
            'textStyle': _baseTextStyle.copyWith(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          };
        },
      ),
    ];
  }
}
