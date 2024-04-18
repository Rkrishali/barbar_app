import 'dart:developer';

import 'package:barbar_booking_app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _name = TextEditingController();
  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, top: 25),
              width: w,
              height: h / 2,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xFFB91635),
                Color(0xFF621d3c),
                Color(0xFF311937)
              ])),
              child: Text(
                "Create Your\nAccount",
                style: TextStyle(color: Colors.white, fontSize: w * 0.06),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: h / 4),
              padding: EdgeInsets.only(left: 20, top: 30, right: 20),
              height: h,
              width: w,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Form(
                key: _fromKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name",
                          style: TextStyle(
                              color: Color(0xFFB91635), fontSize: w * 0.05)),
                      TextFormField(
                        validator: (name) {
                          if (name != null &&
                              name.trimLeft().trimRight().isEmpty) {
                            return "Please enter name";
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Name", prefixIcon: Icon(Icons.person)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text("Gmail",
                          style: TextStyle(
                              color: const Color(0xFFB91635),
                              fontSize: w * 0.05)),
                      TextFormField(
                        validator: (email) {
                          /// Validate email
                          return validateEmail(email);
                        },
                        decoration: const InputDecoration(
                            hintText: "Gmail", prefixIcon: Icon(Icons.mail)),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text("Password",
                          style: TextStyle(
                              color: const Color(0xFFB91635),
                              fontSize: w * 0.05)),
                      TextFormField(
                        validator: (pass) {
                          /// Password validation
                          return validatePass(pass);
                        },
                        decoration: const InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_fromKey.currentState!.validate()) {
                            registration(w);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: w,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xFFB91635),
                                Color(0xFF621d3c),
                                Color(0xFF311937)
                              ]),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              "SIGN UN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.06,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an Account?",
                            style: TextStyle(
                              fontSize: w * 0.04,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return const LoginPage();
                                  },
                                ));
                              },
                              child: Text(
                                "SIGN IN",
                                style: TextStyle(
                                  fontSize: w * 0.05,
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  registration(double w) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.toString(), password: _passwordController.text.toString());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Registration Successfully",
          style: TextStyle(fontSize: w * 0.04),
        ),
      ));
    } on FirebaseException catch (e) {
      log(e.toString());
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Weak Password",
            style: TextStyle(fontSize: w * 0.04),
          ),
        ));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Account Already exist",
            style: TextStyle(fontSize: w * 0.04),
          ),
        ));
      }
    }
  }

  String? validatePass(String? pass) {
    if (pass!.trimLeft().trimRight().isEmpty) {
      return "Please enter password";
    }
    if (pass!.length < 6) {
      return "Password is too small";
    }

    return null;
  }

  String? validateEmail(String? email) {
    if (email!.trimRight().trimLeft().isEmpty) {
      return "Please enter email";
    }

    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailRegex);
    if (!regExp.hasMatch(email)) {
      return "Please enter a valid email";
    }

    return null;
  }
}
