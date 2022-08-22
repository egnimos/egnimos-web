import 'package:egnimos/src/utility/enum.dart';
import 'package:flutter/material.dart';

import '../config/responsive.dart';
import '../theme/color_theme.dart';
import 'option_tool_box.dart';

final selectedOptionNotifier =
    ValueNotifier<CreateBlogOptions>(CreateBlogOptions.unknown);

class BlogOptionsWidget extends StatelessWidget {
  const BlogOptionsWidget({Key? key}) : super(key: key);

  void onOptionSelected(CreateBlogOptions option) {
    if (toolBoxHandler?.value != toolBoxHandler?.lowerBound) {
      if (option != selectedOptionNotifier.value) {
        selectedOptionNotifier.value = option;
        return;
      }
      selectedOptionNotifier.value = CreateBlogOptions.unknown;
      toolBoxHandler?.reverse(from: toolBoxHandler?.value);
      return;
    }
    selectedOptionNotifier.value = option;
    toolBoxHandler?.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0.0,
      top: (Responsive.heightMultiplier * 50.0) - 150.0,
      child: Container(
          width: 80.0,
          height: 300.0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 30,
                spreadRadius: -5,
                offset: const Offset(0, 10),
              )
            ],
            color: ColorTheme.secondaryTextColor,
          ),
          child: ValueListenableBuilder<CreateBlogOptions>(
              valueListenable: selectedOptionNotifier,
              builder: (context, option, __) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 18.0,
                    ),
                    //file collection
                    IconButton(
                      onPressed: () =>
                          onOptionSelected(CreateBlogOptions.collection),
                      icon: Icon(
                        Icons.collections,
                        color: option == CreateBlogOptions.collection
                            ? ColorTheme.bgColor12
                            : Colors.grey.shade800,
                        size: 40.0,
                      ),
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.grey.shade800,
                    ),
                    //Category
                    IconButton(
                      onPressed: () =>
                          onOptionSelected(CreateBlogOptions.category),
                      icon: Icon(
                        Icons.category,
                        color: option == CreateBlogOptions.category
                            ? ColorTheme.bgColor12
                            : Colors.grey.shade800,
                        size: 40.0,
                      ),
                    ),
                    const SizedBox(
                      height: 18.0,
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.grey.shade800,
                    ),
                    //layout
                    IconButton(
                      onPressed: () =>
                          onOptionSelected(CreateBlogOptions.layout),
                      icon: Icon(
                        Icons.design_services,
                        color: option == CreateBlogOptions.layout
                            ? ColorTheme.bgColor12
                            : Colors.grey.shade800,
                        size: 40.0,
                      ),
                    ),

                    const SizedBox(
                      height: 18.0,
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.grey.shade800,
                    ),
                    //save
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.save,
                        color: Colors.grey.shade800,
                        size: 40.0,
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
