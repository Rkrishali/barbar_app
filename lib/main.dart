import 'package:barbar_booking_app/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAim4MaVMaFEsoDuzmsfxdEzEVGoShr288",
      appId: "1:346843429346:android:b09ca18ce1ada7ca0f61bb",
      messagingSenderId: "346843429346",
      projectId: "barbar-app-c6842",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: const SignUpPage());
  }
}
