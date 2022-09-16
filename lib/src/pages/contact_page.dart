import 'package:flutter/material.dart';

import '../utility/enum.dart';
import '../widgets/menu.dart';
import '../widgets/nav.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Menu(selectedOption: NavOptions.contact),
      body: ListView(
        // controller: controller,
        children: const [
          const Nav(selectedOption: NavOptions.contact),
          const SizedBox(
            height: 30.0,
          ),

          //contact info

        ],
      ),
    );
  }
}
