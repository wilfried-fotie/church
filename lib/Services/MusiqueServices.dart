import 'package:church/Model/MusiqueModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusiqueServices {
  final medRef = FirebaseFirestore.instance
      .collection('Musique')
      .withConverter<MusiqueModel>(
        fromFirestore: (snapshot, _) =>
            MusiqueModel.fromJson(snapshot.data()!, snapshot.id),
        toFirestore: (admin, _) => admin.toJson(),
      );

  Future<MusiqueModel> getMusique(docID) {
    return medRef.doc(docID).get().then((snapshot) => snapshot.data()!);
  }

  Stream<MusiqueModel> getStreamMusique(docID) {
    return medRef.doc(docID).snapshots().map((doc) => doc.data()!);
  }

  Stream<MusiqueModel?> getDayStreamMusique(String startAt) {
    return medRef
        .where("refDate", isEqualTo: startAt)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty ? snap.docs[0].data() : null);
  }

  Future<void> addMusique(MusiqueModel value) async {
    await medRef.add(value);
  }

  Future<void> delete(String value) async {
    await medRef
        .doc(value)
        .delete()
        .then((value) => print("deleted"))
        .catchError((err) => throw Exception("error"));
  }

  Stream<List<MusiqueModel>> getStreamMusiques(int nbre) {
    return medRef
        .orderBy("date", descending: true)
        .limit(nbre)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Future<void> updateMusique(MusiqueModel value, String doc) async {
    await medRef
        .doc(doc)
        .update(value.toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> simpleUpdateMusique(
      Map<String, dynamic> data, String doc) async {
    await medRef
        .doc(doc)
        .update(data)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
