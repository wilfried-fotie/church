import 'package:church/Views/Home/Livres.dart';
import 'package:church/Views/Home/Widget/Drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../tools.dart';
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
          appBar: AppBar(title: const Text("EEC Méditation Quotidienne")),
          body: Column(children: [
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _myChip(1, "Meditation Quotidienne", CupertinoIcons.alarm),
                  _myChip(3, "Enseignements", CupertinoIcons.suit_club),
                  _myChip(2, "Livres", CupertinoIcons.book),
                  _myChip(4, "Musiques Gospel", CupertinoIcons.music_mic),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            selectedChip == 1
                ? const MeditationView()
                : selectedChip == 2
                    ? const LivresView()
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
            backgroundColor: selectedChip == number ? kSecondaryColor : null,
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
