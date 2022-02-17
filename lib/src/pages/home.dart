import 'package:egnimos/main.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/footer.dart';
import 'package:egnimos/src/widgets/home_header.dart';
import 'package:egnimos/src/widgets/menu.dart';
import 'package:egnimos/src/widgets/nav.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  static const routeName = "/home";
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(selectedOption: NavOptions.home),
      body: ListView(
        children: const [
          //nav
          Nav(selectedOption: NavOptions.home),
          //header
          HomeHeader(),
          //footer
          Footer(),
        ],
      ),
    );
  }
}
