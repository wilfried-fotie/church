import 'dart:io';
import 'package:church/helper/extention.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Model/MusiqueModel.dart';
import '../../Services/FileManager.dart';
import '../../Services/MusiqueServices.dart';
import '../../tools.dart';

class Musiques extends StatefulWidget {
  const Musiques({Key? key}) : super(key: key);

  @override
  State<Musiques> createState() => _MusiquesState();
}

class _MusiquesState extends State<Musiques> with WidgetsBindingObserver {
  late ScrollController scroll = ScrollController();
  // ignore: constant_identifier_names
  static const int PEERPAGE = 20;
  int nbre = 20;
  int? pause;
  bool _loader = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    scroll.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (scroll.offset >= scroll.position.maxScrollExtent &&
        !scroll.position.outOfRange) {
      setState(() {
        nbre += PEERPAGE;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MusiqueModel>>(
        stream: MusiqueServices().getStreamMusiques(nbre),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MusiqueModel>? data = snapshot.data;
            return Expanded(
                child: ListView.builder(
                    controller: scroll,
                    itemCount: data!.length,
                    itemBuilder: (context, index) => Card(
                          shadowColor: kBackColor,
                          child: ListTile(
                            title: Text(data[index].author.toTitleCase +
                                " - " +
                                data[index].titre.toTitleCase),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  !(data[index].download == null ||
                                          !data[index].download!.contains(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid))
                                      ? data[index].status == false
                                          ? pause != index &&
                                                  (data[index].download ==
                                                          null ||
                                                      data[index]
                                                          .download!
                                                          .contains(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid))
                                              ? IconButton(
                                                  icon: const Icon(
                                                      Icons.play_arrow),
                                                  onPressed: () async {
                                                    try {
                                                      data[index].download ==
                                                                  null ||
                                                              !data[index]
                                                                  .download!
                                                                  .contains(FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)
                                                          ? setState(() {
                                                              pause = index;
                                                            })
                                                          : null;

                                                      if (data[index]
                                                                  .download ==
                                                              null ||
                                                          !data[index]
                                                              .download!
                                                              .contains(
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid)) {
                                                        var url = (data[index]
                                                            .musique!);
                                                      } else {
                                                        await OpenFile.open(
                                                            data[index]
                                                                .localUrl);
                                                      }
                                                    } catch (e) {
                                                      if (mounted) {
                                                        setState(() {
                                                          pause = null;
                                                        });
                                                      }

                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Une erreur est survenu veuillez télécharger !!! ",
                                                          backgroundColor:
                                                              Colors.red,
                                                          fontSize: 18,
                                                          textColor:
                                                              Colors.white);
                                                    }
                                                  },
                                                )
                                              : IconButton(
                                                  icon: const Icon(Icons.pause),
                                                  onPressed: () async {
                                                    try {
                                                      setState(() {
                                                        pause = null;
                                                      });
                                                    } catch (e) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Une erreur est survenu !!! ",
                                                          backgroundColor:
                                                              Colors.red,
                                                          fontSize: 18,
                                                          textColor:
                                                              Colors.white);
                                                    }
                                                  },
                                                )
                                          : Container()
                                      : Container(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  _loader
                                      ? const CircularProgressIndicator(
                                          color: kPrimaryColor,
                                        )
                                      : Container(),
                                  _loader
                                      ? const CircularProgressIndicator(
                                          color: kPrimaryColor)
                                      : (data[index].download == null ||
                                              !data[index].download!.contains(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid))
                                          ? data[index].status == false
                                              ? IconButton(
                                                  icon: const Icon(
                                                      Icons.download),
                                                  onPressed: () async {
                                                    setState(() {
                                                      _loader = true;
                                                    });
                                                    try {
                                                      FileMananger.downloadFile(
                                                              data[index]
                                                                  .musique!,
                                                              data[index]
                                                                      .titre
                                                                      .replaceAll(
                                                                          " ",
                                                                          "") +
                                                                  ".mp3")
                                                          .then((value) {
                                                        MusiqueServices()
                                                            .simpleUpdateMusique(
                                                                {
                                                              "download":
                                                                  FieldValue
                                                                      .arrayUnion([
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid
                                                              ]),
                                                              "localUrl": value
                                                            },
                                                                data[index]
                                                                    .id!);
                                                      });
                                                    } catch (error) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Downloaded Error",
                                                          backgroundColor:
                                                              Colors.red,
                                                          fontSize: 18,
                                                          textColor:
                                                              Colors.white);
                                                    } finally {
                                                      setState(() {
                                                        _loader = false;
                                                      });
                                                    }
                                                  },
                                                )
                                              : InkWell(
                                                  onTap: () async {
                                                    String whatsapp =
                                                        "+237${data[index].tel.toString().replaceAll(" ", "")}";
                                                    String whatsappURlAndroid =
                                                        "whatsapp://send?phone=" +
                                                            whatsapp +
                                                            "&text= Bonjour je veux acheter la musique ${data[index].author.toTitleCase + " - " + data[index].titre.toTitleCase} ";
                                                    String whatappURLIos =
                                                        "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
                                                    if (Platform.isIOS) {
                                                      // for iOS phone only
                                                      if (await canLaunch(
                                                          whatappURLIos)) {
                                                        await launch(
                                                            whatappURLIos,
                                                            forceSafariVC:
                                                                false);
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "whatsapp no installed")));
                                                      }
                                                    } else {
                                                      // android , web
                                                      if (await canLaunch(
                                                          whatsappURlAndroid)) {
                                                        await launch(
                                                            whatsappURlAndroid);
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "whatsapp no installed")));
                                                      }
                                                    }
                                                  },
                                                  child: const Chip(
                                                    label: Text(
                                                        "Acheter la musique"),
                                                    avatar: Icon(CupertinoIcons
                                                        .download_circle),
                                                  ),
                                                )
                                          : Container(),
                                ],
                              ),
                            ),
                          ),
                        )));
          }
          return const Center(
              child: CircularProgressIndicator(color: kPrimaryColor));
        });
  }
}
