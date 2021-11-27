import 'package:church/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerContent extends StatelessWidget {
  final void Function(int number) change;
  final int number;
  const DrawerContent({Key? key, required this.change, required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              "EEC Méditation Quotidienne",
              style: kBoldTextPrimaryColor,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage("asset/img/icons/logo.png"),
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Image(
              image: const AssetImage("asset/img/cesic.jpeg"),
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ],
        ),
        const Divider(
          thickness: 1.5,
        ),
        Ink(
          color: number == 1 ? kPrimaryColor : null,
          child: ListTile(
            onTap: () {
              change(1);
              Navigator.pop(context);
            },
            title: const Text("Meditation Quotidienne"),
            leading: const Icon(CupertinoIcons.alarm),
          ),
        ),
        Ink(
          color: number == 3 ? kPrimaryColor : null,
          child: ListTile(
            onTap: () {
              change(3);
              Navigator.pop(context);
            },
            title: const Text("Enseignements"),
            leading: const Icon(CupertinoIcons.suit_club),
          ),
        ),
        Ink(
          color: number == 2 ? kPrimaryColor : null,
          child: ListTile(
            onTap: () {
              change(2);
              Navigator.pop(context);
            },
            title: const Text("Livres"),
            leading: const Icon(CupertinoIcons.book),
          ),
        ),
        Ink(
          color: number == 4 ? kPrimaryColor : null,
          child: ListTile(
            onTap: () {
              change(4);
              Navigator.pop(context);
            },
            title: const Text("Musiques Gospel"),
            leading: const Icon(CupertinoIcons.music_mic),
          ),
        ),
        // const Divider(
        //   thickness: 1.5,
        // ),
      ],
    );
  }
}
