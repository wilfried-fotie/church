import 'package:church/ModelView/Invite.dart';
import 'package:church/ModelView/MyLogin.dart';
import 'package:church/Views/Home.dart';
import 'package:church/Views/Widgets/MyApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/SharedPref.dart';
import 'SignIn.dart';

class Choice extends StatefulWidget {
  const Choice({Key? key}) : super(key: key);

  @override
  State<Choice> createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  bool invite = false;
  @override
  void initState() {
    ProfilPreferences.invite().then((value) => setState(() {
          invite = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Invite prov = Provider.of<Invite>(context);
    return Scaffold(body: Consumer<User?>(builder: (context, ctx, child) {
      return ctx?.uid != null
          ? const Choiseur()
          : prov.logged
              ? const MyApp()
              : const Home();
    }));
  }
}

class Choiseur extends StatefulWidget {
  const Choiseur({Key? key}) : super(key: key);

  @override
  _ChoiseurState createState() => _ChoiseurState();
}

class _ChoiseurState extends State<Choiseur> {
  bool stat = true;

  @override
  void initState() {
    ProfilPreferences.status().then((value) => setState(() {
          stat = value;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return stat ? const MyApp() : const SignIn();
  }
}
