import 'dart:developer';
import 'package:barbar_booking_app/providers/ProgressBarProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';
import '../services/shared_prefrences.dart';

class BookingPage extends StatefulWidget {
  String service;
  String userName;

  BookingPage({required this.userName, required this.service, super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> selectedTime = ValueNotifier(TimeOfDay.now());
  String? userName = "";
  String? email = "";
  ProgressBarProvider? provider;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2120),
    );
    if (picked != null && picked != selectedDate.value) {
      setState(() {
        selectedDate.value = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime.value) {
      setState(() {
        selectedTime.value = pickedTime;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    provider = Provider.of<ProgressBarProvider>(context, listen: false);
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
                              selectedTime.format(context),
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
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  final time = "${selectedTime.value.format(context)}";
                  final email =
                      await DatabaseMethods().getEmailByName(widget.userName);
                  final date =
                      "${selectedDate.value.day}/${selectedDate.value.month}/${selectedDate.value.year}";
                  Map<String, dynamic> booking = {
                    "Service": widget.service,
                    "Date": date,
                    "Time": time,
                    "User": widget.userName,
                    "Image": "",
                    "Email": email
                  };
                  provider!.changeLogging();
                  final isSaved =
                      await DatabaseMethods().addUserBooking(booking);

                  if (isSaved) {
                    provider!.changeLogging();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Service has been booked successfully!",
                        style: TextStyle(fontSize: w * 0.04),
                      ),
                    ));
                  } else {
                    provider!.changeLogging();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Slot isn't available",
                        style: TextStyle(fontSize: w * 0.04),
                      ),
                    ));
                  }
                },
                child: Consumer<ProgressBarProvider>(
                  builder: (context, value, child) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: w,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: value.isLoading
                            ? Container(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Get a Stylish HairCut",
                                style: TextStyle(
                                    fontSize: w * 0.06, color: Colors.white),
                              )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
