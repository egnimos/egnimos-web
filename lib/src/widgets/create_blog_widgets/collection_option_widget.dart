import 'package:egnimos/src/config/responsive.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/widgets/file_collection_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/collection_file.dart';

final selectedFiles = ValueNotifier<List<CollectionFile>>([]);

class CollectionOptionWidget extends StatelessWidget {
  const CollectionOptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              "Collections",
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
            child: FileCollectionList(
              disableActions: true,
              selectedFiles: (files) {
                //print(files);
                selectedFiles.value = files;
              },
            ),
          ),
        ],
      ),
    );
  }
}
