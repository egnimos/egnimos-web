import 'package:egnimos/src/app.dart';
import 'package:egnimos/src/utility/collections.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  //signin with google
  Future<void> signInWithGoogle(User userInfo) async {
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
      final docRef = await firestoreInstance
          .collection(Collections.users)
          .doc(userId)
          .get();
      if (docRef.exists) {
        _user = User.fromJson(docRef.data()!);
      } else {
        //else register or save the user
        final uInf = User(
          id: userId,
          name: userInfo.name,
          email: userInfo.email,
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
      }
    } catch (e) {
      rethrow;
    }
  }

  //signin with github

  //signin with facebook
}
