import 'dart:developer';

import 'package:barbar_booking_app/pages/admin_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/login.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
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
              "Admin\nPanel",
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
                    Text("Username",
                        style: TextStyle(
                            color: const Color(0xFFB91635),
                            fontSize: w * 0.05)),
                    TextFormField(
                      validator: (name) {
                        if (name!.trim().isEmpty) {
                          return "Username required";
                        }
                        return null;
                      },
                      controller: _userNameController,
                      decoration: const InputDecoration(
                          hintText: "username", prefixIcon: Icon(Icons.mail)),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text("Password",
                        style: TextStyle(
                            color: const Color(0xFFB91635),
                            fontSize: w * 0.05)),
                    TextFormField(
                      validator: (password) {
                        if (password!.trim().isEmpty) {
                          return "Password required";
                        } else if (password.length < 6) {
                          return "Password is too short";
                        }
                        return null;
                      },
                      controller: _passwordController,
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
                           adminLogin(w);
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
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.06,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void adminLogin(w) {
    try {
      FirebaseFirestore.instance.collection("Admin").get().then((snapshot) => {
            snapshot.docs.forEach((result) {
              if (result.data()['id'] != _userNameController.text.trim()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Your id isn't correct",
                    style: TextStyle(fontSize: w * 0.04),
                  ),
                ));
              } else if (result.data()['password'] !=
                  _passwordController.text.trim()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Your password isn't correct",
                    style: TextStyle(fontSize: w * 0.04),
                  ),
                ));
              } else {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminBooking(),
                    ));
              }
            })
          });
    } on FirebaseException catch (e) {
      log(e.message.toString());
    }
  }
}
