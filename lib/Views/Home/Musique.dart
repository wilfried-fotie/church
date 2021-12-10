import 'dart:io';

import 'package:church/helper/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
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

class _MusiquesState extends State<Musiques> {
  final player = AudioPlayer();
  late ScrollController scroll = ScrollController();
  // ignore: constant_identifier_names
  static const int PEERPAGE = 20;
  int nbre = 20;
  int? pause;
  bool _loader = false;

  @override
  void initState() {
    super.initState();
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
                                  pause != index
                                      ? IconButton(
                                          icon: const Icon(Icons.play_arrow),
                                          onPressed: () async {
                                            try {
                                              data[index].download == null
                                                  ? setState(() {
                                                      pause = index;
                                                    })
                                                  : null;
                                              data[index].download == null
                                                  ? await player.setUrl(
                                                      data[index].musique!)
                                                  : await OpenFile.open(
                                                      data[index].localUrl);
                                              data[index].download == null
                                                  ? player.play()
                                                  : null;
                                            } catch (e) {
                                              setState(() {
                                                pause = null;
                                              });
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Une erreur est survenu veuillez télécharger !!! ",
                                                  backgroundColor: Colors.red,
                                                  fontSize: 18,
                                                  textColor: Colors.white);
                                            }
                                          },
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.pause),
                                          onPressed: () async {
                                            try {
                                              player.pause();
                                            } catch (e) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Une erreur est survenu !!! ",
                                                  backgroundColor: Colors.red,
                                                  fontSize: 18,
                                                  textColor: Colors.white);
                                            }
                                          },
                                        ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        try {
                                          player.stop();
                                          setState(() {
                                            pause = null;
                                          });
                                        } catch (e) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Une erreur est survenu !!! ",
                                              backgroundColor: Colors.red,
                                              fontSize: 18,
                                              textColor: Colors.white);
                                        }
                                      },
                                      icon: const Icon(Icons.stop)),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  _loader
                                      ? const CircularProgressIndicator(
                                          color: kPrimaryColor,
                                        )
                                      : Container(),
                                  data[index].download == null
                                      ? data[index].status == false
                                          ? IconButton(
                                              icon: const Icon(Icons.download),
                                              onPressed: () async {
                                                setState(() {
                                                  _loader = true;
                                                });
                                                try {
                                                  FileMananger.downloadFile(
                                                          data[index].musique!,
                                                          data[index]
                                                                  .titre
                                                                  .replaceAll(
                                                                      " ", "") +
                                                              ".mp3")
                                                      .then((value) {
                                                    MusiqueServices()
                                                        .simpleUpdateMusique({
                                                      "download": true,
                                                      "localUrl": value
                                                    }, data[index].id!);
                                                  });
                                                } catch (error) {
                                                  Fluttertoast.showToast(
                                                      msg: "Downloaded Error",
                                                      backgroundColor:
                                                          Colors.red,
                                                      fontSize: 18,
                                                      textColor: Colors.white);
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
                                                    await launch(whatappURLIos,
                                                        forceSafariVC: false);
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
                                                label:
                                                    Text("Acheter la musique"),
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
