import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/app.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

SharedPreferences? prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class WebAppAuthState {
  //check auth state
  Future<bool> checkAuthState() async {
    final user = await firebaseAuth.authStateChanges().first;
    print(user);
    if (user != null) {
      return true;
    }
    return false;
  }
}
