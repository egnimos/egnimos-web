import 'package:egnimos/src/pages/auth_pages/auth_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/k.dart';
import '../../theme/color_theme.dart';
import '../../utility/enum.dart';
import '../../widgets/buttons.dart';

class AuthBox extends StatefulWidget {
  final BoxConstraints constraints;
  const AuthBox({
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthBox> createState() => _AuthBoxState();
}

class _AuthBoxState extends State<AuthBox> {
  AuthType _authType = AuthType.login;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: (widget.constraints.maxWidth / 100) * 40.0,
        padding: const EdgeInsets.only(left: 26.0),
        // color: Colors.green,
        child: Column(
          crossAxisAlignment: widget.constraints.maxWidth < K.kTableteWidth
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            //heading
            Text(
              _authType == AuthType.login ? "Log in" : "Create an account",
              style: GoogleFonts.rubik().copyWith(
                fontSize: 32.0,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            //info
            Text(
              "Welcome to egnimos, please ${_authType == AuthType.login ? 'log in' : 'register'} before using the app",
              style: GoogleFonts.rubik().copyWith(
                fontSize: 18.0,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),

            //user info
            if (_authType == AuthType.register)
              AuthForm(
                constraints: widget.constraints,
              ),

            const SizedBox(
              height: 50.0,
            ),

            //github social auth
            Flexible(
              child: SocialAuthButton(
                constraints: widget.constraints,
                icon: FontAwesomeIcons.github,
                iconColor: Colors.white,
                labelColor: Colors.white,
                label: "Github",
                bgColor: Colors.grey.shade800,
              ),
            ),
            //google social auth
            Flexible(
              child: SocialAuthButton(
                constraints: widget.constraints,
                icon: FontAwesomeIcons.google,
                iconColor: Colors.grey.shade800,
                labelColor: Colors.grey.shade800,
                label: "Google",
                bgColor: Colors.grey.shade100,
              ),
            ),

            //
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RichText(
                text: TextSpan(
                  text: _authType == AuthType.login
                      ? 'Don\'t have an account? '
                      : 'Already have an account? ',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 18,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: _authType == AuthType.login ? 'Register' : 'Log in',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            _authType = _authType == AuthType.login
                                ? AuthType.register
                                : AuthType.login;
                          });
                        },
                      style: GoogleFonts.nunitoSans(
                        fontSize: 18,
                        color: ColorTheme.bgColor8,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
