import 'dart:developer';
import 'package:barbar_booking_app/pages/booking_page.dart';
import 'package:barbar_booking_app/pages/sign_up.dart';
import 'package:barbar_booking_app/services/shared_prefrences.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';
import '../utils/confirmation_dialog.dart';

class HomePage extends StatefulWidget {
  final email;

  const HomePage({required this.email, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName = "";

  void getUserName() async {
    try {
      userName =
          await DatabaseMethods().getNameByEmail(widget.email.toString());
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    /// Getting Name of the user who is loged in
    getUserName();
  }

  void showLogoutDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmLogoutDialog(
        onLogout: () async {
          await SharedPreferencesHelper().clearUserId();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpPage(),
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    List<String> imageList = [];
    List<String> serviceNameList = [];
    serviceNameList.add("Classic Shaving");
    serviceNameList.add("Beard Trimming");
    serviceNameList.add("Hair Cutting");
    serviceNameList.add("Facials");
    serviceNameList.add("Hair Washing");
    serviceNameList.add("Kids Haircut");

    imageList.add("assets/images/shaving.png");
    imageList.add("assets/images/beard.png");
    imageList.add("assets/images/cutting.png");
    imageList.add("assets/images/facials.png");
    imageList.add("assets/images/hair.png");
    imageList.add("assets/images/kids.png");

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF2b1615),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () async {
                        /// Logout user
                        showLogoutDialog(context);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ))
                ],
              ),
              const Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: TextStyle(
                            color: const Color.fromARGB(197, 255, 255, 255),
                            fontSize: w * 0.06),
                      ),
                      Text(
                        "$userName",
                        style:
                            TextStyle(color: Colors.white, fontSize: w * 0.06),
                      )
                    ],
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/images/boy.jpg",
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.white38,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Services",
                style: TextStyle(color: Colors.white, fontSize: w * 0.06),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: imageList.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookingPage(userName:userName.toString(), service: serviceNameList[index]),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 60,
                                width: 60,
                                child: Image.asset(imageList[index])),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              serviceNameList[index],
                              style: TextStyle(
                                  color: Colors.white, fontSize: w * 0.06),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
