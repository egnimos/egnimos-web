import 'package:flutter/cupertino.dart';
import 'package:super_editor/super_editor.dart';

import '../named_attributions.dart';

///[Padding] Key
const paddingKey = "padding";

///[defaultPadding] for every one
const defaultPadding = CascadingPadding.symmetric(vertical: 5.0);

///[Padding] for [h1]
const h1Padding = CascadingPadding.only(top: 40);

///[Padding] for [h2]
const h2Padding = CascadingPadding.only(top: 32);

///[Padding] for [h3]
const h3Padding = CascadingPadding.only(top: 28);

///[Padding] for [h4]
const h4Padding = CascadingPadding.only(top: 22);

///[Padding] for [h5]
const h5Padding = CascadingPadding.only(top: 18);

///[Padding] for [h6]
const h6Padding = CascadingPadding.only(top: 14);

///[Padding] for [CheckboxNode]
const checkboxPadding = CascadingPadding.only(top: 24);

const userPadding = CascadingPadding.only(
  top: 24,
  bottom: 24,
);

///[Padding] for [ListItem]
const listitemPadding = CascadingPadding.only(top: 24);

Map<NamedAttribution, EdgeInsetsGeometry> getPadding() => {
      header1Attribution: h1Padding.toEdgeInsets(),
      header2Attribution: h2Padding.toEdgeInsets(),
      header3Attribution: h3Padding.toEdgeInsets(),
      header4Attribution: h4Padding.toEdgeInsets(),
      header5Attribution: h5Padding.toEdgeInsets(),
      header6Attribution: h6Padding.toEdgeInsets(),
      blockquoteAttribution: defaultPadding.toEdgeInsets(),
      listItemAttribution: listitemPadding.toEdgeInsets(),
      checkboxAttribution: checkboxPadding.toEdgeInsets(),
      paragraphAttribution: defaultPadding.toEdgeInsets(),
    };
