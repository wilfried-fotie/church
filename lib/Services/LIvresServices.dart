import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../Model/LivreModel.dart';

class LivreService {
  final medRef =
      FirebaseFirestore.instance.collection('Livre').withConverter<LivreModel>(
            fromFirestore: (snapshot, _) =>
                LivreModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (admin, _) => admin.toJson(),
          );

  Future<LivreModel> getLivre(docID) {
    return medRef.doc(docID).get().then((snapshot) => snapshot.data()!);
  }

  Stream<LivreModel> getStreamLivre(docID) {
    return medRef.doc(docID).snapshots().map((doc) => doc.data()!);
  }

  Stream<LivreModel?> getDayStreamLivre(String startAt) {
    return medRef
        .where("refDate", isEqualTo: startAt)
        .limit(1)
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty ? snap.docs[0].data() : null);
  }

  Future<void> addLivre(LivreModel value) async {
    await medRef.add(value);
  }

  Future<void> delete(String value) async {
    await medRef
        .doc(value)
        .delete()
        .then((value) => print("deleted"))
        .catchError((err) => throw Exception("error"));
  }

  Stream<List<LivreModel>> getStreamLivres(int nbre) {
    return medRef
        .orderBy("date", descending: true)
        .limit(nbre)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Future<void> updateLivre(LivreModel value, String doc) async {
    await medRef
        .doc(doc)
        .update(value.toJson())
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> simpleUpdateLivre(Map<String, dynamic?> data, String doc) async {
    await medRef
        .doc(doc)
        .update(data)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
