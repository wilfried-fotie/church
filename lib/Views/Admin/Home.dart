import 'package:church/Model/LivreModel.dart';
import 'package:church/Model/MusiqueModel.dart';
import 'package:church/Services/EnseignementService.dart';
import 'package:church/Services/MusiqueServices.dart';
import 'package:church/Views/Admin/Groupes.dart';
import 'package:church/Views/Admin/Livres.dart';
import 'package:church/Views/Admin/Enseignement.dart';
import 'package:church/Views/Admin/Meditation.dart';
import 'package:church/Views/Admin/Musiques.dart';
import 'package:church/Views/Admin/Paroisses.dart';
import 'package:church/Views/Admin/Pub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../Model/Enseignement.dart';
import '../../Model/Meditation.dart';
import '../../Model/ParoissesModel.dart';
import '../../Services/LIvresServices.dart';
import '../../Services/MeditationService.dart';
import '../../Services/ParoissesService.dart';
import '../../tools.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Administration de l'application"),
          ),
          body: GridView.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2,
              crossAxisCount: 2,
              children: [
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MeditationUi())),
                    child: Card(
                        color: kSecondaryColor,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(CupertinoIcons.alarm, color: kPrimaryColor),
                            Text("Méditation", style: kPrimaryText),
                          ],
                        )))),
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EnseignementUi())),
                    child: Card(
                        color: kSecondaryColor,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(CupertinoIcons.suit_club,
                                color: kPrimaryColor),
                            Text("Enseignement", style: kPrimaryText),
                          ],
                        )))),
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LivresUi())),
                    child: Card(
                        color: kSecondaryColor,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(CupertinoIcons.book, color: kPrimaryColor),
                            Text("Livres", style: kPrimaryText),
                          ],
                        )))),
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MusiqueUi())),
                    child: Card(
                        color: kSecondaryColor,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(CupertinoIcons.music_mic,
                                color: kPrimaryColor),
                            Text("Musiques", style: kPrimaryText),
                          ],
                        )))),
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StreamProvider<List<Paroisses?>>.value(
                                    value:
                                        ParoissesService().getStreamParoissess,
                                    initialData: const [],
                                    child: const ParoissesUi()))),
                    child: Card(
                        color: kSecondaryColor,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("asset/img/icons/church-alt.svg",
                                color: kPrimaryColor),
                            const Text("Paroisses", style: kPrimaryText),
                          ],
                        )))),
                InkWell(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Pub())),
                    child: Card(
                        color: kSecondaryColor,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(CupertinoIcons.compass, color: kPrimaryColor),
                            Text(
                              "Evennement et Pub",
                              style: kPrimaryText,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )))),
              ])),
    );
  }
}
