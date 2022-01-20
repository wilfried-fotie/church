import 'package:church/helper/SharedPref.dart';
import 'package:church/helper/extention.dart';
import 'package:flutter/material.dart';
import '../tools.dart';
import 'Widgets/CustomButton.dart';
import 'Widgets/Header.dart';
import 'auth/Registration.dart';
import 'auth/SignIn.dart';

enum CurrentPage { HOME, SIGN_IN, REGISTER }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CurrentPage pageManager = CurrentPage.HOME;
  bool invite = false;
  @override
  void initState() {
    ProfilPreferences.status().then((value) => setState(() {
          invite = value;
        }));
    super.initState();
  }

  void onRegister() {
    setState(() {
      pageManager = CurrentPage.SIGN_IN;
    });
  }

  void onSingIn() {
    setState(() {
      pageManager = CurrentPage.REGISTER;
    });
  }

  void onHome() {
    setState(() {
      pageManager = CurrentPage.HOME;
    });
  }

  @override
  Widget build(BuildContext context) {
    return pageManager == CurrentPage.HOME
        ? Scaffold(
            body: Column(children: [
              const Header(
                title: "Église Évengélique Du Cameroun",
                pad: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage("asset/img/icons/logo.png"),
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Image(
                    image: const AssetImage("asset/img/cesic.jpeg"),
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text("Bienvenue",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      color: kTextColor)),
              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "L' application qui vous accompagne sur le chemin de la foie...",
                  textAlign: TextAlign.center,
                ),
              ),

              // CustomButton(
              //     title: "Créer un compte",
              //     onClick: onRegister,
              //     border: true),
              const SizedBox(height: 20),
              CustomButton(
                title: "Commencer maintenant ",
                onClick: onSingIn,
              )
            ]),
          )
        : pageManager == CurrentPage.SIGN_IN
            ? const SignIn()
            : const Registration();
  }
}
