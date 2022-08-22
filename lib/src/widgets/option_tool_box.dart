import 'package:egnimos/src/config/responsive.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/blog_options_widget.dart';
import 'package:egnimos/src/widgets/box_dragger.dart';
import 'package:egnimos/src/widgets/create_blog_widgets/collection_option_widget.dart';
import 'package:flutter/material.dart';

import 'create_blog_widgets/category_option_widget.dart';
import 'create_blog_widgets/layout_option_widget.dart';

AnimationController? toolBoxHandler;
late Tween<num> tweenAnimation;

class OptionToolBox extends StatefulWidget {
  const OptionToolBox({Key? key}) : super(key: key);

  @override
  State<OptionToolBox> createState() => _OptionToolBoxState();
}

class _OptionToolBoxState extends State<OptionToolBox>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    toolBoxHandler = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
      reverseDuration: const Duration(
        milliseconds: 300,
      ),
      lowerBound: 0,
      upperBound: Responsive.widthMultiplier * 30.0,
    );

    tweenAnimation = Tween(
      begin: 0,
      end: Responsive.widthMultiplier * 30.0,
    )..animate(
        CurvedAnimation(
          parent: toolBoxHandler!,
          curve: Curves.easeInOut,
        ),
      );
  }

  @override
  void dispose() {
    toolBoxHandler?.dispose();
    super.dispose();
  }

  Widget switchOptionWidget() {
    return ValueListenableBuilder<CreateBlogOptions>(
      valueListenable: selectedOptionNotifier,
      builder: (context, option, __) {
        switch (option) {
          case CreateBlogOptions.collection:
            return const CollectionOptionWidget();
          case CreateBlogOptions.category:
            return const CategoryOptionWidget();
          case CreateBlogOptions.layout:
            return const LayoutOptionWidget();
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      controller: toolBoxHandler!,
      child: switchOptionWidget(),
    );
  }
}

class AnimatedDrawer extends AnimatedWidget {
  const AnimatedDrawer({
    Key? key,
    required AnimationController controller,
    required this.child,
  }) : super(
          key: key,
          listenable: controller,
        );
  final Widget child;

  Animation<double> get width => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: Responsive.heightMultiplier * 100.0,
      width: width.value,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //child
          Expanded(
            flex: 10,
            child: child,
          ),

          //adjuster or dragger
          const Flexible(
            child: BoxDragger(),
          ),
          // ),
        ],
      ),
    );
  }
}
