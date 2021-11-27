import 'package:church/ModelView/BottomNavigationOffstage.dart';
import 'package:church/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: AssetImage("asset/img/eglise1.png"),
              ),
              SizedBox(
                width: 10,
              ),
              Text("Chorale de yum bandjoun"),
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
                },
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Mex(
                          name: "Jean",
                          content: "la vie est belle",
                        ),
                        Mex(
                          sender: true,
                          name: "Vous",
                          content: "la vie est belle",
                        ),
                        Mex(
                          name: "Paul",
                          content:
                              " la vie est belle la vie est bellela vie est bellela vie est bellela vie est belle la vie est belle la vie est bellela vie est bellela vie est bellela vie est belle la vie est belle la vie est bellela vie est bellela vie est bellela vie est belle",
                        ),
                        Mex(
                          name: "LYDOL",
                          content: "la vie est belle",
                        ),
                        Mex(
                          name: "Jean",
                          content: "la vie est belle",
                        ),
                        Mex(
                          sender: true,
                          name: "Vous",
                          content: "la vie est belle",
                        ),
                        Mex(
                          name: "Jean",
                          content: "la vie est belle",
                        ),
                        Mex(
                          name: "Jean",
                          content: "la vie est belle",
                        ),
                        Mex(
                          name: "Jean",
                          content: "la vie est belle",
                        ),
                        Mex(
                          name: "Jean",
                          content: "la vie est belle",
                        ),
                        Mex(
                          sender: true,
                          name: "Vous",
                          content: "la vie est belle",
                        ),
                        Mex(
                          sender: true,
                          name: "Vous",
                          content: "la vie est belle",
                        ),
                        Mex(
                          name: "Jean",
                          content: "la vie est belle",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SendMessage()
          ],
        ));
  }
}

class Mex extends StatelessWidget {
  final bool sender;
  final String name, content;
  const Mex(
      {Key? key,
      this.sender = false,
      required this.name,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: sender ? Alignment.topRight : null,
      child: Container(
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
            Text(content),
          ],
        ),
      ),
    );
  }
}

class SendMessage extends StatefulWidget {
  const SendMessage({
    Key? key,
  }) : super(key: key);

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  int lines = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {}, icon: const Icon(CupertinoIcons.camera_fill)),
        Expanded(
          child: TextField(
              onEditingComplete: () {
                if (lines < 5) {
                  setState(() {
                    lines++;
                  });
                }
              },
              maxLines: lines,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: kBackColor,
                  hintText: "Écrire ici",
                  contentPadding: EdgeInsets.all(10))),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}
