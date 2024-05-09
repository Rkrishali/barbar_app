import 'dart:developer';

import 'package:barbar_booking_app/pages/home_page.dart';
import 'package:barbar_booking_app/pages/login.dart';
import 'package:barbar_booking_app/services/database.dart';
import 'package:barbar_booking_app/services/shared_prefrences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../providers/ProgressBarProvider.dart';

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
  ProgressBarProvider? progressProvider;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    progressProvider = Provider.of<ProgressBarProvider>(context, listen: false);
    return Scaffold(
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
              "Create Your\nAccount",
              style: TextStyle(color: Colors.white, fontSize: w * 0.06),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: h / 4),
            padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
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
                            color: const Color(0xFFB91635),
                            fontSize: w * 0.05)),
                    TextFormField(
                      controller: _name,
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
                      controller: _emailController,
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
                      controller: _passwordController,
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
                          registration(w, context);
                        }
                      },
                      child: Consumer<ProgressBarProvider>(
                        builder: (context, value, child) => Container(
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
                            child: value.isLoading
                                ? const SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "SIGN UP",
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
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
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
    );
  }

  void registration(double w, context) async {
    try {
      progressProvider!.changeLogging();
      var email = _emailController.text.toString();
      var password = _passwordController.text.toString();

      /// Create user with email and password
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      /// Save user in firebase storage
      await saveUserInFirebaseStorage(email);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Registration Successfully",
          style: TextStyle(fontSize: w * 0.04),
        ),
      ));

      /// After successful signup go to Home page
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              email: _emailController.text.toString(),
            ),
          ));
      progressProvider!.changeLogging();
    } on FirebaseException catch (e) {
      progressProvider!.changeLogging();
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

  Future<void> saveUserInFirebaseStorage(String email) async {
    String id = randomAlphaNumeric(10);
    Map<String, dynamic> userInfo = {
      "Name": _name.text,
      "Email": email,
      "id": id,
      "image": ""
    };

    /// Save user detail in firestore
    await DatabaseMethods().addDetail(userInfo, id);

    /// Save user detail locally
    //  saveUserInSharedPreferences(email, id, _name.text);
  }

  String? validatePass(String? pass) {
    if (pass!.trimLeft().trimRight().isEmpty) {
      return "Please enter password";
    }
    if (pass.length < 6) {
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
