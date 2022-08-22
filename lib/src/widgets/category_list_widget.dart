import 'package:cached_network_image/cached_network_image.dart';
import 'package:egnimos/src/models/category.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../config/responsive.dart';
import '../providers/category_provider.dart';
import '../providers/upload_provider.dart';
import 'create_pop_up_modal_widget.dart';
import 'indicator_widget.dart';

class CategoryListWidget extends StatefulWidget {
  final BoxConstraints constraints;
  final bool disableActions;
  final void Function(Category? categories)? selectedCategories;
  CategoryListWidget({
    Key? key,
    required this.constraints,
    this.disableActions = false,
    this.selectedCategories,
  }) : super(key: key);

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  Category? selectedCategories;
  final isLoading = ValueNotifier<bool>(true);

  void loadInfo(BuildContext context) async {
    try {
      await Provider.of<CategoryProvider>(context, listen: false)
          .getCategories();
      isLoading.value = false;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    loadInfo(context);
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, child) {
        if (loading) {
          return const Align(
            child: CircularProgressIndicator(),
          );
        } else {
          return Consumer<CategoryProvider>(builder: (context, cp, __) {
            final isEmpty = cp.categories.isEmpty;

            return isEmpty
                ? Container(
                    width: double.infinity,
                    height: 250.0,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Flexible(
                          child: Lottie.asset(
                            "assets/json/not-found.json",
                            reverse: true,
                            width: Responsive.imageSizeMultiplier * 30.0,
                            height: Responsive.imageSizeMultiplier * 30.0,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "no categories available",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      //blogs
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                            children: cp.categories
                                .map(
                                  (cat) => GestureDetector(
                                    onTap: () {
                                      final isPresent =
                                          selectedCategories?.id == cat.id;
                                      if (!isPresent) {
                                        //store to the selected file
                                        selectedCategories = cat;
                                        //update the function
                                        widget.selectedCategories!(
                                            selectedCategories);
                                      } else {
                                        //remove the selected file
                                        selectedCategories = null;
                                        //update the function
                                        widget.selectedCategories!(
                                            selectedCategories);
                                      }
                                      setState(() {});
                                    },
                                    child: CategoryBox(
                                      categoryInfo: cat,
                                      constraints: widget.constraints,
                                      disableActions: widget.disableActions,
                                      selectedId: selectedCategories?.id ?? "",
                                    ),
                                  ),
                                )
                                .toList()),
                      ),
                    ],
                  );
          });
        }
      },
    );
  }
}

class CategoryBox extends StatelessWidget {
  final Category categoryInfo;
  final BoxConstraints constraints;
  final bool disableActions;
  final String selectedId;
  const CategoryBox({
    required this.constraints,
    Key? key,
    required this.selectedId,
    required this.categoryInfo,
    this.disableActions = false,
  }) : super(key: key);

  Widget categoryBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          )
        ],
      ),
      width: 200.0,
      height: 300.0,
      child: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          //image
          Align(
            child: Container(
              width: 160.0,
              height: 130.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6.0),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    categoryInfo.image?.generatedUri ?? "",
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 30,
                    spreadRadius: -5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),
          //Text
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
            ),
            child: Text(
              categoryInfo.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w800,
                fontSize: 18.0,
              ),
            ),
          ),

          //description
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              categoryInfo.description,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(
                // fontWeight: FontWeight.w800,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDeleting = ValueNotifier<bool>(false);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 19.0,
      ),
      width: disableActions ? 200.0 : 300.0,
      height: disableActions ? 300.0 : null,
      decoration: disableActions
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: selectedId == categoryInfo.id
                  ? Border.all(
                      width: 2.6,
                      color: ColorTheme.bgColor18,
                    )
                  : null,
            )
          : null,
      child: disableActions
          ? categoryBox()
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: isDeleting,
                      builder: (context, value, child) => Transform.rotate(
                        angle: -math.pi / 2,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.redAccent.shade700,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              isDeleting.value = true;
                              if (categoryInfo.image?.generatedUri.isNotEmpty ??
                                  false) {
                                await Provider.of<UploadProvider>(context,
                                        listen: false)
                                    .removeFiles(
                                  categoryInfo.image?.fileName ?? "",
                                  PickerType.image,
                                  "cat_files",
                                );
                              }
                              await Provider.of<CategoryProvider>(context,
                                      listen: false)
                                  .deleteCategory(categoryInfo.id);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                            } finally {
                              isDeleting.value = false;
                            }
                          },
                          child: Text(
                            value ? "deleting..." : "delete",
                            style: GoogleFonts.openSans(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100.0,
                    ),
                    //edit
                    Transform.rotate(
                      angle: -math.pi / 2,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: ColorTheme.bgColor10,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          IndicatorWidget.showCreateBlogModal(
                            context,
                            child: CreateCategoryPopupModel(
                              constraints: constraints,
                              categoryInfo: categoryInfo,
                            ),
                          );
                        },
                        child: Text(
                          "edit",
                          style: GoogleFonts.openSans(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                            color: ColorTheme.bgColor10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //Category box
                categoryBox(),
              ],
            ),
    );
  }
}
