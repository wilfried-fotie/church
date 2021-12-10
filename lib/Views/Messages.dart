import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church/Model/MessageModel.dart';
import 'package:church/ModelView/BottomNavigationOffstage.dart';
import 'package:church/tools.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

import '../Services/FileManager.dart';
import '../Services/MessageServices.dart';
import 'Widgets/getImage.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final MessageServices _medData = MessageServices();
  final _auth = FirebaseAuth.instance.currentUser;

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

  _PutUp() {
    scroll.animateTo(0.0,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeInOutQuart);
  }

  @override
  Widget build(BuildContext context) {
    final MessageServices _medData = MessageServices();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<BottomNavigationOffstage>().toggleStatus();
              },
              icon: const Icon(Icons.arrow_back)),
          title: Row(
            children: const [
              CircleAvatar(
                backgroundImage: AssetImage("asset/img/logo.png"),
              ),
              SizedBox(
                width: 10,
              ),
              Text("EEC Cameroun"),
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
                },
                child: SizedBox(
                  width: double.infinity,
                  child: StreamBuilder<List<MessageModel>>(
                      stream: _medData.getStreamMessages(nbre),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<MessageModel>? data = snapshot.data;

                          return ListView(
                            reverse: true,
                            controller: scroll,
                            children: data!
                                .map((message) => Mex(
                                    date: message.date!,
                                    sender: message.author == _auth!.uid,
                                    photo: message.photo,
                                    name: (message.author == _auth!.uid)
                                        .toString(),
                                    content: message.message!))
                                .toList(),
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
            SendMessage(_PutUp)
          ],
        ));
  }
}

class Mex extends StatelessWidget {
  final bool sender;
  final String name, date;
  final String? photo, content;
  const Mex(
      {Key? key,
      this.sender = false,
      required this.name,
      required this.date,
      this.photo,
      this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      onSwipeRight: () {
        print(name);
      },
      child: Container(
        alignment: sender ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          constraints: BoxConstraints(
              minWidth: 100, maxWidth: MediaQuery.of(context).size.width - 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: !sender ? Colors.black12 : kPrimaryColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kPrimaryColor),
              ),
              const SizedBox(
                height: 10,
              ),
              photo != null
                  ? CachedNetworkImage(
                      height: 180,
                      fit: BoxFit.cover,
                      imageUrl: photo!,
                      placeholder: (context, url) => SizedBox(
                        child: FittedBox(
                            child: Icon(Icons.image,
                                color: Colors.white.withOpacity(.1))),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : const SizedBox(),
              photo != null
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox(),
              content != null ? Text(content!) : const SizedBox(),
              Text(
                DateFormat.Hm().format(
                        DateTime.fromMillisecondsSinceEpoch(int.parse(date))) +
                    " - " +
                    DateFormat.yMMMd().format(
                        DateTime.fromMillisecondsSinceEpoch(int.parse(date))),
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SendMessage extends StatefulWidget {
  final void Function() scroll;
  const SendMessage(
    this.scroll, {
    Key? key,
  }) : super(key: key);

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
                      if (value!.isEmpty) return;
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
                if (_image != null && !key.currentState!.validate()) {
                  setState(() {
                    _loader = true;
                  });
                  try {
                    FileMananger.uploadFile(_image!.path, "Message")
                        .then((value) {
                      _medData
                          .addMessage(MessageModel(
                        author: _auth!.uid,
                        message: null,
                        photo: value,
                      ))
                          .then((value) {
                        message.clear();
                        widget.scroll();
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
                }

                if (_image != null && key.currentState!.validate()) {
                  var text = message.value.text;
                  setState(() {
                    _loader = true;
                  });
                  try {
                    message.clear();

                    FileMananger.uploadFile(_image!.path, "Message")
                        .then((value) {
                      _medData
                          .addMessage(MessageModel(
                        author: _auth!.uid,
                        message: text,
                        photo: value,
                      ))
                          .then((value) {
                        message.clear();
                        setState(() {
                          _image = null;
                          _loader = false;
                        });

                        widget.scroll();
                      });
                    });
                  } catch (err) {
                    Fluttertoast.showToast(
                        msg: "Une erreur est survenu !!! ",
                        backgroundColor: Colors.red,
                        fontSize: 18,
                        textColor: Colors.white);
                  }
                }

                if (key.currentState!.validate() && _image == null) {
                  try {
                    _medData
                        .addMessage(MessageModel(
                      author: _auth!.uid,
                      message: message.value.text,
                      photo: null,
                    ))
                        .then((value) {
                      message.clear();
                      widget.scroll();
                    });
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
