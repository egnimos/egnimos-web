import 'package:egnimos/src/pages/write_blog_pages/custom_attribution/named_attributions.dart';
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
            "padding": const CascadingPadding.only(top: 24),
          };
        },
      ),
    ];
