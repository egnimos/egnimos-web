import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;

import '../theme/color_theme.dart';
import '../widgets/menu.dart';

class AboutPage extends StatefulWidget {
  static const routeName = "about-page";
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController controller = ScrollController();

  Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/md_pages/about_us.md');
  }

  @override
  Widget build(BuildContext context) {
    // final aboutUs = """
    //  egnimos is a platform which brings developers, creators, designers and "everyone who want to innovate" together, egnimos provides the services in development and design, egnimos create the inovative products which helps users, we want to help the users to grow and make their life in a good way, we care about you, that's why we create these innovative products to help you, egnimos welcome every suggestion and feedbacks from you and we need them, by these suggestion and feedbacks we can improve our products and services even more, and that's why the suggestions and feedbacks are important to the egnimos, we are open for discussion also,
    //  we need developers who want to innovate and help others, with egnimos, as rightnow, things are changing and we are advancing towards new era with new technologies and with the changing era, the innovation is becoming even more important, "as life changes, new problem comes with some new innovation"
    //  every problem has its own innovation
    //  we have to push ourself to create the new innovations
    //  and that's why we need you egnimos is happy to welcome you
    //  regards egnimos
    // """;
    return Scaffold(
      drawer: const Menu(selectedOption: NavOptions.about),
      body: ListView(
        // controller: controller,
        children: [
          const Nav(selectedOption: NavOptions.about),
          const SizedBox(
            height: 30.0,
          ),
          FutureBuilder<String>(
            future: loadAsset(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return Markdown(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 40.0,
                  ),
                  styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
                  styleSheet: MarkdownStyleSheet.fromTheme(
                    ThemeData.light().copyWith(
                        primaryColor: ColorTheme.primaryColor,
                        textTheme: TextTheme(
                          bodyText2: GoogleFonts.raleway().copyWith(
                            color: ColorTheme.bgColor4,
                            // height: 12.0,
                            fontSize: 20.0,
                          ),
                        )),
                  ).copyWith(
                    horizontalRuleDecoration: BoxDecoration(
                      color: ColorTheme.bgColor,
                      border: Border.all(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    h1: GoogleFonts.raleway().copyWith(
                      color: ColorTheme.bgColor4,
                      // height: 12.0,
                      fontSize: 50.0,
                    ),
                    pPadding: const EdgeInsets.symmetric(vertical: 6.0),
                    h1Padding: const EdgeInsets.symmetric(vertical: 6.0),
                    h2Padding: const EdgeInsets.symmetric(vertical: 6.0),
                    h2: GoogleFonts.raleway().copyWith(
                      color: ColorTheme.bgColor4,
                      // height: 12.0,
                      fontSize: 40.0,
                    ),
                    h3: GoogleFonts.raleway().copyWith(
                      color: Colors.grey.shade900,
                      // height: 12.0,
                      fontWeight: FontWeight.w400,
                      fontSize: 22.0,
                    ),
                    p: GoogleFonts.raleway().copyWith(
                      color: ColorTheme.bgColor2,
                      // height: 12.0,
                      fontSize: 18.0,
                    ),
                    blockSpacing: 30.0,
                    blockquotePadding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 20.0,
                    ),
                    blockquote: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                    blockquoteDecoration: BoxDecoration(
                      color: Colors.green.shade100,
                      border: const Border(
                        left: BorderSide(
                          color: ColorTheme.bgColor16,
                          width: 6,
                        ),
                      ),
                    ),
                  ),
                  controller: controller,
                  selectable: true,
                  data: snapshot.data!,
                  softLineBreak: true,
                  shrinkWrap: true,
                );
              }
              return Container();
            },
          ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
