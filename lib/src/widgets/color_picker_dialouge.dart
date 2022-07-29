import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

Widget colorPickerDialog(
  BuildContext context, {
  Color initialColor = Colors.black,
  required void Function(Color color) onChanged,
}) {
  return ColorPicker(
    // Use the dialogPickerColor as start color.
    color: initialColor,
    showMaterialName: true,
    showColorName: true,
    showColorCode: true,
    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
      longPressMenu: true,
    ),
    heading: Text(
      'Select color',
      style: Theme.of(context).textTheme.subtitle1,
    ),
    subheading: Text(
      'Select color shade',
      style: Theme.of(context).textTheme.subtitle1,
    ),
    wheelSubheading: Text(
      'Selected color and its shades',
      style: Theme.of(context).textTheme.subtitle1,
    ),
    materialNameTextStyle: Theme.of(context).textTheme.caption,
    colorNameTextStyle: Theme.of(context).textTheme.caption,
    colorCodeTextStyle: Theme.of(context).textTheme.caption,
    pickersEnabled: const <ColorPickerType, bool>{
      ColorPickerType.both: false,
      ColorPickerType.primary: true,
      ColorPickerType.accent: true,
      ColorPickerType.bw: false,
      ColorPickerType.custom: true,
      ColorPickerType.wheel: true,
    },
    // Update the dialogPickerColor using the callback.
    onColorChanged: onChanged,
    actionButtons: const ColorPickerActionButtons(
      okTooltip: "confirm",
      closeTooltip: "close",
      closeButton: true,
      okButton: true,
      dialogActionButtons: true,
      dialogActionIcons: true,
      dialogOkButtonType: ColorPickerActionButtonType.outlined,
      dialogCancelButtonType: ColorPickerActionButtonType.text,
    ),
  );
}



// width: 40,
//     height: 40,
//     borderRadius: 4,
//     spacing: 5,
//     runSpacing: 5,
//     wheelDiameter: 155,
//     heading: Text(
//       'Select color',
//       style: Theme.of(context).textTheme.subtitle1,
//     ),
//     subheading: Text(
//       'Select color shade',
//       style: Theme.of(context).textTheme.subtitle1,
//     ),
//     wheelSubheading: Text(
//       'Selected color and its shades',
//       style: Theme.of(context).textTheme.subtitle1,
//     ),
//     showMaterialName: true,
//     showColorName: true,
//     showColorCode: true,
//     copyPasteBehavior: const ColorPickerCopyPasteBehavior(
//       longPressMenu: true,
//     ),
//     materialNameTextStyle: Theme.of(context).textTheme.caption,
//     colorNameTextStyle: Theme.of(context).textTheme.caption,
//     colorCodeTextStyle: Theme.of(context).textTheme.caption,
//     pickersEnabled: const <ColorPickerType, bool>{
//       ColorPickerType.both: false,
//       ColorPickerType.primary: true,
//       ColorPickerType.accent: true,
//       ColorPickerType.bw: false,
//       ColorPickerType.custom: true,
//       ColorPickerType.wheel: true,
//     },