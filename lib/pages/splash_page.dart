import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF2b1615),
      body: Container(
        margin: EdgeInsets.only(top: h * 0.09),
        child: Column(
          children: [
            Image.asset("assets/images/barber.png"),
             SizedBox(height: h * 0.04,),
             Container(
               padding: const EdgeInsets.all(10),
               decoration: BoxDecoration(
                 color: const Color(0xFFdf711a),
                 borderRadius: BorderRadius.circular(10)
               ),
              child: const Text("Get a Stylist Haircut", style: TextStyle(color: Colors.white, fontSize: 20),),
            )
          ],
        ),
      ),
    );
  }
}
