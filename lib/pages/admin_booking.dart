import 'package:flutter/material.dart';

class AdminBooking extends StatefulWidget {
  const AdminBooking({super.key});

  @override
  State<AdminBooking> createState() => _AdminBookingState();
}

class _AdminBookingState extends State<AdminBooking> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Bookings"),
        centerTitle: true,
      ),
      body: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: GridView.builder(
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {},
                child: Container(
                  width: w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFFB91635),
                      Color(0xFF621d3c),
                      Color(0xFF311937)
                    ]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      ClipOval(
                          child: Image.asset(
                        "assets/images/man.png",
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Service: Hair Cutting",
                        style:
                            TextStyle(fontSize: w * 0.04, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Name: Rakesh",
                        style:
                            TextStyle(fontSize: w * 0.04, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Date: 12/12/2023",
                        style:
                            TextStyle(fontSize: w * 0.04, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Time: 8:30",
                        style:
                            TextStyle(fontSize: w * 0.04, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
