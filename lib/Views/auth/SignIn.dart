import 'dart:async';
import 'dart:io';
import 'package:church/Model/UserModel.dart';
import 'package:church/Views/Widgets/CustomButton.dart';
import 'package:church/Views/Widgets/Header.dart';
import 'package:church/Views/Widgets/ProfilePicker.dart';
import 'package:church/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  String? _namValidator(String? name) {
    if (name!.isEmpty) return "le nom est réquis";
    if (name.length < 3) return "le nom doit faire au moins 3 caractères";
    if (name.length > 255)
      return "le nom ne doit pas faire plus de 255 caractères";
  }

  @override
  Widget build(BuildContext context) {
    var _userRef = firestore.collection("users").withConverter<UserModel>(
          fromFirestore: (snapshot, _) =>
              UserModel.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (user, _) => user.toJson(),
        );
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const Header(
                title: "Création de profil",
                pad: true,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Form(
                  key: nameKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const ProfilPicker(),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: _name,
                          validator: _namValidator,
                          decoration: inputStyle.copyWith(
                              hintText: "Nom et prénom",
                              prefixIcon: const Icon(Icons.person))),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          title: "Créer votre profil",
                          onClick: () async {
                            FocusScope.of(context).unfocus;
                            if (nameKey.currentState!.validate()) {
                              _userRef
                                  .add(UserModel(
                                      name: _name.value.text, photo: "nada"))
                                  .then((value) => Fluttertoast.showToast(
                                      msg: "Great",
                                      backgroundColor: kPrimaryColor,
                                      fontSize: 18,
                                      textColor: Colors.white));
                            }
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
