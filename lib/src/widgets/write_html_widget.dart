import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' as htmlparser;

import '../theme/color_theme.dart';

class WriteHtmlWidget extends StatefulWidget {
  final void Function(String value) onClick;
  const WriteHtmlWidget({
    Key? key,
    required this.onClick,
  }) : super(key: key);

  @override
  State<WriteHtmlWidget> createState() => _WriteHtmlWidgetState();
}

class _WriteHtmlWidgetState extends State<WriteHtmlWidget> {
  final _htmlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 100) * 70.0,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //heading
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Write Html",
              style: GoogleFonts.rubik(
                fontSize: 28.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(
            height: 300.0,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _htmlController,
              builder: (context, val, __) {
                final html = HtmlWidget(
                  val.text,
                  // ignore: deprecated_member_use
                  webView: true,
                  // ignore: deprecated_member_use
                  webViewJs: true,
                );
                return val.text.isEmpty ? const SizedBox.shrink() : html;
              },
            ),
          ),

          const SizedBox(
            height: 18.0,
          ),

          //text field
          TextField(
            controller: _htmlController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "",
              labelStyle: GoogleFonts.rubik(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
              floatingLabelStyle: GoogleFonts.rubik(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: ColorTheme.bgColor8,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.grey.shade600,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            onChanged: (val) {
              print(val);
            },
          ),

          const SizedBox(
            height: 18.0,
          ),

          //submit button
          Align(
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
                if (_htmlController.text.isNotEmpty) {
                  Navigator.pop(context);
                  _htmlController.value =
                      TextEditingValue(text: _htmlController.text);
                  widget.onClick(_htmlController.text);
                }
              },
              icon: const Icon(
                Icons.start_rounded,
                color: ColorTheme.primaryColor,
              ),
              label: Text(
                "Submit",
                style: GoogleFonts.rubik(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
