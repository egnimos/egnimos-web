import 'package:egnimos/src/config/responsive.dart';
import 'package:egnimos/src/pages/write_blog_pages/named_attributions.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/default_paddings.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/default_text_styles.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/header_styles.dart';
import 'package:super_editor/super_editor.dart';

StyleRules initialLayout() => [
      StyleRule(
        BlockSelector.all,
        (doc, docNode) {
          return {
            "maxWidth": double.infinity,
            "width": Responsive.widthMultiplier * 100.0,
            "textStyle": defaultTextStyle,
          };
        },
      ),
      StyleRule(
        BlockSelector(listItemAttribution.name),
        (doc, docNode) {
          if (docNode is! ListItemNode) {
            return {};
          }

          return {
            paddingKey: listitemPadding,
            textStyleKey: listitemTextStyle,
          };
        },
      ),
    ];
