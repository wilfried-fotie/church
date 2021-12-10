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
          color: number == 1 ? kSecondaryColor : null,
          child: ListTile(
            onTap: () {
              change(1);
              Navigator.pop(context);
            },
            title: Text(
              "Meditation Quotidienne",
              style: TextStyle(color: number == 1 ? kPrimaryColor : null),
            ),
            leading: Icon(CupertinoIcons.alarm,
                color: number == 1 ? kPrimaryColor : null),
          ),
        ),
        Ink(
          color: number == 3 ? kSecondaryColor : null,
          child: ListTile(
            onTap: () {
              change(3);
              Navigator.pop(context);
            },
            title: Text(
              "Enseignements",
              style: TextStyle(color: number == 3 ? kPrimaryColor : null),
            ),
            leading: Icon(CupertinoIcons.suit_club,
                color: number == 3 ? kPrimaryColor : null),
          ),
        ),
        Ink(
          color: number == 2 ? kSecondaryColor : null,
          child: ListTile(
            onTap: () {
              change(2);
              Navigator.pop(context);
            },
            title: Text(
              "Livres",
              style: TextStyle(color: number == 2 ? kPrimaryColor : null),
            ),
            leading: Icon(
              CupertinoIcons.book,
              color: number == 2 ? kPrimaryColor : null,
            ),
          ),
        ),
        Ink(
          color: number == 4 ? kSecondaryColor : null,
          child: ListTile(
            onTap: () {
              change(4);
              Navigator.pop(context);
            },
            title: Text(
              "Musiques Gospel",
              style: TextStyle(color: number == 4 ? kPrimaryColor : null),
            ),
            leading: Icon(CupertinoIcons.music_mic,
                color: number == 4 ? kPrimaryColor : null),
          ),
        ),
        // const Divider(
        //   thickness: 1.5,
        // ),
      ],
    );
  }
}
