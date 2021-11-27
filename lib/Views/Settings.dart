import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:church/ModelView/MyLogin.dart';
import 'package:church/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widgets/Iconiseur.dart';

// ignore: must_be_immutable
class Setting extends StatelessWidget {
  Setting({Key? key}) : super(key: key);

  var data = "not";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text("Paramètres", style: kPrimaryText)),
        ListTile(
          title: const Text(
            "Changer de thème",
            style: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.bold),
          ),
          leading: const Icon(Icons.light_mode_rounded),
          onTap: () async {
            AdaptiveTheme.of(context).toggleThemeMode();
          },
        ),
      ],
    ));
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // ignore: prefer_typing_uninitialized_variables
  var data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        const SizedBox(
          height: 30,
        ),
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text("Paramètres", style: kPrimaryText),
        ),
        const SizedBox(
          height: 20,
        ),
        ListTile(
          title: const Text(
            "Votre Compte",
            style: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.bold),
          ),
          leading: const Iiconiseur(icon: Icon(Icons.person)),
          onTap: () async {},
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text(
            "Changer de thème",
            style: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.bold),
          ),
          leading: const Iiconiseur(icon: Icon(Icons.light_mode_rounded)),
          onTap: () async {
            AdaptiveTheme.of(context).toggleThemeMode();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text(
            "Nous Contacter",
            style: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.bold),
          ),
          leading: const Iiconiseur(icon: Icon(Icons.phone)),
          onTap: () async {},
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          enableFeedback: true,
          title: const Text(
            "À  Propos de nous",
            style: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.bold),
          ),
          leading: const Iiconiseur(icon: Icon(Icons.art_track_rounded)),
          onTap: () async {},
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text(
            "Aide",
            style: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.bold),
          ),
          leading: const Iiconiseur(icon: Icon(Icons.help)),
          onTap: () async {},
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text(
            "A porpos de l'application",
            style: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.bold),
          ),
          leading: const Iiconiseur(icon: Icon(Icons.info)),
          onTap: () {
            context.read<MyLogin>().toggleStatus();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text(
            "Se Déconnecter",
            style: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.bold),
          ),
          leading: const Iiconiseur(icon: Icon(Icons.logout)),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    ));
  }
}
