import 'package:firebase_auth/firebase_auth.dart';

class Authentification {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future singnOut() async {
    try {
      return _auth.signOut();
    } catch (error) {
      print(error.toString());

      return null;
    }
  }
}
