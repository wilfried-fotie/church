import 'package:church/Views/Home/Livres.dart';
import 'package:church/Views/Home/Widget/Drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:intl/date_symbol_data_local.dart';
import '../tools.dart';
import 'Eglises.dart';
import 'Home/Enseignement.dart';
import 'Home/Meditation.dart';
import 'Home/Musique.dart';

class HomeDays extends StatefulWidget {
  const HomeDays({Key? key}) : super(key: key);

  @override
  State<HomeDays> createState() => _HomeDaysState();
}

class _HomeDaysState extends State<HomeDays> {
  bool newStatus = false;
  int selectedChip = 1;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    Intl.defaultLocale = "fr_FR";
  }

  void changeCurrent(int number) {
    setState(() {
      selectedChip = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          endDrawer: Drawer(
            child: DrawerContent(change: changeCurrent, number: selectedChip),
          ),
          appBar: AppBar(),
          body: Column(children: [
            // Container(
            //   margin: const EdgeInsets.only(bottom: 20.0, top: 20),
            //   child: const NavBar(
            //     title: "EEC Méditation Quotidienne",
            //   ),
            // ),
            // SizedBox(
            //   height: 50,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       _myChip(1, "Meditation Quotidienne", CupertinoIcons.alarm),
            //       _myChip(3, "Enseignements", CupertinoIcons.suit_club),
            //       _myChip(2, "Livres", CupertinoIcons.book),
            //       _myChip(4, "Musiques Gospel", CupertinoIcons.music_mic),
            //     ],
            //   ),
            // ),
            selectedChip == 1
                ? const Meditation()
                : selectedChip == 2
                    ? const Livres()
                    : selectedChip == 3
                        ? const Enseignement()
                        : const Musiques()
          ])),
    );
  }

  Widget _myChip(int number, String name, IconData icon) {
    return Row(children: [
      const SizedBox(
        width: 20,
      ),
      InkWell(
        onTap: () {
          setState(() {
            selectedChip = number;
          });
        },
        splashColor: Colors.transparent,
        child: Chip(
            backgroundColor: selectedChip == number ? kBackColor : null,
            padding: const EdgeInsets.all(10),
            avatar: Icon(icon,
                color: selectedChip == number
                    ? kPrimaryColor
                    : Theme.of(context).primaryColor),
            label: Padding(
              padding: const EdgeInsets.only(top: 3.0, left: 5),
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: selectedChip == number ? kPrimaryColor : null),
              ),
            )),
      ),
      const SizedBox(
        width: 30,
      ),
    ]);
  }
}
