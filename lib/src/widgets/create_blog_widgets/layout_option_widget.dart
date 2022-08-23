import 'package:egnimos/src/models/style_models/styler.dart';
import 'package:egnimos/src/models/style_models/text_style_model.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/default_text_styles.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/header_styles.dart';
import 'package:egnimos/src/pages/write_blog_pages/styles/main_layout.dart';
import 'package:egnimos/src/widgets/create_blog_widgets/layout_widgets/layout_style_widgets.dart/layout_wallpaper_widget.dart';
import 'package:egnimos/src/widgets/create_blog_widgets/layout_widgets/text_layout_setter_widget.dart';
import 'package:egnimos/src/widgets/create_blog_widgets/layout_widgets/layout_style_widgets.dart/layout_bg_color_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_editor/super_editor.dart';

import '../../config/responsive.dart';
import '../../theme/color_theme.dart';

final updatedStyleRules = ValueNotifier<StyleRules>([]);

final stylers = ValueNotifier<List<TextStyleModel>>([]);
final layoutStyler = ValueNotifier<LayoutStyler>(
  LayoutStyler(
    layoutId: DocumentEditor.createNodeId(),
    layoutColor: Colors.white,
    layoutBgUri: "",
  ),
);

class LayoutOptionWidget extends StatelessWidget {
  const LayoutOptionWidget({Key? key}) : super(key: key);

  Widget spaceWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 15.0,
        ),
        Divider(
          color: Colors.grey.shade700,
          thickness: 1.1,
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //options
        Container(
          width: double.infinity,
          height: Responsive.heightMultiplier * 100.0,
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 20.0,
              ),
              //heading
              Align(
                child: Text(
                  "Set Layout",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rubik(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              //liner as a indicator
              Container(
                width: double.infinity,
                height: 4.0,
                margin: const EdgeInsets.only(
                  right: 10.0,
                  left: 10.0,
                  top: 5.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: ColorTheme.bgColor18,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),

              //collection list
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      //Layout Wallpaper
                      LayoutWallpaperWidget(
                        output: (uri) {
                          final initialLayoutInfo = layoutStyler.value;
                          layoutStyler.value = LayoutStyler(
                            layoutId: initialLayoutInfo.layoutId,
                            layoutColor: initialLayoutInfo.layoutColor,
                            layoutBgUri: uri.trim(),
                          );
                        },
                      ),

                      spaceWidget(),

                      //Layout Background Color
                      LayoutBgColorWidget(
                        output: (wallpaperColor) {
                          final initialLayoutInfo = layoutStyler.value;
                          layoutStyler.value = LayoutStyler(
                            layoutId: initialLayoutInfo.layoutId,
                            layoutColor: wallpaperColor,
                            layoutBgUri: initialLayoutInfo.layoutBgUri,
                          );
                        },
                      ),

                      spaceWidget(),

                      //Header
                      TextLayoutSetter(
                        textStyle: h1TextStyle,
                        blockHeading: "Header 1",
                        styleModel: (model) {
                          final initialValues = stylers.value;
                          //remove the id, if it exists
                          initialValues
                              .removeWhere((v) => v.blockId == model.blockId);
                          initialValues.add(model);
                          stylers.value = initialValues;
                          print(stylers.value);
                        },
                      ),

                      //space
                      const SizedBox(
                        height: 70.0,
                      ),
                    ],
                  )),
            ],
          ),
        ),

        //save button
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              updatedStyleRules.value = layoutStyler.value
                  .fromStylerToStyleRules([layoutStyler, ...stylers.value]);
              print(updatedStyleRules.value);
            },
            child: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
