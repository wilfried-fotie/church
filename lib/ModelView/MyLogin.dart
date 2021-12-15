import 'package:flutter/cupertino.dart';

class MyLogin extends ChangeNotifier {
  bool _login = false;
  bool _admin = false;

  bool get login => _login;
  bool get admin => _admin;

  void toggleStatus() {
    _login = !_login;
    notifyListeners();
  }

  void toggleRights() {
    _admin = !_admin;
    notifyListeners();
  }
}
