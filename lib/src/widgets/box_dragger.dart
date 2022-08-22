import 'package:egnimos/src/widgets/option_tool_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../config/responsive.dart';

class BoxDragger extends StatelessWidget {
  const BoxDragger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    num initx = 0.0;
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onPanStart: (details) {
          initx = details.globalPosition.dx;
          toolBoxHandler?.animateTo(
            initx.toDouble(),
            duration: const Duration(milliseconds: 50),
          );
        },
        onPanUpdate: (details) {
          final val = details.globalPosition.dx;
          toolBoxHandler?.animateTo(
            val,
            duration: const Duration(milliseconds: 50),
          );
        },
        child: Container(
          color: Colors.grey.shade400,
          height: Responsive.heightMultiplier * 100.0,
          width: 10.0,
        ),
      ),
    );
  }
}
