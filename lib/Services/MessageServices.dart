import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../Model/MessageModel.dart';

class MessageServices {
  final medRef = FirebaseFirestore.instance
      .collection('Message')
      .withConverter<MessageModel>(
        fromFirestore: (snapshot, _) =>
            MessageModel.fromJson(snapshot.data()!, snapshot.id),
        toFirestore: (admin, _) => admin.toJson(),
      );

  Future<MessageModel> getMessage(docID) {
    return medRef.doc(docID).get().then((snapshot) => snapshot.data()!);
  }

  Stream<MessageModel> getStreamMessage(docID) {
    return medRef.doc(docID).snapshots().map((doc) => doc.data()!);
  }

  Future<void> addMessage(MessageModel value) async {
    await medRef.add(value);
  }

  Future<void> delete(String value) async {
    await medRef
        .doc(value)
        .delete()
        .then((value) => print("deleted"))
        .catchError((err) => throw Exception("error"));
  }

  Stream<List<MessageModel>> getStreamMessages(int nbre) {
    return medRef
        .orderBy("date", descending: true)
        .limit(nbre)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Stream<MessageModel> get getLastStreamMessages {
    return medRef
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList()[0]);
  }

  Future<void> updateMessage(MessageModel value, String doc) async {
    await medRef
        .doc(doc)
        .update(value.toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> simpleUpdateMessage(
      Map<String, dynamic?> data, String doc) async {
    await medRef
        .doc(doc)
        .update(data)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
