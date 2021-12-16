import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../Model/PubModel.dart';

class PubService {
  final medRef =
      FirebaseFirestore.instance.collection('Pub').withConverter<PubModel>(
            fromFirestore: (snapshot, _) =>
                PubModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (admin, _) => admin.toJson(),
          );

  Future<PubModel> getPub(docID) {
    return medRef.doc(docID).get().then((snapshot) => snapshot.data()!);
  }

  Stream<PubModel> getStreamPub(docID) {
    return medRef.doc(docID).snapshots().map((doc) => doc.data()!);
  }

  Stream<PubModel?> getDayStreamPub(String startAt) {
    return medRef
        .where("refDate", isEqualTo: startAt)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty ? snap.docs[0].data() : null);
  }

  Future<void> addPub(PubModel value) async {
    await medRef.add(value);
  }

  Future<void> delete(String value) async {
    await medRef
        .doc(value)
        .delete()
        .then((value) => print("deleted"))
        .catchError((err) => throw Exception("error"));
  }

  Stream<List<PubModel>> getStreamPubs(int nbre) {
    return medRef
        .orderBy("date", descending: true)
        .limit(nbre)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Future<void> updatePub(PubModel value, String doc) async {
    await medRef
        .doc(doc)
        .update(value.toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> simpleUpdatePub(Map<String, dynamic> data, String doc) async {
    await medRef
        .doc(doc)
        .update(data)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
