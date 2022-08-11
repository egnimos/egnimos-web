import 'package:egnimos/src/pages/write_blog_pages/write_blog_page.dart';
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const WriteBlogPage();
                      }));
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

//save pop up model
class SaveBlogPopUpModalWidget extends StatefulWidget {
  final Future<void> Function(BlogType type) onSave;
  const SaveBlogPopUpModalWidget({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  State<SaveBlogPopUpModalWidget> createState() =>
      _SaveBlogPopUpModalWidgetState();
}

class _SaveBlogPopUpModalWidgetState extends State<SaveBlogPopUpModalWidget> {
  BlogType selectedOptions = BlogType.draft;

  Widget optionBox({
    required VoidCallback onTap,
    required BlogType blogType,
    required String titleText,
    required String description,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width / 100) * 30.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.7,
            color: selectedOptions == blogType
                ? ColorTheme.primaryColor
                : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //row
            Row(
              children: [
                //radio
                Radio<BlogType>(
                  hoverColor: ColorTheme.primaryColor.shade50,
                  activeColor: ColorTheme.primaryColor,
                  focusColor: ColorTheme.primaryColor,
                  value: blogType,
                  groupValue: selectedOptions,
                  onChanged: (__) {},
                ),

                Text(
                  titleText,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w500,
                    fontSize: 21.0,
                  ),
                ),
              ],
            ),

            //description
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 6.0,
              ),
              child: Text(
                description,
                style: GoogleFonts.rubik(
                  color: selectedOptions == blogType
                      ? ColorTheme.primaryColor
                      : null,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: (MediaQuery.of(context).size.width / 100) * 60.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //heading
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Save as/to",
                style: GoogleFonts.rubik(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(
              height: 18.0,
            ),

            Row(
              children: [
                //check box
                Flexible(
                  child: optionBox(
                    onTap: () {
                      setState(() {
                        selectedOptions = BlogType.published;
                      });
                    },
                    blogType: BlogType.published,
                    titleText: "Save to publish",
                    description: "Publish a blog for other users",
                  ),
                ),

                const SizedBox(
                  width: 18.0,
                ),

                //draft
                Flexible(
                  child: optionBox(
                    onTap: () {
                      setState(() {
                        selectedOptions = BlogType.draft;
                      });
                    },
                    blogType: BlogType.draft,
                    titleText: "Save to draft",
                    description: "Draft a blog for yourself only",
                  ),
                ),

                const SizedBox(
                  width: 18.0,
                ),
              ],
            ),

            const SizedBox(
              height: 34.0,
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
                  onPressed: () => widget.onSave(selectedOptions),
                  icon: const Icon(
                    Icons.save,
                    color: ColorTheme.primaryColor,
                  ),
                  label: Text(
                    "Save",
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
