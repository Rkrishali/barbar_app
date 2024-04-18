import 'dart:developer';

import 'package:barbar_booking_app/pages/booking_page.dart';
import 'package:barbar_booking_app/pages/home_page.dart';
import 'package:barbar_booking_app/pages/login.dart';
import 'package:barbar_booking_app/pages/sign_up.dart';
import 'package:barbar_booking_app/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions firebaseOptions = const FirebaseOptions(
    apiKey: "AIzaSyDUwM8xjCrXPY4LZZHrgy0P9te-ghQLx6A",
    appId: "1:500724793465:android:e339ce758c8f01081054a8",
    messagingSenderId: "500724793465",
    projectId: "barbar--app",
  );

  try {
    await Firebase.initializeApp(
        options: firebaseOptions
    );
    runApp(const MyApp());
  }
  catch (e)
  {
log(e.toString());
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
      home: const SignUpPage()
    );
  }
}

