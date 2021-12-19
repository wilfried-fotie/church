import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../Model/ParoissesModel.dart';

class ParoissesService {
  final medRef = FirebaseFirestore.instance
      .collection('Paroisses')
      .withConverter<Paroisses>(
        fromFirestore: (snapshot, _) =>
            Paroisses.fromJson(snapshot.data()!, snapshot.id),
        toFirestore: (admin, _) => admin.toJson(),
      );

  Future<Paroisses> getParoisses(docID) {
    return medRef.doc(docID).get().then((snapshot) => snapshot.data()!);
  }

  Stream<Paroisses> getStreamParoisses(docID) {
    return medRef.doc(docID).snapshots().map((doc) => doc.data()!);
  }

  Stream<Paroisses?> getDayStreamParoisses(String startAt) {
    return medRef
        .where("refDate", isEqualTo: startAt)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty ? snap.docs[0].data() : null);
  }

  Stream<List<Paroisses>> getMonthStreamParoisses(String startAt) {
    return medRef
        .where("month", isEqualTo: startAt)
        .limit(7)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Future<List<Paroisses>> getMonthParoisses(String startAt) {
    return medRef
        .where("month", isEqualTo: startAt)
        .get()
        .then((snapshot) => snapshot.docs.map((e) => e.data()).toList());
  }

  Future<void> addParoisses(Paroisses value) async {
    await medRef.add(value);
  }

  Stream<List<Paroisses>> get getStreamParoissess {
    return medRef
        .orderBy("date", descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Future<void> delete(String doc) async {
    await medRef
        .doc(doc)
        .delete()
        .then((value) => print("User dete"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> updateParoisses(Paroisses value, String doc) async {
    await medRef
        .doc(doc)
        .update(value.toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
