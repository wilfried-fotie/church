import 'package:church/helper/extention.dart';
import 'package:church/tools.dart';
import 'package:flutter/material.dart';
import "package:story_view/story_view.dart";
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

import '../Model/ParoissesModel.dart';
import '../Services/ParoissesService.dart';

class ParoissesUI extends StatelessWidget {
  const ParoissesUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: StreamParoisses(),
    ));
  }
}

class StreamParoisses extends StatefulWidget {
  const StreamParoisses({
    Key? key,
  }) : super(key: key);

  static const int PEERPAGE = 20;

  @override
  State<StreamParoisses> createState() => _StreamParoissesState();
}

class _StreamParoissesState extends State<StreamParoisses> {
  late ScrollController scroll = ScrollController();
  // ignore: constant_identifier_names
  static const int PEERPAGE = 20;
  int nbre = 20;

  int? pause;

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
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Paroisses>>(
        stream: ParoissesService().getStreamParoissess,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            var data = snapshot.data!;
            return ListView(controller: scroll, children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 15, 2, 15),
                child: Text("Nos Paroisses", style: kPrimaryText),
              ),
              ...data
                  .map((Paroisses mp) => ModelParoisse(
                        title: mp.paroisse,
                        berger: mp.berger,
                        distric: mp.distric,
                        region: mp.departement,
                        tel: mp.tel,
                      ))
                  .toList()
            ]);
          } else {
            return const Center(child: Text("Une Erreur est survenu"));
          }
        });
  }
}

class ModelParoisse extends StatelessWidget {
  final String title, berger, tel, distric, region;
  const ModelParoisse({
    Key? key,
    required this.title,
    required this.berger,
    required this.tel,
    required this.region,
    required this.distric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.5),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
                color: Theme.of(context).hoverColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: Theme.of(context).hoverColor == Colors.white
                    ? const [
                        BoxShadow(
                            color: kBackColor,
                            blurRadius: 10,
                            offset: Offset(0, .5))
                      ]
                    : null),
            padding:
                const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                      const TextSpan(text: "Paroisse :  "),
                      TextSpan(
                          text: title.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ])),
                RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                      const TextSpan(text: "Berger :  "),
                      TextSpan(
                          text: berger.toTitleCase,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ])),
                RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                      const TextSpan(text: "Téléphone :  "),
                      TextSpan(
                        text: tel.toTitleCase,
                      ),
                    ])),
                RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                      const TextSpan(text: "Distric :  "),
                      TextSpan(
                        text: distric.toUpperCase(),
                      ),
                    ])),
                RichText(
                    text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                      const TextSpan(text: "Département :  "),
                      TextSpan(
                        text: region.toTitleCase,
                      ),
                    ])),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
