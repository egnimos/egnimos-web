import 'package:egnimos/main.dart';
import 'package:egnimos/src/providers/auth_provider.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/footer.dart';
import 'package:egnimos/src/widgets/home_header.dart';
import 'package:egnimos/src/widgets/menu.dart';
import 'package:egnimos/src/widgets/nav.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
                //nav
                Nav(
                  selectedOption: NavOptions.home,
                ),
                //header
                HomeHeader(),
                //footer
                Footer(),
              ],
            );
          }),
    );
  }
}
