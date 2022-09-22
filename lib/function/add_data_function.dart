import 'package:cloud_firestore/cloud_firestore.dart';

class AddDataFunction{
  CollectionReference data = FirebaseFirestore.instance.collection("data");

  Future<void> saveData({
    required String name,
    required String pin,
    required String color,
    required bool status
  })async {
    data.add({
      "name": name,
      "pin": pin,
      "color": color,
      "user_active": status
    });
  }
}