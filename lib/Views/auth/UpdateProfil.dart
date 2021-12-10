import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church/Model/UserModel.dart';
import 'package:church/Services/UserServices.dart';
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
import '../Widgets/getImage.dart';

class UpdateProfil extends StatefulWidget {
  final UserModel? data;
  const UpdateProfil({Key? key, this.data}) : super(key: key);

  @override
  _UpdateProfilState createState() => _UpdateProfilState();
}

class _UpdateProfilState extends State<UpdateProfil> {
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
      appBar: AppBar(
        title: const Text("Modification de profil"),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: StreamBuilder<UserModel>(
              stream: _medData.getStreamUser(_auth!.uid),
              builder: (context, snapshot) {
                UserModel? data = snapshot.data;
                _name.text = data!.name;
                print(data);
                return ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
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
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kPrimaryColor,
                                  border: Border.all(
                                      color: kPrimaryColor, width: 10)),
                              child: ClipRRect(
                                child: CachedNetworkImage(
                                  height: 100,
                                  fit: BoxFit.cover,
                                  imageUrl: data!.photo,
                                  placeholder: (context, url) => const SizedBox(
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    )),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  final result = await showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return const GetImage(rad: true);
                                      });
                                  if (result != null) {
                                    setState(() {
                                      _loader = true;
                                    });
                                    try {
                                      await FileMananger.uploadFile(
                                              result!.path, "Users")
                                          .then((value) {
                                        // _medData.updateUser(
                                        //     UserModel(
                                        //         name: data.name, photo: value!),
                                        //     _auth!.uid);

                                        _medData.setUser(
                                            UserModel(
                                                name: _name.value.text,
                                                photo: value!),
                                            _auth!.uid);

                                        setState(() {
                                          _loader = false;
                                        });
                                      });
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                          msg: "Une erreur est survenu !!! ",
                                          backgroundColor: Colors.red,
                                          fontSize: 18,
                                          textColor: Colors.white);
                                    }
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
                                    hintText: "Nom",
                                    prefixIcon: const Icon(Icons.person))),
                            const SizedBox(
                              height: 40,
                            ),
                            CustomButton(
                                title: "Mofifier votre profil",
                                onClick: () async {
                                  FocusScope.of(context).unfocus;
                                  if (nameKey.currentState!.validate()) {
                                    if (_image != null) {
                                      try {
                                        FileMananger.uploadFile(
                                                _image!.path, "Users")
                                            .then((value) {
                                          _medData.updateUser(
                                              UserModel(
                                                  name: _name.value.text,
                                                  photo: value!),
                                              _auth!.uid);

                                          _name.clear();
                                          setState(() {
                                            _image = null;
                                          });
                                        });
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg: "Une erreur est survenu !!! ",
                                            backgroundColor: Colors.red,
                                            fontSize: 18,
                                            textColor: Colors.white);
                                      }
                                    }
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
                );

                // print(_auth!.uid);
                // return Center(
                //     child: Column(
                //   children: [
                //     Text(_auth!.uid),
                //     const CircularProgressIndicator(
                //       color: kPrimaryColor,
                //     ),
                //   ],
                // ));
              }),
        ),
      ),
    );
  }
}
