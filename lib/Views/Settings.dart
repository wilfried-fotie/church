import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:church/Model/AdminModel.dart';
import 'package:church/ModelView/Invite.dart';
import 'package:church/ModelView/MyLogin.dart';
import 'package:church/Services/AdminInfo.dart';
import 'package:church/Views/auth/Registration.dart';
import 'package:church/helper/testNotif.dart';
import 'package:church/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/src/provider.dart';

import '../helper/AdHelper.dart';
import '../helper/Notification.dart';
import '../helper/SharedPref.dart';
import 'Admin/Home.dart';
import 'Creator.dart';
import 'Widgets/Iconiseur.dart';
import 'Widgets/NotConnect.dart';
import 'auth/SignIn.dart';
import 'auth/UpdateProfil.dart';

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
            child: const Text("Paramètres", style: kPrimaryText)),
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
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  late final TextEditingController _pass = TextEditingController();
  final AdminInfo _adminInfo = AdminInfo();
  String _error = "";

  bool invite = false;
  @override
  void initState() {
    ProfilPreferences.status().then((value) => setState(() {
          invite = value;
        }));
    super.initState();
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  void onRegister(setState) async {
    // Navigator.of(context).pop(false);
    if (key.currentState!.validate()) {
      AdminModel _admin = await _adminInfo.getAdmin;
      if (_admin.password.toString() != _pass.value.text) {
        setState(() {
          _error = "Mot de passe incorrect";
        });
      }
    }
  }

  void onSingIn(setState) {
    setState(() {
      _error = "";
      _pass.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Invite prov = Provider.of<Invite>(context);

    return Scaffold(
        body: ListView(
      children: [
        const SizedBox(
          height: 30,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Text("Paramètres", style: kPrimaryText),
        ),
        prov.logged
            ? Container()
            : const SizedBox(
                height: 20,
              ),
        prov.logged
            ? Container()
            : ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const UpdateProfil()));
                },
                title: const Text(
                  "Votre Compte",
                  style: TextStyle(
                      fontFamily: "Noto", fontWeight: FontWeight.bold),
                ),
                leading: const Iiconiseur(icon: Icon(Icons.person)),
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
        // const SizedBox(
        //   height: 10,
        // ),
        // ListTile(
        //   title: const Text(
        //     "Nous Contacter",
        //     style: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.bold),
        //   ),
        //   leading: const Iiconiseur(icon: Icon(Icons.phone)),
        //   onTap: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (_) => const MainScreen()));
        //   },
        // ),

        // const SizedBox(
        //   height: 10,
        // ),

        const SizedBox(
          height: 10,
        ),
        prov.logged
            ? const ListTile(
                title: Text(
                  "A propos de l'application",
                  style: TextStyle(
                      fontFamily: "Noto", fontWeight: FontWeight.bold),
                ),
                leading: Iiconiseur(icon: Icon(Icons.info)))
            : Dismissible(
                key: const ValueKey("admin"),
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (context, StateSetter setState) {
                        return AlertDialog(
                          title: const Text("Connexion Administration"),
                          content: SizedBox(
                            height: 120,
                            child: Form(
                              key: key,
                              child: Column(
                                children: [
                                  const Text(
                                      "Entrez le mot de passe administrateur"),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    controller: _pass,
                                    validator: (value) {
                                      if (value!.isEmpty)
                                        return "le mot de passe ne doit pas être null";
                                      if (value.length < 8)
                                        return "Mot de passe incorrect";
                                    },
                                    decoration: inputStyle.copyWith(
                                        hintText: "Mot de passe"),
                                  ),
                                  Text(_error,
                                      style: const TextStyle(color: Colors.red))
                                ],
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () async {
                                  if (key.currentState!.validate()) {
                                    AdminModel _admin =
                                        await _adminInfo.getAdmin;
                                    if (_admin.password.toString() ==
                                        _pass.value.text) {
                                      Navigator.of(context).pop(false);
                                      context.read<MyLogin>().toggleRights();
                                    }
                                  }
                                  onRegister(setState);
                                },
                                child: const Text("Se connecter")),
                            TextButton(
                              onPressed: () {
                                onSingIn(setState);
                                Navigator.of(context).pop(false);
                              },
                              child: const Text("Annuler"),
                            ),
                          ],
                        );
                      });
                    },
                  );
                },
                background: Container(
                    color: kPrimaryColor, child: const Icon(Icons.dashboard)),
                child: ListTile(
                  title: const Text(
                    "A propos de l'application",
                    style: TextStyle(
                        fontFamily: "Noto", fontWeight: FontWeight.bold),
                  ),
                  leading: const Iiconiseur(icon: Icon(Icons.info)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const Creator()));
                    context.read<MyLogin>().toggleStatus();
                  },
                ),
              ),
        const SizedBox(
          height: 10,
        ),
        // ignore: unrelated_type_equality_checks
        context.watch<MyLogin>().admin == true
            ? ListTile(
                title: const Text(
                  "Adminitration de l'Application",
                  style: TextStyle(
                      fontFamily: "Noto", fontWeight: FontWeight.bold),
                ),
                leading:
                    const Iiconiseur(icon: Icon(Icons.dashboard_customize)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
              )
            : Container(),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          title: const Text(
            "Se Déconnecter ",
            style: TextStyle(fontFamily: "Noto", fontWeight: FontWeight.bold),
          ),
          leading: const Iiconiseur(icon: Icon(Icons.logout)),
          onTap: () {
            showDialog(
              context: (context),
              builder: (context) => AlertDialog(
                title: const Text("Voulez vous vraiment vous déconnecter ?"),
                actions: [
                  TextButton(
                      onPressed: prov.logged
                          ? () async {
                              Navigator.of(context).pop(false);

                              ProfilPreferences.toggleInvite();
                              context.read<Invite>().toggleStatus();
                            }
                          : () {
                              FirebaseAuth.instance.signOut();

                              Navigator.of(context).pop(false);
                              // ProfilPreferences.toggleStatus();
                            },
                      child: const Text("Se Déconnecter")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("Annuler")),
                ],
              ),
            );
          },
        ),

        // Container(color: Colors.red, height: 100, child: const MainScreen())
      ],
    ));
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isBannerAdReady = false;

  late final BannerAd _bannerAd = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    request: const AdRequest(),
    size: AdSize.banner,
    listener: BannerAdListener(
      onAdLoaded: (_) {
        setState(() {
          _isBannerAdReady = true;
        });
      },
      onAdFailedToLoad: (ad, err) {
        _isBannerAdReady = false;

        ad.dispose();
      },
    ),
  );

  @override
  void initState() {
    super.initState();

    _bannerAd.load();
    tz.initializeTimeZones();
  }

  @override
  void dispose() {
    _bannerAd.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isBannerAdReady
        ? Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: kSecondaryColor,
              width: _bannerAd.size.width.toDouble(),
              height: _bannerAd.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
          )
        : const Text("Publicite");

    // Scaffold(
    //   body: Center(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         GestureDetector(
    //           onTap: () {
    //             NotificationService().cancelAllNotifications();
    //           },
    //           child: Container(
    //             height: 40,
    //             width: 200,
    //             color: Colors.red,
    //             child: const Center(
    //               child: Text(
    //                 "Cancel All Notifications",
    //               ),
    //             ),
    //           ),
    //         ),
    //         _isBannerAdReady
    //             ? Align(
    //                 alignment: Alignment.topCenter,
    //                 child: Container(
    //                   color: kSecondaryColor,
    //                   width: _bannerAd.size.width.toDouble(),
    //                   height: _bannerAd.size.height.toDouble(),
    //                   child: AdWidget(ad: _bannerAd),
    //                 ),
    //               )
    //             : Container(
    //                 color: kPrimaryColor, width: double.infinity, height: 20),
    //         GestureDetector(
    //           onTap: () async {
    //             tz.initializeTimeZones();
    //             await NotificationService().showNotification(1, "Bonjour",
    //                 "  La méditation du jour est déjà disponible", 2);
    //           },
    //           child: Container(
    //             height: 40,
    //             width: 200,
    //             color: Colors.green,
    //             child: const Center(
    //               child: Text("Show note"),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
