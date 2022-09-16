import 'package:cached_network_image/cached_network_image.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/widgets/create_blog_widgets/layout_option_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class LayoutWallpaperWidget extends StatefulWidget {
  final void Function(String wallpaperBgImage) output;
  const LayoutWallpaperWidget({
    Key? key,
    required this.output,
  }) : super(key: key);

  @override
  State<LayoutWallpaperWidget> createState() => _LayoutWallpaperWidgetState();
}

class _LayoutWallpaperWidgetState extends State<LayoutWallpaperWidget> {
  final _networkUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _networkUrlController.addListener(() {
    //   //print(_networkUrlController.text);
    //   widget.output(_networkUrlController.text);
    // });
  }

  Widget displayImageBox() {
    return GestureDetector(
      onTap: () {},
      child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _networkUrlController,
          builder: (context, value, __) {
            return Container(
              width: 100.0,
              height: 100.0,
              margin: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.2,
                ),
                image: value.text.isEmpty
                    ? const DecorationImage(
                        image: AssetImage("assets/images/png/no_image.png"),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: CachedNetworkImageProvider(value.text),
                        fit: BoxFit.cover,
                      ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    _networkUrlController.value =
        TextEditingValue(text: layoutStyler.value.layoutBgUri);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Heading
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Layout Wallpaper",
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              fontSize: 18.0,
            ),
          ),
        ),

        const SizedBox(
          height: 20.0,
        ),

        //set image
        displayImageBox(),

        const SizedBox(
          height: 30.0,
        ),

        //set network url for image
        TextField(
          controller: _networkUrlController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: "Add Url",
            labelStyle: GoogleFonts.rubik(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: GoogleFonts.rubik(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: ColorTheme.bgColor8,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(
                width: 1.4,
                color: Colors.grey.shade600,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(
                width: 1.4,
                color: ColorTheme.bgColor8,
              ),
            ),
          ),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          onSubmitted: (val) {
            //print(val);
            widget.output(val);
          },
          onChanged: (val) {
            //print(val);
            widget.output(val);
          },
        ),
      ],
    );
  }
}
