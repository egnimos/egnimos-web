import 'package:egnimos/src/providers/auth_provider.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AdminUserVerifyInfo {
  final String email;
  final ProviderType type;

  AdminUserVerifyInfo({
    required this.email,
    required this.type,
  });
}

class VerifyAdminForUser {
  static List<AdminUserVerifyInfo> userAllowedForAdmin = [
    AdminUserVerifyInfo(
      email: "egnimos25@gmail.com",
      type: ProviderType.google,
    ),
    AdminUserVerifyInfo(
      email: "egnimos25@gmail.com",
      type: ProviderType.github,
    ),
  ];

  static bool isVerified(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) return false;
    final isContain = userAllowedForAdmin
        .where((v) => v.email == user.email && v.type == user.providerType)
        .isNotEmpty;
    return isContain;
  }
}
