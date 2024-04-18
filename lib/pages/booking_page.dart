import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  String service;

  BookingPage({required this.service, super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final DateTime _currentDate = DateTime.now();
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> selectedTime = ValueNotifier(TimeOfDay.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF2b1615),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2b1615),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's the \njourney begin",
                style: TextStyle(color: Colors.white70, fontSize: w * 0.06),
              ),
              SizedBox(height: h * 0.04),
              Image.asset("assets/images/discount.png"),
              SizedBox(height: h * 0.04),
              Text(
                widget.service,
                style: TextStyle(
                    fontSize: w * 0.06,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: h * 0.04),
              Container(
                height: h * 0.14,
                width: w,
                decoration: BoxDecoration(
                    color: const Color(0xFFb4817e),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Set a Date",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.06),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ValueListenableBuilder<DateTime>(
                      valueListenable: selectedDate,
                      builder: (context, selectedDate, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                  size: 40,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: w * 0.07),
                            )
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: h * 0.04),
              Container(
                height: h * 0.14,
                width: w,
                decoration: BoxDecoration(
                    color: const Color(0xFFb4817e),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Set a Time",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.06),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ValueListenableBuilder<TimeOfDay>(
                      valueListenable: selectedTime,
                      builder: (context, selectedTime, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  _selectTime(context);
                                },
                                child: const Icon(
                                  Icons.timer,
                                  color: Colors.white,
                                  size: 40,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${selectedTime.hour}:${selectedTime.minute} ${selectedTime.period.name.toUpperCase()}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: w * 0.07),
                            )
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                width: w,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("Get a Stylish HairCut", style: TextStyle(fontSize: w * 0.06, color: Colors.white),)),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}
