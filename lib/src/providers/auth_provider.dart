import 'package:cross_file/cross_file.dart';
import 'package:egnimos/src/app.dart';
import 'package:egnimos/src/providers/upload_provider.dart';
import 'package:egnimos/src/utility/collections.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  UploadProvider? _up;
  User? get user => _user;

  void update(UploadProvider up) {
    _up = up;
  }

  //signin with google
  Future<void> signInWithGoogle(
      User? userInfo, XFile? file, AuthType authType) async {
    try {
      // Create a new provider
      auth.GoogleAuthProvider googleProvider = auth.GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      final cred = (await firebaseAuth.signInWithPopup(googleProvider));
      final userId = cred.user!.uid;
      //check if the doc exists then fetch the user info
      await _verifyUser(userId, userInfo, file, authType);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //signin with github
  Future<void> signInWithGithub(
      User? userInfo, XFile? file, AuthType authType) async {
    try {
      // Create a new provider
      auth.GithubAuthProvider githubProvider = auth.GithubAuthProvider();

      // Once signed in, return the UserCredential
      final cred = await firebaseAuth.signInWithPopup(githubProvider);
      final userId = cred.user!.uid;
      //check if the doc exists then fetch the user info
      await _verifyUser(userId, userInfo, file, authType);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //signin with facebook

  //save the user
  Future<void> saveUser(String userId, User userInfo, XFile? file) async {
    try {
      //upload the file
      UploadOutput? uri;
      //upload user image
      if (file != null) {
        final mimeInf = _up!.generateFileType(file);
        uri = await _up!.uploadFile(file, mimeInf.uploadType, mimeInf.fileExt);
      }
      //else register or save the user
      final uInf = User(
        id: userId,
        name: userInfo.name,
        email: userInfo.email,
        uri: uri?.generatedUri ?? "",
        uriName: uri?.fileName ?? "",
        gender: userInfo.gender,
        dob: userInfo.dob,
        ageAccountType: userInfo.ageAccountType,
        createdAt: userInfo.createdAt,
        updatedAt: userInfo.updatedAt,
      );
      await firestoreInstance
          .collection(Collections.users)
          .doc(userId)
          .set(uInf.toJson());
      _user = uInf;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _verifyUser(
      String userId, User? userInfo, XFile? file, AuthType authType) async {
    try {
      final docRef = await firestoreInstance
          .collection(Collections.users)
          .doc(userId)
          .get();
      if (docRef.exists) {
        _user = User.fromJson(docRef.data()!);
      } else {
        //if it doesn't exists then check
        if (authType == AuthType.login && userInfo == null) {
          throw Exception("user dosen't exists please register");
        }
        await saveUser(userId, userInfo!, file);
      }
    } catch (e) {
      rethrow;
    }
  }

  //logout
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      _user = null;
    } catch (e) {
      rethrow;
    }
  }
}
