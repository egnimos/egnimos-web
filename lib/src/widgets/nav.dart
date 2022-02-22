import '/src/widgets/egnimos_nav.dart';
import 'package:flutter/material.dart';
import '../config/k.dart';
import '../utility/enum.dart';
import 'buttons.dart';

class Nav extends StatelessWidget with PreferredSizeWidget {
  final NavOptions selectedOption;

  const Nav({
    required this.selectedOption,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        width: double.infinity,
        height: 100.0,
        child: Align(
          child: Row(
            children: [
              if (constraints.maxWidth > K.kMobileWidth)
                SizedBox(
                  width: (constraints.maxWidth / 100) * 2.0,
                ),
              //Nav Icon
              Flexible(child: EgnimosNav(constraints: constraints)),
              if (constraints.maxWidth < K.kTableteWidth)
                const Spacer()
              else
                SizedBox(
                  width: (constraints.maxWidth / 100) * 30.0,
                ),
              //Nav Buttons
              NavButtons(
                selectedOption: selectedOption,
                constraints: constraints,
              ),

              if (constraints.maxWidth > K.kTableteWidth)
                SizedBox(
                  width: (constraints.maxWidth / 100) * 4.0,
                ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size(double.infinity, 60.0);
}
