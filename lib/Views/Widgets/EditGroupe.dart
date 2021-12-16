import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../ModelView/BottomNavigationOffstage.dart';
import '../../Services/FileManager.dart';
import '../../Services/GroupesServeices.dart';
import '../../tools.dart';
import '../Groups.dart';
import 'SmallButton.dart';
import 'getImage.dart';

class EditGroupe extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditGroupe(this.data, {Key? key}) : super(key: key);

  @override
  State<EditGroupe> createState() => _EditGroupeState();
}

class _EditGroupeState extends State<EditGroupe> {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Modifier le groupe"),
        ),
        body: SafeArea(
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: StreamBuilder<Map<String, dynamic>>(
                    stream: DatabaseService()
                        .getFutureGroup(widget.data["groupId"]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data!;
                        _name.text = data["groupName"] ?? "";
                        return ListView(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 20),
                                  child: Form(
                                    key: nameKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        data["groupIcon"] != null && !_loader
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kSecondaryColor,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Semantics(
                                                    label: "image picker",
                                                    child: CachedNetworkImage(
                                                      height: 100,
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          data["groupIcon"],
                                                      placeholder:
                                                          (context, url) =>
                                                              const SizedBox(
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          color: kPrimaryColor,
                                                        )),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ))
                                            : Container(
                                                height: 100,
                                                width: 100,
                                                child: FittedBox(
                                                  child: Image.asset(
                                                      "asset/img/logo.png"),
                                                ),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle),
                                              ),
                                        IconButton(
                                            onPressed: () async {
                                              final result =
                                                  await showModalBottomSheet(
                                                      context: context,
                                                      builder:
                                                          (BuildContext bc) {
                                                        return const GetImage(
                                                            rad: true);
                                                      });
                                              if (result != null) {
                                                setState(() {
                                                  _loader = true;
                                                });
                                                try {
                                                  data["groupIcon"] != null
                                                      ? await FileMananger
                                                          .delete(
                                                              data["groupIcon"])
                                                      : null;
                                                  await FileMananger.uploadFile(
                                                          result!.path, "Group")
                                                      .then((value) async {
                                                    await DatabaseService()
                                                        .simpleUpdateUser({
                                                      "groupIcon": value,
                                                      "groupName":
                                                          data["groupName"]
                                                    }, data["groupId"]).then(
                                                            (value) {
                                                      setState(() {
                                                        _loader = true;
                                                      });
                                                      context
                                                          .read<
                                                              BottomNavigationOffstage>()
                                                          .toggleStatus();
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const Groups()),
                                                          (route) => false);
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    });
                                                  });
                                                } catch (e) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Une erreur est survenu !!! ",
                                                      backgroundColor:
                                                          Colors.red,
                                                      fontSize: 18,
                                                      textColor: Colors.white);
                                                }
                                              }
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.camera_fill)),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            controller: _name,
                                            validator: _namValidator,
                                            decoration: inputStyle.copyWith(
                                                hintText: "Nom",
                                                prefixIcon:
                                                    const Icon(Icons.person))),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 100),
                                          child: SmallButton(
                                              title: "Enregistrer ",
                                              onClick: () async {
                                                FocusScope.of(context).unfocus;
                                                if (nameKey.currentState!
                                                    .validate()) {
                                                  await DatabaseService()
                                                      .simpleUpdateUser({
                                                    "groupName":
                                                        _name.value.text,
                                                    "groupIcon":
                                                        data["groupIcon"],
                                                  }, data["groupId"]).then(
                                                          (value) {
                                                    context
                                                        .read<
                                                            BottomNavigationOffstage>()
                                                        .toggleStatus();
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Groups()),
                                                        (route) => false);
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  });
                                                }
                                              }),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _loader
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                        color: kPrimaryColor,
                                      ))
                                    : Container()
                              ],
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child:
                              CircularProgressIndicator(color: kPrimaryColor),
                        );
                      }
                    }))));
  }
}
