import 'package:flutter/material.dart';

class Responsive {
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double _blockSizeHorizontal = 0.0;
  static double _blockSizeVertical = 0.0;

  static double textMultiplier = 0.0;
  static double imageSizeMultiplier = 0.0;
  static double heightMultiplier = 0.0;
  static double widthMultiplier = 0.0;

  static void init(BoxConstraints constraints) {
    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;
  }
}
