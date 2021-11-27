import 'package:flutter/cupertino.dart';

class BottomNavigationOffstage extends ChangeNotifier {
  bool _show = true;
  bool get show => _show;

  void toggleStatus() {
    _show = !_show;
    notifyListeners();
  }
}
