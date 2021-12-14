import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church/Model/MessageModel.dart';
import 'package:church/ModelView/BottomNavigationOffstage.dart';
import 'package:church/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

import '../../Model/UserModel.dart';
import '../../Services/FileManager.dart';
import '../../Services/GroupesServeices.dart';
import '../../Services/MessageServices.dart';
import '../../Services/UserServices.dart';
import '../Widgets/getImage.dart';

class ChatMesage extends StatefulWidget {
  final Map<String, dynamic> group;
  const ChatMesage({Key? key, required this.group}) : super(key: key);

  @override
  State<ChatMesage> createState() => _ChatMesageState();
}

class _ChatMesageState extends State<ChatMesage> {
  final MessageServices _medData = MessageServices();
  final UserServices _userData = UserServices();

  final _auth = FirebaseAuth.instance.currentUser;

  late ScrollController scroll = ScrollController();
  // ignore: constant_identifier_names
  static const int PEERPAGE = 20;
  int nbre = 20;
  int? pause;
  bool response = false;
  Mex? _answer;
  String? _uid;
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

  _PutUp() {
    scroll.animateTo(0.0,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeInOutQuart);
  }

  updateUi() {
    setState(() {
      _answer = null;
    });
  }

  send() {
    setState(() {
      _answer = null;
      response = false;
      _uid = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MessageServices _medData = MessageServices();

    return WillPopScope(
      onWillPop: () async {
        context.read<BottomNavigationOffstage>().toggleStatus();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<BottomNavigationOffstage>().toggleStatus();
                  DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateLastReadMessages(widget.group["groupId"]);
                },
                icon: const Icon(Icons.arrow_back)),
            title: Row(
              children: [
                widget.group["groupIcon"] == null
                    ? const CircleAvatar(
                        backgroundImage: AssetImage("asset/img/logo.png"),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.none,
                          imageUrl: widget.group["groupIcon"],
                          placeholder: (context, url) => SizedBox(
                            child: FittedBox(
                                child: Icon(Icons.image,
                                    color: Colors.white.withOpacity(.1))),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.group["groupName"]),
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _PutUp();
                    setState(() {
                      _answer = null;
                      response = false;
                      _uid = null;
                    });
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: StreamBuilder<List<MessageModel>>(
                        stream:
                            DatabaseService().getChats(widget.group["groupId"]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data ?? [];
                            return ListView(
                              reverse: true,
                              shrinkWrap: true,
                              controller: scroll,
                              children: data.map((message) {
                                return SwipeDetector(
                                    onSwipeRight: () {
                                      setState(() {
                                        _uid = message.id;

                                        _answer = Mex(
                                          answer: true,
                                          groupId: widget.group["groupId"],
                                          date: message.date!,
                                          sender: message.author == _auth!.uid,
                                          photo: message.photo,
                                          name: message.name,
                                          id: message.id!,
                                          content: message.message,
                                        );
                                      });
                                    },
                                    child: Column(
                                        crossAxisAlignment:
                                            message.author == _auth!.uid
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment:
                                                message.author == _auth!.uid
                                                    ? Alignment.topRight
                                                    : Alignment.topLeft,
                                            constraints: BoxConstraints(
                                                minWidth: 100,
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    150),
                                            decoration: BoxDecoration(
                                                color: data
                                                        .where((element) =>
                                                            (element.id ==
                                                                message
                                                                    .reponseUId))
                                                        .toList()
                                                        .isNotEmpty
                                                    ? kTextColor.withOpacity(.1)
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Column(
                                              children: [
                                                data
                                                        .where((element) =>
                                                            (element.id ==
                                                                message
                                                                    .reponseUId))
                                                        .toList()
                                                        .isNotEmpty
                                                    ? Mex(
                                                        groupId: widget
                                                            .group["groupId"],
                                                        id: data
                                                            .where((element) =>
                                                                element.id ==
                                                                message
                                                                    .reponseUId)
                                                            .toList()
                                                            .first
                                                            .author,
                                                        answer: false,
                                                        date: data
                                                            .where((element) =>
                                                                element.id ==
                                                                message
                                                                    .reponseUId)
                                                            .toList()
                                                            .first
                                                            .date!,
                                                        sender: data
                                                                .where((element) =>
                                                                    element
                                                                        .id ==
                                                                    message
                                                                        .reponseUId)
                                                                .toList()
                                                                .first
                                                                .author ==
                                                            _auth!.uid,
                                                        photo: data
                                                            .where((element) =>
                                                                element.id ==
                                                                message
                                                                    .reponseUId)
                                                            .toList()
                                                            .first
                                                            .photo,
                                                        name: data
                                                            .where((element) =>
                                                                element.id ==
                                                                message
                                                                    .reponseUId)
                                                            .toList()
                                                            .first
                                                            .name,
                                                        content: data
                                                            .where((element) =>
                                                                element.id ==
                                                                message
                                                                    .reponseUId)
                                                            .toList()
                                                            .first
                                                            .message,
                                                        res: true,
                                                      )
                                                    : Container(),
                                                Mex(
                                                  resId: message.reponseUId,
                                                  date: message.date!,
                                                  id: message.author,
                                                  idMess: message.id,
                                                  groupId:
                                                      widget.group["groupId"],
                                                  answer: false,
                                                  sender: message.author ==
                                                      _auth!.uid,
                                                  photo: message.photo,
                                                  name: message.name,
                                                  content: message.message,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          )
                                        ]));
                              }).toList(),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
                          );
                        }),
                  ),
                ),
              ),
              _answer ?? Container(),
              SendMessage(_PutUp, send,
                  status: _uid != null ? true : false,
                  uid: _uid,
                  group: widget.group),
            ],
          )),
    );
  }
}

class Mex extends StatefulWidget {
  final bool sender, answer, res;

  final String name, date, id, groupId;
  final String? photo, content, resId, idMess;
  final UserModel? user;

  const Mex(
      {Key? key,
      this.sender = false,
      this.answer = false,
      this.res = false,
      this.resId,
      this.idMess,
      required this.groupId,
      required this.name,
      required this.date,
      this.photo,
      this.user,
      required this.id,
      this.content})
      : super(key: key);

  @override
  State<Mex> createState() => _MexState();
}

class _MexState extends State<Mex> {
  final _auth = FirebaseAuth.instance.currentUser;
  final MessageServices _medData = MessageServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.answer
          ? Alignment.center
          : widget.sender
              ? Alignment.topRight
              : Alignment.topLeft,
      child: Container(
        width: widget.answer ? double.infinity : null,
        constraints: widget.res
            ? BoxConstraints(
                minWidth: 100,
                maxWidth: MediaQuery.of(context).size.width - 150)
            : widget.answer
                ? null
                : BoxConstraints(
                    minWidth: 100,
                    maxWidth: MediaQuery.of(context).size.width - 150),
        padding: widget.res
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: widget.res
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: widget.res
              ? kSecondaryColor.withOpacity(.2)
              : !widget.sender
                  ? Colors.black12
                  : widget.answer
                      ? kSecondaryColor.withOpacity(.2)
                      : kPrimaryColor.withOpacity(.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.sender ? "Vous  " : widget.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: kPrimaryColor),
                ),
                widget.sender && widget.idMess != null
                    ? GestureDetector(
                        child: const Icon(Icons.more_horiz),
                        onTap: () {
                          var image = widget.photo;
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text(
                                        "Voulez vraiment supprimer ?"),
                                    actions: [
                                      TextButton(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text("Supprimer"),
                                              Icon(CupertinoIcons.trash_circle),
                                            ],
                                          ),
                                          onPressed: () {
                                            DatabaseService()
                                                .delete(widget.groupId,
                                                    widget.idMess!)
                                                .then((value) => Navigator.pop(
                                                      context,
                                                    ));

                                            widget.photo != null
                                                ? FileMananger.delete(image!)
                                                : null;
                                          }),
                                      TextButton(
                                          child: const Text("Annuler"),
                                          onPressed: () {
                                            Navigator.pop(context, "false");
                                          })
                                    ],
                                  ));
                        })
                    : Container(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            widget.photo != null
                ? CachedNetworkImage(
                    height: widget.answer ? 50 : 250,
                    width: double.infinity,
                    fit: widget.answer ? BoxFit.contain : BoxFit.cover,
                    filterQuality: FilterQuality.none,
                    imageUrl: widget.photo!,
                    placeholder: (context, url) => SizedBox(
                      child: FittedBox(
                          child: Icon(Icons.image,
                              color: Colors.white.withOpacity(.1))),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : const SizedBox(),
            widget.photo != null
                ? const SizedBox(
                    height: 10,
                  )
                : const SizedBox(),
            widget.content != null
                ? Text(widget.answer || widget.res
                    ? widget.content!.length > 80
                        ? widget.content!.substring(0, 80) + " ..."
                        : widget.content!
                    : widget.content!)
                : const SizedBox(),
            Text(
              DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(widget.date))) +
                  " - " +
                  DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(widget.date))),
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

class SendMessage extends StatefulWidget {
  final void Function() scroll;
  final void Function() del;
  final bool status;
  final String? uid;
  final Map<String, dynamic> group;

  const SendMessage(this.scroll, this.del,
      {Key? key, required this.status, required this.group, this.uid})
      : super(key: key);

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  int lines = 1;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  late final TextEditingController message = TextEditingController();
  File? _image;

  bool _loader = false;
  FocusNode inputNode = FocusNode();
  final MessageServices _medData = MessageServices();
  final _auth = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _image != null && !_loader
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: kSecondaryColor.withOpacity(.1),
                    width: double.infinity,
                    child: Image.file(
                      _image!,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                      right: 20.0,
                      top: 0.0,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          icon: const Icon(Icons.close, color: kPrimaryColor))),
                ],
              )
            : Container(),
        _loader
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80.0, vertical: 20),
                child: Row(
                  children: const [Text("En cours d'envoie ... ")],
                ),
              )
            : Container(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus;
                  final result = await showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return const GetImage(rad: true);
                      });

                  setState(() {
                    _image = result;
                    _loader = false;
                  });
                },
                icon: const Icon(CupertinoIcons.camera_fill)),
            Expanded(
              child: Form(
                key: key,
                child: TextFormField(
                    maxLines: 7,
                    minLines: 1,
                    focusNode: inputNode,
                    controller: message,
                    validator: (value) {
                      if (value!.trim().isEmpty && value == " ") return;
                    },
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        hintText: "Écrire ici",
                        contentPadding: EdgeInsets.all(10))),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_image != null && message.value.text.trim().isEmpty) {
                  setState(() {
                    _loader = true;
                  });

                  try {
                    FileMananger.uploadFile(_image!.path, "Message")
                        .then((value) async {
                      await UserServices()
                          .getUser(_auth!.uid)
                          .then((user) async =>
                              await DatabaseService(uid: _auth!.uid)
                                  .sendMessage(
                                      widget.group["groupId"],
                                      MessageModel(
                                        author: _auth!.uid,
                                        message: null,
                                        name: user.name,
                                        type: widget.status,
                                        reponseUId: widget.uid,
                                        photo: value,
                                      )))
                          .then((value) {
                        message.clear();
                        widget.del();

                        widget.scroll();
                        DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .updateLastReadMessages(widget.group["groupId"]);
                        setState(() {
                          _image = null;
                          _loader = false;
                        });
                      });
                    });
                  } catch (err) {
                    Fluttertoast.showToast(
                        msg: "Une erreur est survenu !!! ",
                        backgroundColor: Colors.red,
                        fontSize: 18,
                        textColor: Colors.white);
                  }
                } else if (_image != null &&
                    message.value.text.trim().isNotEmpty) {
                  var text = message.value.text;
                  setState(() {
                    _loader = true;
                  });
                  try {
                    message.clear();

                    FileMananger.uploadFile(_image!.path, "Message")
                        .then((value) async {
                      await UserServices()
                          .getUser(_auth!.uid)
                          .then((user) async =>
                              await DatabaseService(uid: _auth!.uid)
                                  .sendMessage(
                                      widget.group["groupId"],
                                      MessageModel(
                                        author: _auth!.uid,
                                        name: user.name,
                                        message: text,
                                        type: widget.status,
                                        reponseUId: widget.uid,
                                        photo: value,
                                      )))
                          .then((value) {
                        message.clear();
                        widget.del();
                        widget.scroll();
                        DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .updateLastReadMessages(widget.group["groupId"]);
                        setState(() {
                          _image = null;
                          _loader = false;
                        });
                      });
                    });
                  } catch (err) {
                    Fluttertoast.showToast(
                        msg: "Une erreur est survenu !!! ",
                        backgroundColor: Colors.red,
                        fontSize: 18,
                        textColor: Colors.white);
                  }
                } else if (message.value.text.trim().isNotEmpty &&
                    _image == null) {
                  try {
                    var mex = message.value.text;

                    message.clear();

                    UserServices().getUser(_auth!.uid).then((value) =>
                        DatabaseService(uid: _auth!.uid)
                            .sendMessage(
                                widget.group["groupId"],
                                MessageModel(
                                  author: _auth!.uid,
                                  name: value.name,
                                  message: mex,
                                  type: widget.status,
                                  reponseUId: widget.uid,
                                  photo: null,
                                ))
                            .then((value) {
                          message.clear();
                          widget.scroll();
                          widget.del();
                          DatabaseService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .updateLastReadMessages(widget.group["groupId"]);
                        }));
                  } catch (err) {
                    Fluttertoast.showToast(
                        msg: "Une erreur est survenu !!! ",
                        backgroundColor: Colors.red,
                        fontSize: 18,
                        textColor: Colors.white);
                  }
                }
              },
              icon: const Icon(Icons.send),
            )
          ],
        ),
      ],
    );
  }
}
