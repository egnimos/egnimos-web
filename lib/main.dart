import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_editor/super_editor.dart';
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
  whichBrowser();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

///method to detect which browser you are using
///[Mobile Browser],[Desktop Browser]
bool isMobileBrowser = false;
void whichBrowser() {
  isMobileBrowser = kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);
  print("MOBILE BROWSER :: $isMobileBrowser");
}
