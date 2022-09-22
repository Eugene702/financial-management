import 'package:cloud_firestore/cloud_firestore.dart';

class DetailDataFunction{
  final CollectionReference _database = FirebaseFirestore.instance.collection("data");
  final CollectionReference _databaseMutation = FirebaseFirestore.instance.collection("mutation");

  Future<void> updateData({
    required String id,
    required Map<String, Object> data
  }) async => _database.doc(id).update(data);

  Future<void> addDataMutation({
    required String id,
    required String mount,
    required int value
  }) => _databaseMutation.add({"id": id, "mount": mount, "value": value});

  Future<void> removeMutation(String id) => _databaseMutation.doc(id).delete();

  Future<void> removeUser(String id) async{
    return _databaseMutation.where("id", isEqualTo: id).get().then((value){
      for (var element in value.docs) {
        FirebaseFirestore.instance.collection("mutation").doc(element.id).delete();
      }
    }).then((value) => _database.doc(id).delete());
  }

  Future<void> updateMutation(String id, Map<String, Object> data) => _databaseMutation.doc(id).update(data);
}