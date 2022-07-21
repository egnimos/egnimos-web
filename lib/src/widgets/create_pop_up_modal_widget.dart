import 'package:egnimos/src/pages/write_blog_pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/color_theme.dart';
import '../utility/enum.dart';

class CreatePopUpModalWidget extends StatefulWidget {
  const CreatePopUpModalWidget({Key? key}) : super(key: key);

  @override
  State<CreatePopUpModalWidget> createState() => _CreatePopUpModalWidgetState();
}

class _CreatePopUpModalWidgetState extends State<CreatePopUpModalWidget> {
  WriteOptions selectedOptions = WriteOptions.blog;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: (MediaQuery.of(context).size.width / 100) * 80.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //heading
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Choose an Options",
                style: GoogleFonts.rubik(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(
              height: 18.0,
            ),

            //check box
            ListTile(
              onTap: () {
                setState(() {
                  selectedOptions = WriteOptions.blog;
                });
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.7,
                  color: selectedOptions == WriteOptions.blog
                      ? ColorTheme.primaryColor
                      : Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              leading: Radio<WriteOptions>(
                hoverColor: ColorTheme.primaryColor.shade50,
                activeColor: ColorTheme.primaryColor,
                focusColor: ColorTheme.primaryColor,
                value: WriteOptions.blog,
                groupValue: selectedOptions,
                onChanged: (__) {},
              ),
              title: Text(
                "Blog",
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text(
                "write a blog to publish for every other user to see or save it as a draft for your self only",
                style: GoogleFonts.rubik(),
              ),
            ),

            const SizedBox(
              height: 18.0,
            ),

            ListTile(
              onTap: () {
                setState(() {
                  selectedOptions = WriteOptions.book;
                });
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.7,
                  color: selectedOptions == WriteOptions.book
                      ? ColorTheme.primaryColor
                      : Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              leading: Radio<WriteOptions>(
                  hoverColor: ColorTheme.primaryColor.shade50,
                  activeColor: ColorTheme.primaryColor,
                  focusColor: ColorTheme.primaryColor,
                  value: WriteOptions.book,
                  groupValue: selectedOptions,
                  onChanged: (val) {}),
              title: Text(
                "Book",
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                ),
              ),
              subtitle: Text(
                "write a book, documentation or manual to user information regarding any tech or product",
                style: GoogleFonts.rubik(),
              ),
            ),

            const SizedBox(
              height: 18.0,
            ),

            //start button
            Flexible(
              child: Align(
                alignment: Alignment.bottomRight,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      primary: ColorTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      side: const BorderSide(
                        width: 1.2,
                        color: ColorTheme.primaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      )),
                  onPressed: () {
                    if (selectedOptions == WriteOptions.blog) {
                      Navigator.of(context).pushNamed(BlogPage.routeName);
                    }
                  },
                  icon: const Icon(
                    Icons.start_rounded,
                    color: ColorTheme.primaryColor,
                  ),
                  label: Text(
                    "Start",
                    style: GoogleFonts.rubik(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
