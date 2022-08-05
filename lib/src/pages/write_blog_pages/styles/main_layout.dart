import 'dart:ui';

import 'package:egnimos/src/config/responsive.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/header_styles.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

StyleRules initialLayout() => [
      StyleRule(
        BlockSelector.all,
        (doc, docNode) {
          return {
            "maxWidth": double.infinity,
            // "padding": const CascadingPadding.symmetric(horizontal: 24),
            "textStyle": const TextStyle(
              color: textColor,
              fontSize: 18,
              height: 1.4,
            ),
          };
        },
      ),
    ];
