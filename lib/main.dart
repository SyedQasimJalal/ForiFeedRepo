import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'News_screen2.dart'; // Import your News Screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // if (kIsWeb) {
  //  await Firebase.initializeApp(
  //  options: FirebaseOptions(
  //  apiKey: "AIzaSyCnRMmBYSqackHMSq16Ny6SvJMEvorMGWg",
  // appId: "1:577943125304:web:92d03779123c48434155cd",
  // messagingSenderId: "577943125304",
  // projectId: "flutterfori",
  //  ),
  // );
  // } else {
  // Initialize for mobile (Android/iOS)
  // await Firebase.initializeApp();
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fori Feed', // Add a title for your app
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NewsScreen2(), // Set NewsScreen as the home screen
    );
  }
}
