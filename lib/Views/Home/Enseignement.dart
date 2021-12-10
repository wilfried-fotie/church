import 'package:church/Services/EnseignementService.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Model/Enseignement.dart';
import '../../tools.dart';
import 'Livres.dart';

class Enseignement extends StatefulWidget {
  const Enseignement({Key? key}) : super(key: key);

  @override
  _EnseignementState createState() => _EnseignementState();
}

class _EnseignementState extends State<Enseignement> {
  bool showAllText = false;

  late ScrollController scroll = ScrollController();
  // ignore: constant_identifier_names
  static const int PEERPAGE = 20;
  int nbre = 20;

  @override
  void initState() {
    super.initState();
    scroll.addListener(_scrollListener);
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
    return Expanded(
        child: StreamBuilder<List<EnseignementModel>>(
            stream: EnseignementService().getStreamEnseignements(nbre),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;

                return ListView(
                    controller: scroll,
                    children: data
                        .map((EnseignementModel livre) => ModelLivre(
                            title: livre.titre,
                            description: livre.body,
                            author: livre.author,
                            data: livre))
                        .toList());
              } else {
                return const Center(
                  child: Text("Une erreur c'est produite"),
                );
              }
            }));
  }
}

class EnseignementStructure extends StatelessWidget {
  const EnseignementStructure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
