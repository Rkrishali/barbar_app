import 'package:barbar_booking_app/pages/home_page.dart';
import 'package:barbar_booking_app/pages/sign_up.dart';
import 'package:barbar_booking_app/services/shared_prefrences.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String getEmailFromText(String text) {
    String email = '';
    for (int i = 0; i < text.length; i++) {
      if (text[i] == '@') {
        email += "@";
        break;
      }
      email += text[i];
    }
    email += "gmail.com";
    return email;
  }

  void checkUserIsLoggedInOrNot(context) async {
    final userId = await SharedPreferencesHelper().getUserId();
    if (userId != null) {
      final email = getEmailFromText(userId);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(email: email),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpPage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF2b1615),
      body: Container(
        margin: EdgeInsets.only(top: h * 0.09),
        child: Column(
          children: [
            Image.asset("assets/images/barber.png"),
            SizedBox(
              height: h * 0.04,
            ),
            GestureDetector(
              onTap: () {
                checkUserIsLoggedInOrNot(context);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color(0xFFdf711a),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  "Get a Stylist Haircut",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
