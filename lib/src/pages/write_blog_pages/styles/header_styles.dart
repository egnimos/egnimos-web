import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_editor/super_editor.dart';

typedef StyleRules = List<StyleRule>;
const Color textColor = Color(0xFF333333);

StyleRules headers(BuildContext context) => [
      StyleRule(
        BlockSelector(header1Attribution.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.only(top: 40),
            "textStyle": Theme.of(context).textTheme.headline1!.copyWith(
                  color: textColor,
                  fontSize: 60.0,
                  fontWeight: FontWeight.w800,
                ),
          };
        },
      ),
      StyleRule(
        BlockSelector(header2Attribution.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.only(top: 32),
            "textStyle": Theme.of(context).textTheme.headline2!.copyWith(
                  color: textColor,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
          };
        },
      ),
      StyleRule(
        BlockSelector(header3Attribution.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.only(top: 28),
            "textStyle": Theme.of(context).textTheme.headline3!.copyWith(
                  color: textColor,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
          };
        },
      ),
      StyleRule(
        BlockSelector(header4Attribution.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.only(top: 22),
            'textStyle': Theme.of(context).textTheme.headline4!.copyWith(
                  color: textColor,
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                  // height: 1.2,
                )
          };
        },
      ),
      StyleRule(
        BlockSelector(header5Attribution.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.only(top: 18),
            'textStyle': Theme.of(context).textTheme.headline5!.copyWith(
                  color: textColor,
                  fontSize: 26.0,
                  fontWeight: FontWeight.w700,
                  // height: 1.2,
                )
          };
        },
      ),
      StyleRule(
        BlockSelector(header6Attribution.name),
        (doc, docNode) {
          return {
            "padding": const CascadingPadding.only(top: 14),
            'textStyle': Theme.of(context).textTheme.headline6!.copyWith(
                  color: textColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  // height: 1.2,
                )
          };
        },
      ),
    ];
