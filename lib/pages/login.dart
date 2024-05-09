import 'dart:developer';

import 'package:barbar_booking_app/pages/home_page.dart';
import 'package:barbar_booking_app/pages/sign_up.dart';
import 'package:barbar_booking_app/providers/ProgressBarProvider.dart';
import 'package:barbar_booking_app/services/shared_prefrences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _name = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  ProgressBarProvider? progressProvider;

  loginUser(w, context) async {
    try {
      progressProvider!.changeLogging();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      final userId =
          _emailController.text + _passwordController.text.toString();
      SharedPreferencesHelper().saveUserId(userId);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              email: _emailController.text.toString(),
            ),
          ));
      progressProvider!.changeLogging();
    } on FirebaseException catch (e) {
      log(e.code);
      progressProvider!.changeLogging();
      if (e.code == "invalid-credential") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "User not found!!",
            style: TextStyle(fontSize: w * 0.04),
          ),
        ));
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Wrong password!!",
            style: TextStyle(fontSize: w * 0.04),
          ),
        ));
      }
    }
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

  String? validatePass(String? pass) {
    if (pass!.trimLeft().trimRight().isEmpty) {
      return "Please enter password";
    }
    if (pass!.length < 6) {
      return "Password is too small";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    progressProvider = Provider.of<ProgressBarProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, top: 25),
            width: w,
            height: h / 2,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFFB91635),
              Color(0xFF621d3c),
              Color(0xFF311937)
            ])),
            child: Text(
              "Hello \nSign in!",
              style: TextStyle(color: Colors.white, fontSize: w * 0.06),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: h / 4),
            padding: EdgeInsets.only(left: 30, top: 20, right: 20),
            height: h,
            width: w,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Form(
              key: _fromKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gmail",
                      style: TextStyle(
                          color: Color(0xFFB91635), fontSize: w * 0.05)),
                  TextFormField(
                    controller: _emailController,
                    validator: (email) {
                      return validateEmail(email);

                      /// Email Validation
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
                    controller: _passwordController,
                    validator: (pass) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Forgot Password?",
                          style: TextStyle(
                              color: const Color(0xFF311937),
                              fontSize: w * 0.05)),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_fromKey.currentState!.validate()) {
                        loginUser(w, context);
                      }
                    },
                    child: Consumer<ProgressBarProvider>(
                      builder: (context, value, child) => Container(
                        padding: EdgeInsets.all(10),
                        width: w,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0xFFB91635),
                              Color(0xFF621d3c),
                              Color(0xFF311937)
                            ]),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: (value.isLoading)
                              ? Container(
                                  height: 30,
                                  width: 30,
                                  child: const CircularProgressIndicator(color: Colors.white,))
                              : Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: w * 0.06,
                                      fontWeight: FontWeight.bold),
                                ),
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
                        "Don't have an Account?",
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
                                return const SignUpPage();
                              },
                            ));
                          },
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontSize: w * 0.05,
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
