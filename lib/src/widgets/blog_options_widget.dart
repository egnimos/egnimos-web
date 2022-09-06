import 'package:egnimos/src/pages/write_blog_pages/write_blog_page.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/responsive.dart';
import '../theme/color_theme.dart';
import 'option_tool_box.dart';

final selectedOptionNotifier =
    ValueNotifier<CreateBlogOptions>(CreateBlogOptions.unknown);

class BlogOptionsWidget extends StatelessWidget {
  final Future Function() saveBlog;
  const BlogOptionsWidget({
    Key? key,
    required this.saveBlog,
  }) : super(key: key);

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
      top: (Responsive.heightMultiplier * 50.0) - (350.0 / 2),
      child: Container(
          width: 80.0,
          height: 350.0,
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
                    ValueListenableBuilder<bool>(
                        valueListenable: isView,
                        builder: (context, value, child) {
                          return IconButton(
                            onPressed: () {
                              isView.value = !isView.value;
                            },
                            icon: Icon(
                              value
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              color: Colors.grey.shade800,
                              size: 30.0,
                            ),
                          );
                        }),

                    const SizedBox(
                      height: 12.0,
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.grey.shade800,
                    ),
                    //save
                    IconButton(
                      onPressed: saveBlog,
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
