import 'package:church/Model/Enseignement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EnseignementService {
  final medRef = FirebaseFirestore.instance
      .collection('Enseignement')
      .withConverter<EnseignementModel>(
        fromFirestore: (snapshot, _) =>
            EnseignementModel.fromJson(snapshot.data()!, snapshot.id),
        toFirestore: (admin, _) => admin.toJson(),
      );

  Future<void> addEnseignement(EnseignementModel value) async {
    await medRef.add(value);
  }

  Future<void> delete(String value) async {
    await medRef
        .doc(value)
        .delete()
        .then((value) => null)
        .catchError((err) => throw Exception("error"));
  }

  Stream<List<EnseignementModel>> getStreamEnseignements(int nbre) {
    return medRef
        .orderBy("date", descending: true)
        .limit(nbre)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Future<void> updateEnseignement(EnseignementModel value, String doc) async {
    await medRef
        .doc(doc)
        .update(value.toJson())
        .then((value) => null)
        .catchError((error) => throw Exception("Some Error"));
  }
}
