import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class LayoutWallpaperWidget extends StatefulWidget {
  const LayoutWallpaperWidget({Key? key}) : super(key: key);

  @override
  State<LayoutWallpaperWidget> createState() => _LayoutWallpaperWidgetState();
}

class _LayoutWallpaperWidgetState extends State<LayoutWallpaperWidget> {
  Widget displayImageBox() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 100.0,
        height: 100.0,
        margin: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          image: const DecorationImage(
            image: CachedNetworkImageProvider(
                "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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

        //set image
        displayImageBox(),
      ],
    );
  }
}
