import 'package:egnimos/src/config/responsive.dart';
import 'package:egnimos/src/providers/auth_provider.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/footer.dart';
import 'package:egnimos/src/widgets/home_header.dart';
import 'package:egnimos/src/widgets/menu.dart';
import 'package:egnimos/src/widgets/nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_vertical_text_widget.dart';

class Home extends StatelessWidget {
  static const routeName = "/home";
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(selectedOption: NavOptions.home),
      body: FutureBuilder(
          future: Provider.of<AuthProvider>(context, listen: false).getUser(),
          builder: (context, snapshot) {
            //waiting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  "assets/json/home-loading.json",
                  repeat: true,
                ),
              );
            }

            return ListView(
              children: const [
                //header
                Header(),
                //footer
                Footer(),
              ],
            );
          }),
    );
  }
}

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool isAnimationDisable = false;
  bool isExpanded = true;
  double blackContainerWidth = Responsive.widthMultiplier * 95.0;
  double whiteContainerWidth = Responsive.widthMultiplier * 10.0;
  double heightCon = 230.0;
  double opacity = 1.0;
  // Matrix4? transform;

  void updateWidth(dynamic event) {
    if (!isAnimationDisable && event.position.dx > 100) {
      blackContainerWidth = event.position.dx;
      whiteContainerWidth =
          (Responsive.widthMultiplier * 100.0) - event.position.dx;
      // transform = event.transform?.absolute();
      setState(() {});
    }
  }

  void reset() {
    blackContainerWidth = Responsive.widthMultiplier * 90.0;
    whiteContainerWidth = Responsive.widthMultiplier * 10.0;
    // isAnimationDisable = true;
    setState(() {});
  }

  void changeOpacity() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        opacity = opacity == 0.0 ? 1.0 : 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        isAnimationDisable = !isAnimationDisable;
        if (isAnimationDisable) {
          heightCon = 60.0;
        } else {
          heightCon = 230.0;
        }
        changeOpacity();
        reset();
      },
      child: MouseRegion(
        onEnter: (event) => updateWidth(event),
        onExit: (event) => reset(),
        onHover: (event) => updateWidth(event),
        child: SizedBox(
          height: Responsive.heightMultiplier * 100.0,
          width: Responsive.widthMultiplier * 100.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              //nav
              const Nav(
                selectedOption: NavOptions.home,
              ),
              //header
              const Align(child: HomeHeader()),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: Responsive.widthMultiplier * 95.0,
                height: Responsive.heightMultiplier * 100.0,
                color: const Color(0xff121212),
                transform: Matrix4Transform().left(whiteContainerWidth).m,
                child: HomeHeader(
                  infoColor: ColorTheme.secondaryTextColor,
                  leadingTextColor: ColorTheme.secondaryTextColor,
                  animatedTextColor: ColorTheme.bgColor18,
                ),
              ),

              //floater
              GestureDetector(
                onTap: () {
                  isExpanded = !isExpanded;
                  if (isExpanded) {
                    reset();
                  } else {
                    blackContainerWidth = 100;
                    whiteContainerWidth =
                        (Responsive.widthMultiplier * 100.0) - 100;
                  }
                  // transform = event.transform?.absolute();
                  setState(() {});
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  alignment: Alignment.bottomRight,
                  width: blackContainerWidth,
                  height: Responsive.heightMultiplier * 100.0,
                  child: Transform.translate(
                    offset: const Offset(-10.0, -10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 330),
                          curve: Curves.easeInOutBack,
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          width: 60.0,
                          height: heightCon,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorTheme.bgColor10,
                              width: 1.6,
                            ),
                            // color: ColorTheme.bgColor10,
                            borderRadius: isAnimationDisable
                                ? BorderRadius.circular(100.0)
                                : BorderRadius.circular(22.0),
                          ),
                          child: isAnimationDisable
                              ? Icon(
                                  isExpanded
                                      ? Icons.arrow_back_ios
                                      : Icons.arrow_forward_ios,
                                  color: ColorTheme.bgColor10,
                                )
                              : AnimatedOpacity(
                                  opacity: opacity,
                                  duration: const Duration(milliseconds: 400),
                                  child: CustomVerticalTextWidget(
                                    "DISABLE",
                                    textStyle: GoogleFonts.rubik(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22.0,
                                      color: ColorTheme.bgColor10,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
