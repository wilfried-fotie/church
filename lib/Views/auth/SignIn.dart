import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church/Model/UserModel.dart';
import 'package:church/Views/Widgets/CustomButton.dart';
import 'package:church/Views/Widgets/Header.dart';
import 'package:church/Views/Widgets/ProfilePicker.dart';
import 'package:church/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Services/FileManager.dart';
import '../../Services/UserServices.dart';
import '../../helper/SharedPref.dart';
import '../Widgets/MyApp.dart';
import '../Widgets/getImage.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController();
  final User? _auth = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File? _image;
  bool _loader = false;
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
    UserServices _medData = UserServices();

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
              Stack(
                alignment: Alignment.center,
                children: [
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
                          _image != null
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kSecondaryColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Semantics(
                                        label: "image picker",
                                        child: Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                        )),
                                  ))
                              : Container(
                                  height: 100,
                                  width: 100,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  child: const ClipRRect(
                                    child: Icon(Icons.person,
                                        size: 80, color: kTextColor),
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 5,
                                        color: kPrimaryColor,
                                      )),
                                ),
                          IconButton(
                              onPressed: () async {
                                final result = await showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return const GetImage();
                                    });
                                if (result != null) {
                                  setState(() {
                                    _image = result;
                                  });
                                }
                              },
                              icon: const Icon(CupertinoIcons.camera_fill)),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              controller: _name,
                              validator: _namValidator,
                              decoration: inputStyle.copyWith(
                                  hintText: "Prénom ou nom",
                                  prefixIcon: const Icon(Icons.person))),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                              title: "Créer votre profil",
                              onClick: () async {
                                FocusScope.of(context).unfocus;
                                if (nameKey.currentState!.validate()) {
                                  setState(() {
                                    _loader = true;
                                  });
                                  try {
                                    if (_image == null) {
                                      await _medData.setUser(
                                          UserModel(
                                              photo: null,
                                              name: _name.value.text),
                                          _auth!.uid);
                                      ProfilPreferences.toggleStatus();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyApp()));
                                    } else {
                                      await FileMananger.uploadFile(
                                              _image!.path, "Users")
                                          .then((value) async {
                                        await _medData.setUser(
                                            UserModel(
                                                photo: value!,
                                                name: _name.value.text),
                                            _auth!.uid);
                                        ProfilPreferences.toggleStatus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyApp()));
                                        setState(() {
                                          _loader = false;
                                        });
                                      });
                                    }
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: "Une erreur est survenu !!! ",
                                        backgroundColor: Colors.red,
                                        fontSize: 18,
                                        textColor: Colors.white);
                                  }
                                }
                                FocusScope.of(context).unfocus();
                              }),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _loader
                      ? const Center(
                          child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: kPrimaryColor),
                              )),
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
