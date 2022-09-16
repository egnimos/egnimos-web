import 'package:egnimos/src/config/k.dart';
import 'package:flutter/material.dart';

class EgnimosNav extends StatefulWidget {
  final double height;
  final double width;
  final BoxConstraints constraints;

  const EgnimosNav({
    this.height = 200.0,
    this.width = 300.0,
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
      height: widget.height,
      width: widget.width,
      // color: Colors.red,
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
              // //print(_animationController.value);
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

class EgnimosIconWithName extends StatelessWidget {
  final BoxConstraints constraints;
  const EgnimosIconWithName({
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: constraints.maxWidth > K.kTableteWidth ? 300.0 : 100.0,
      height: 100.0,
      child: Row(
        children: [
          //image
          Flexible(
            child: Image.asset(
              "assets/images/png/Group_392-2.png",
              width: 40.0,
              height: 40.0,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(
            width: 8.0,
          ),

          //icon name
          Flexible(
            child: Text(
              "EGNIMOS",
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontSize: constraints.maxWidth > K.kMobileWidth ? 22.0 : 16.0,
                color: Colors.grey.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
