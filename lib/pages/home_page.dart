import 'package:barbar_booking_app/pages/booking_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
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
                        "Aman Singh Rawat",
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
                                  BookingPage(service: serviceNameList[index]),
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
