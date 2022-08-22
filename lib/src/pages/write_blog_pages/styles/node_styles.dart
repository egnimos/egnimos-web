import 'package:egnimos/src/pages/write_blog_pages/named_attributions.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/default_paddings.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/default_text_styles.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/header_styles.dart';
import 'package:super_editor/super_editor.dart';

import '../custom_document_nodes/checkbox_node.dart';

StyleRules nodeStyles() => [
      StyleRule(
        BlockSelector(checkboxAttribution.name),
        (document, node) {
          if (node is! CheckboxNode) {
            return {};
          }

          return {
            paddingKey: checkboxPadding,
            textStyleKey: checkboxTextStyle,
          };
        },
      ),
    ];
