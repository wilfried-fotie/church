import 'package:church/Model/AdminModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminInfo {
  final adminRef = FirebaseFirestore.instance
      .collection('admin')
      .withConverter<AdminModel>(
        fromFirestore: (snapshot, _) => AdminModel.fromJson(snapshot.data()!),
        toFirestore: (admin, _) => admin.toJson(),
      );

  Future<AdminModel> get getAdmin {
    return adminRef
        .doc('QFcVSnUbE64bpFfVtJkd')
        .get()
        .then((snapshot) => snapshot.data()!);
  }

  Stream<DocumentSnapshot<AdminModel>> get getStreamAdmin {
    return adminRef.doc('QFcVSnUbE64bpFfVtJkd').snapshots();
  }
}
