
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods  {

  Future addDetail(Map<String, dynamic> userInfo, String id) async
  {
    await FirebaseFirestore.instance.collection("users").doc(id).set(userInfo);
  }
}