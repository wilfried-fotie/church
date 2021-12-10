import 'package:church/Model/Meditation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MeditationService {
  final medRef = FirebaseFirestore.instance
      .collection('meditations')
      .withConverter<Meditation>(
        fromFirestore: (snapshot, _) =>
            Meditation.fromJson(snapshot.data()!, snapshot.id),
        toFirestore: (admin, _) => admin.toJson(),
      );

  Future<Meditation> getMeditation(docID) {
    return medRef.doc(docID).get().then((snapshot) => snapshot.data()!);
  }

  Stream<Meditation> getStreamMeditation(docID) {
    return medRef.doc(docID).snapshots().map((doc) => doc.data()!);
  }

  Stream<Meditation?> getDayStreamMeditation(String startAt) {
    return medRef
        .where("refDate", isEqualTo: startAt)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty ? snap.docs[0].data() : null);
  }

  Stream<List<Meditation>> getMonthStreamMeditation(String startAt) {
    return medRef
        .where("month", isEqualTo: startAt)
        .limit(30)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Future<List<Meditation>> getMonthMeditation(String startAt) {
    return medRef
        .where("month", isEqualTo: startAt)
        .get()
        .then((snapshot) => snapshot.docs.map((e) => e.data()).toList());
  }

  Future<bool> deleteAll() async {
    await medRef.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
      return true;
    });
    return false;
  }

  Future<void> addMeditation(Meditation value) async {
    await medRef.add(value);
  }

  Stream<List<Meditation>> getStreamMeditations(int nbre) {
    return medRef
        .orderBy("date", descending: true)
        .limit(nbre)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Future<void> updateMeditation(Meditation value, String doc) async {
    await medRef
        .doc(doc)
        .update(value.toJson())
        .then((value) => null)
        .catchError((error) => throw Exception("erreur"));
    ;
  }
}
