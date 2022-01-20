import 'package:church/helper/SharedPref.dart';
import 'package:flutter/cupertino.dart';

class Invite extends ChangeNotifier {
  bool _logged = false;

  bool val() {
    ProfilPreferences.invite().then((value) => _logged = value);
    return _logged;
  }

  bool get logged => val();

  void toggleStatus() {
    _logged = !_logged;

    notifyListeners();
  }
}
