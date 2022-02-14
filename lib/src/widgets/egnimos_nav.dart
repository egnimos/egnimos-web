import 'package:egnimos/src/config/k.dart';
import 'package:flutter/material.dart';

class EgnimosNav extends StatefulWidget {
  final BoxConstraints constraints;

  const EgnimosNav({
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  _EgnimosNavState createState() => _EgnimosNavState();
}

class _EgnimosNavState extends State<EgnimosNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      width: 300.0,
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Flexible(
            child: Text(
              "EGNIMOS",
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontSize:
                    widget.constraints.maxWidth > K.kMobileWidth ? 30.0 : 20.0,
                color: Colors.grey.shade900,
              ),
            ),
          ),

          //blink
          AnimatedBuilder(
            animation: _animationController,
            builder: (c, child) {
              // print(_animationController.value);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: 3.0,
                height: widget.constraints.maxWidth > K.kMobileWidth
                    ? 50.0 * _animationController.value
                    : 24.0 * _animationController.value,
              );
            },
          ),
        ],
      ),
    );
  }
}
