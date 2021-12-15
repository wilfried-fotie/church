import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church/Model/UserModel.dart';
import 'package:church/Views/Widgets/ProfilePicker.dart';
import 'package:church/Views/Widgets/SmallButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import '../Model/MessageModel.dart';
import '../ModelView/BottomNavigationOffstage.dart';
import '../Services/FileManager.dart';
import '../Services/GroupesServeices.dart';
import '../Services/MessageServices.dart';
import '../Services/UserServices.dart';
import '../tools.dart';
import 'Tchat/ChatMesage.dart';
import 'Widgets/CustomGroupListitle.dart';
import 'Widgets/getImage.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  final MessageServices _medData = MessageServices();
  File? _image;
  final _auth = FirebaseAuth.instance.currentUser;
  bool loader = false, _switch = true;
  void clear() {
    name.clear();
    loader = false;
    _image = null;
  }

  GlobalKey<FormState> key = GlobalKey<FormState>();
  late TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: kSecondaryColor,
            child: const Icon(Icons.add, color: kPrimaryColor),
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder:
                      (context) => StatefulBuilder(
                              builder: (context, StateSetter setState) {
                            return Stack(
                                alignment: loader
                                    ? Alignment.bottomCenter
                                    : Alignment.bottomCenter,
                                children: [
                                  FractionallySizedBox(
                                      heightFactor: 0.6,
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20))),
                                          child: GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              child: SingleChildScrollView(
                                                  reverse: true,
                                                  child: Form(
                                                      key: key,
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                          },
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomRight,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            5.0,
                                                                        right:
                                                                            5),
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          clear();
                                                                          Navigator.of(context)
                                                                              .pop(false);
                                                                        },
                                                                        icon: const Icon(Icons.close)),
                                                                  ),
                                                                ),
                                                                const Text(
                                                                  "Ajouter Un Groupe",
                                                                  style:
                                                                      kBoldText,
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                _image != null
                                                                    ? ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                50),
                                                                        child:
                                                                            Semantics(
                                                                          label:
                                                                              "image picker",
                                                                          child:
                                                                              Image.file(
                                                                            File(_image!.path),
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                100,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ))
                                                                    : const CircleAvatar(
                                                                        backgroundImage:
                                                                            AssetImage("asset/img/logo.png"),
                                                                      ),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            5.0,
                                                                        right:
                                                                            5),
                                                                    child: Row(
                                                                      children: [
                                                                        const Align(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 25.0),
                                                                            child:
                                                                                Text(
                                                                              "Importer l'image du groupe",
                                                                              style: TextStyle(fontSize: 18),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                20),
                                                                        IconButton(
                                                                            onPressed:
                                                                                () async {
                                                                              try {
                                                                                final result = await showModalBottomSheet(
                                                                                    context: context,
                                                                                    builder: (BuildContext bc) {
                                                                                      return const GetImage(rad: true);
                                                                                    });

                                                                                setState(() {
                                                                                  _image = result;
                                                                                });
                                                                              } catch (err) {
                                                                                print(err);
                                                                                print("err");
                                                                              }
                                                                            },
                                                                            icon:
                                                                                const Icon(Icons.photo_camera)),
                                                                      ],
                                                                    )),
                                                                const SizedBox(
                                                                    height: 20),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          20.0,
                                                                      right:
                                                                          20),
                                                                  child:
                                                                      TextFormField(
                                                                    autovalidateMode:
                                                                        AutovalidateMode
                                                                            .onUserInteraction,
                                                                    controller:
                                                                        name,
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .trim()
                                                                          .isEmpty)
                                                                        return "Ce champ est réquis";
                                                                      if (value
                                                                              .length <
                                                                          3)
                                                                        return "Ce champ doit faire au moins 3 caractères";
                                                                      if (value
                                                                              .length >
                                                                          255)
                                                                        return "Ce champ doit faire au max 255 caractères";
                                                                    },
                                                                    decoration: inputStyle.copyWith(
                                                                        labelText:
                                                                            "Nom du groupe"),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    SmallButton(
                                                                        title:
                                                                            "Créer le groupe",
                                                                        onClick:
                                                                            () async {
                                                                          try {
                                                                            if (key.currentState!.validate() &&
                                                                                _image == null) {
                                                                              setState(() {
                                                                                loader = true;
                                                                              });
                                                                              UserModel user = await UserServices().getUser(_auth!.uid);
                                                                              await DatabaseService(uid: user.id).createGroup(user.name, name.value.text, null);
                                                                              Navigator.of(context).pop();
                                                                              clear();
                                                                              FocusScope.of(context).unfocus();
                                                                            }

                                                                            if (key.currentState!.validate() &&
                                                                                _image != null) {
                                                                              setState(() {
                                                                                loader = true;
                                                                              });
                                                                              FileMananger.uploadFile(_image!.path, "Group").then((value) async {
                                                                                UserModel user = await UserServices().getUser(_auth!.uid);
                                                                                await DatabaseService(uid: user.id).createGroup(user.name, name.value.text, value).then((value) {
                                                                                  Navigator.of(context).pop();
                                                                                  clear();
                                                                                  FocusScope.of(context).unfocus();
                                                                                });
                                                                              });
                                                                            }
                                                                          } catch (err) {
                                                                            Fluttertoast.showToast(
                                                                                msg: "Une erreur est survenu !!! ",
                                                                                backgroundColor: Colors.red,
                                                                                fontSize: 18,
                                                                                textColor: Colors.white);
                                                                            FocusScope.of(context).unfocus();
                                                                          } finally {}
                                                                        }),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          clear();

                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            "Annuler"))
                                                                  ],
                                                                ),
                                                              ]))))))),
                                  loader
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                              color: kPrimaryColor),
                                        )
                                      : Container()
                                ]);
                          }));
            }),
        body: StreamBuilder<QuerySnapshot>(
            stream: DatabaseService().getGroups(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Une Erreur c'est produite");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor),
                );
              }
              if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Aucun Groupe A Découvrir',
                        style: kPrimaryText.copyWith(color: kTextColor),
                      ),
                    ],
                  ),
                );
              }
              return SafeArea(
                child: DefaultTabController(
                  length: 2,
                  child: Column(children: [
                    AppBar(
                      centerTitle: true,
                      title: const Text("Rechercher un groupe",
                          style: TextStyle(
                              color: kTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                      actions: [
                        IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              showSearch(
                                  context: context,
                                  delegate: CustomSearchDelegate(snapshot
                                      .data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> donne = document
                                        .data()! as Map<String, dynamic>;

                                    return donne;
                                  }).toList()));
                            }),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    const TabBar(
                        indicatorColor: kPrimaryColor,
                        labelColor: kPrimaryColor,
                        unselectedLabelColor: kTextColor,
                        tabs: [
                          Tab(
                            text: "Groupes Rejoint",
                          ),
                          Tab(
                            text: "Decouvrir Les Groupes",
                          ),
                        ]),
                    Expanded(
                      child: TabBarView(children: [
                        ListView(children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;

                              List<dynamic> members = data["members"];

                              if (!members.contains(_auth!.uid)) {
                                return const SizedBox();
                              }
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(data["groupName"]),
                                    onTap: () async {
                                      DatabaseService(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .updateLastReadMessages(
                                              data["groupId"]);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => ChatMesage(
                                                    group: data,
                                                  )));
                                      context
                                          .read<BottomNavigationOffstage>()
                                          .toggleStatus();
                                    },
                                    subtitle: data["recentMessageSender"] != ""
                                        ? Text(data["recentMessage"] != ""
                                            ? data["recentMessageSender"] +
                                                " :  " +
                                                (data["recentMessage"] != null
                                                    ? data["recentMessage"]
                                                                .length >
                                                            30
                                                        ? data["recentMessage"]
                                                                .substring(
                                                                    0, 30) +
                                                            " ..."
                                                        : data["recentMessage"]
                                                    : "image")
                                            : "")
                                        : null,
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        data["recentMessage"] != ""
                                            ? StreamBuilder<List<MessageModel>>(
                                                stream: DatabaseService(
                                                        uid: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .getChats(data["groupId"]),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData &&
                                                      snapshot
                                                          .data!.isNotEmpty) {
                                                    var data1 =
                                                        snapshot.data!.length;
                                                    return StreamBuilder<
                                                            List<MessageModel>>(
                                                        stream: DatabaseService(
                                                                uid: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                            .readMessages(data[
                                                                "groupId"]),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasError) {}
                                                          if (snapshot
                                                                  .hasData &&
                                                              snapshot.data!
                                                                  .isNotEmpty) {
                                                            var data2 = snapshot
                                                                .data!.length;

                                                            if ((data1 -
                                                                    data2) ==
                                                                0) {
                                                              return const Text(
                                                                  "");
                                                            } else {
                                                              return Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            252,
                                                                            114,
                                                                            104),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2),
                                                                  child: Text(
                                                                      NumberFormat
                                                                              .compact()
                                                                          .format(data1 -
                                                                              data2),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.white)));
                                                            }
                                                          } else {
                                                            return Text(
                                                                snapshot.data !=
                                                                        null
                                                                    ? ""
                                                                    : " ");
                                                          }
                                                        });
                                                  } else {
                                                    return const Text("  ");
                                                  }
                                                })
                                            : const Text(" "),
                                        Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Text(
                                              data["recentMessageTime"] != null
                                                  ? DateFormat.Hm().format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          int.parse(data[
                                                              "recentMessageTime"])))
                                                  : "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(fontSize: 10)),
                                        ),
                                      ],
                                    ),
                                    leading: data["groupIcon"] == null
                                        ? const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "asset/img/logo.png"))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.none,
                                              imageUrl: data["groupIcon"]!,
                                              placeholder: (context, url) =>
                                                  SizedBox(
                                                child: FittedBox(
                                                    child: Icon(Icons.group,
                                                        color: Colors.white
                                                            .withOpacity(.9))),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                  ),
                                  const Divider(
                                    thickness: .2,
                                    color: kPrimaryColor,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20)
                        ]),
                        ListView(children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              List<dynamic> membres = data["members"];

                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(data["groupName"]),
                                    subtitle: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          !membres.contains(_auth!.uid)
                                              ? TextButton(
                                                  onPressed: () {
                                                    DatabaseService(
                                                            uid: _auth!.uid)
                                                        .updateGroupUser(
                                                            data["groupId"]);
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: const [
                                                      Icon(Icons.person_add,
                                                          size: 20,
                                                          color: kPrimaryColor),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                          "Rejoindre Le Groupe",
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryColor)),
                                                    ],
                                                  ),
                                                )
                                              : TextButton(
                                                  onPressed: () {
                                                    DatabaseService(
                                                            uid: _auth!.uid)
                                                        .updateRemoveGroupUser(
                                                            data["groupId"]);
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: const [
                                                      Icon(Icons.person_remove,
                                                          size: 20,
                                                          color: Colors.red),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Quitter Le Groupe",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ],
                                                  ),
                                                ),
                                          TextButton(
                                            onPressed: () {},
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    NumberFormat.compact()
                                                        .format(membres.length),
                                                    style: const TextStyle(
                                                        color: kTextColor)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Icon(Icons.group,
                                                    size: 20,
                                                    color: kTextColor),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    leading: data["groupIcon"] == null
                                        ? const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "asset/img/logo.png"))
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.none,
                                              imageUrl: data["groupIcon"]!,
                                              placeholder: (context, url) =>
                                                  SizedBox(
                                                child: FittedBox(
                                                    child: Icon(Icons.group,
                                                        color: Colors.white
                                                            .withOpacity(.9))),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                  ),
                                  const Divider(
                                    thickness: .2,
                                    color: kPrimaryColor,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20)
                        ]),
                      ]),
                    )
                  ]),
                ),
              );
            }));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> searchItems;
  CustomSearchDelegate(this.searchItems);

  Column view(Map<String, dynamic> data) {
    List<dynamic> membres = data["members"];
    User? _auth = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        const SizedBox(height: 20),
        ListTile(
          title: Text(data["groupName"]),
          subtitle: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                !membres.contains(_auth!.uid)
                    ? TextButton(
                        onPressed: () {
                          DatabaseService(uid: _auth.uid)
                              .updateGroupUser(data["groupId"]);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.person_add,
                                size: 20, color: kPrimaryColor),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Rejoindre Le Groupe",
                                style: TextStyle(color: kPrimaryColor)),
                          ],
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          DatabaseService(uid: _auth.uid)
                              .updateRemoveGroupUser(data["groupId"]);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.person_remove,
                                size: 20, color: Colors.red),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Quitter Le Groupe",
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Text(NumberFormat.compact().format(membres.length),
                          style: const TextStyle(color: kTextColor)),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(Icons.group, size: 20, color: kTextColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
          leading: data["groupIcon"] == null
              ? const CircleAvatar(
                  backgroundImage: AssetImage("asset/img/logo.png"))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.none,
                    imageUrl: data["groupIcon"]!,
                    placeholder: (context, url) => SizedBox(
                      child: FittedBox(
                          child: Icon(Icons.group,
                              color: Colors.white.withOpacity(.9))),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
        ),
        const Divider(
          thickness: .2,
          color: kPrimaryColor,
        ),
      ],
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, dynamic>> matchQuery = [];
    for (var fruit in searchItems) {
      if (fruit["groupName"].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return view(result);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> matchQuery = [];
    for (var fruit in searchItems) {
      if (fruit["groupName"].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return view(result);
        });
  }
}
