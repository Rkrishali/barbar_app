import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatabaseMethods {
  Future addDetail(Map<String, dynamic> userInfo, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .set(userInfo);
    } on FirebaseFirestore catch (e) {
      log(e.toString());
    }
  }

  Future<String> getNameByEmail(String email) async {
    String name = "";
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("Email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
           final data =  querySnapshot.docs;
        if (data != null) {
          name =  data.first.get("Name");
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return name;
  }

  Future<String> getEmailByName(String name) async {
    String email = "";
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("Name", isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data =  querySnapshot.docs;
        if (data != null) {
          email =  data.first.get("Email");
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return email;
  }

  Future<bool> addUserBooking(Map<String, dynamic> bookingDetail) async {
    try {
      /// Check is booking already present in 30 minute duration
      final isPresent = await _isBookingAlreadyPresent(bookingDetail["Time"]);

      if (isPresent) {
        await FirebaseFirestore.instance
            .collection("booking")
            .add(bookingDetail);
        return true;
      }
    } on FirebaseFirestore catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> _isBookingAlreadyPresent(String time) async {
    /// Getting list of time slots from database
    final timeSlots = await getAllTimeSlots();

    for (String start in timeSlots) {
      /// Calculating difference between two times
      final diff = calculateTimeDifference(start, time);
      if (diff <= 30) {
        return false;
      }
    }

    return true;
  }

  int calculateTimeDifference(String startTime, String endTime) {
    final DateFormat format = DateFormat("hh:mm a");
    final DateTime startTimeParsed = format.parse(startTime);
    final DateTime endTimeParsed = format.parse(endTime);

    if (startTimeParsed.isBefore(endTimeParsed)) {
      final Duration difference = endTimeParsed.difference(startTimeParsed);
      return difference.inMinutes;
    } else {
      final Duration difference = startTimeParsed.difference(endTimeParsed);
      return difference.inMinutes;
    }
  }

  Future<List<String>> getAllTimeSlots() async {
    List<String> timeSlots = [];

    // Query the "booking" collection
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("booking").get();

    // Loop through each document in the snapshot
    for (var document in snapshot.docs) {
      // Cast the document data to Map<String, dynamic>
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      // Check if the document data is not null
      if (data != null) {
        // Extract the time slot from each document
        String? timeSlot = data["Time"];
        if (timeSlot != null) {
          timeSlots.add(timeSlot);
        }
      }
    }

    return timeSlots;
  }
}
