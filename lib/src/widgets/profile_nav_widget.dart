import 'package:cached_network_image/cached_network_image.dart';
import 'package:egnimos/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../config/k.dart';
import '../theme/color_theme.dart';

class ProfileNavWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final User userInf;
  const ProfileNavWidget({
    required this.userInf,
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      width: constraints.maxWidth,
      height: 200.0,
      child: Row(
        children: [
          //menu
          if (constraints.maxWidth < K.kTableteWidth)
            IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          if (constraints.maxWidth < K.kTableteWidth)
            const SizedBox(
              width: 20.0,
            ),

          //image
          Container(
            constraints: BoxConstraints.tight(
              (constraints.maxWidth < K.kTableteWidth)
                  ? const Size.square(70.0)
                  : const Size.square(100.0),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  userInf.uri.isEmpty
                      ? "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_960_720.png"
                      : userInf.uri,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 14.0),

          //name & joined at date
          Flexible(
            child: UserInfoWidget(
              constraints: constraints,
              userInf: userInf,
            ),
          ),
          //space

          //logout
        ],
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  final BoxConstraints constraints;
  final User userInf;
  const UserInfoWidget({
    required this.constraints,
    required this.userInf,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //name
        Flexible(
          child: Text(
            userInf.name,
            style: GoogleFonts.rubik(
              fontSize: constraints.maxWidth > K.kDesktopWidth
                  ? 35.0
                  : constraints.maxWidth > K.kTableteWidth
                      ? 28.0
                      : constraints.maxWidth > K.kMobileWidth
                          ? 20.0
                          : 20.0,
              fontWeight: FontWeight.w400,
              color: ColorTheme.primaryTextColor,
            ),
          ),
        ),
        //joining date
        Flexible(
          child: Text(
            "joined in: " +
                DateFormat.yMEd().format(userInf.createdAt.isEmpty
                    ? DateTime.now()
                    : DateTime.parse(userInf.createdAt)),
            style: GoogleFonts.rubik(
              fontSize: constraints.maxWidth > K.kDesktopWidth
                  ? 20.0
                  : constraints.maxWidth < K.kDesktopWidth &&
                          constraints.maxWidth > K.kTableteWidth
                      ? 16.0
                      : constraints.maxWidth < K.kTableteWidth &&
                              constraints.maxWidth > K.kMobileWidth
                          ? 14.0
                          : 14.0,
              // fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}
