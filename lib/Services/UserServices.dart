import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../Model/UserModel.dart';

class UserServices {
  final medRef =
      FirebaseFirestore.instance.collection('Users').withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (admin, _) => admin.toJson(),
          );

  Future<UserModel> getUser(docID) {
    return medRef.doc(docID).get().then((snapshot) => snapshot.data()!);
  }

  Stream<UserModel> getStreamUser(docID) {
    return medRef.doc(docID).snapshots().map((doc) => doc.data()!);
  }

  Future<void> addUser(UserModel value) async {
    await medRef.add(value);
  }

  Future<void> setUser(UserModel value, String id) async {
    await medRef.doc(id).set(value);
  }

  Future<void> delete(String value) async {
    await medRef
        .doc(value)
        .delete()
        .then((value) => print("deleted"))
        .catchError((err) => throw Exception("error"));
  }

  Stream<List<UserModel>> getStreamUsers(int nbre) {
    return medRef
        .orderBy("date", descending: true)
        .limit(nbre)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Stream<UserModel> get getLastStreamUsers {
    return medRef
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList()[0]);
  }

  Future<void> updateUser(UserModel value, String doc) async {
    await medRef
        .doc(doc)
        .update(value.toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> simpleUpdateUser(Map<String, dynamic> data, String doc) async {
    await medRef
        .doc(doc)
        .update(data)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
