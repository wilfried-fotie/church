import 'package:church/Views/Eglises.dart';
import 'package:church/helper/extention.dart';
import 'package:church/tools.dart';
import 'package:flutter/material.dart';
import "package:story_view/story_view.dart";
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

import '../Model/ParoissesModel.dart';
import '../Services/ParoissesService.dart';
import 'Widgets/CustomListitle.dart';

class Story extends StatelessWidget {
  const Story({Key? key}) : super(key: key);
// final StoryController controller = StoryController();
  @override
  Widget build(BuildContext context) {
    return const Viewer();
  }
}

class Viewer extends StatefulWidget {
  const Viewer({Key? key}) : super(key: key);
  @override
  State<Viewer> createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  bool status = false;
  void toggleStatus() {
    status = !status;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return status
        ? SwipeDetector(
            onSwipeDown: () {
              toggleStatus();
            },
            child: StroryModelViewer(status: toggleStatus))
        : ListView(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text("Explicatons Bibliques", style: kPrimaryText),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    toggleStatus();
                  },
                  child: const CustomListitle()),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 15),
                child: Text(
                  "Publicité",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(vertical: 20),
              //   width: double.infinity,
              //   height: MediaQuery.of(context).size.height / 2,
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //         fit: BoxFit.contain,
              //         image: AssetImage("asset/img/eglise1.png")),
              //   ),
              // )
            ],
          );
  }
}

class StroryModelViewer extends StatelessWidget {
  final void Function()? status;
  const StroryModelViewer({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoryController controller = StoryController();

    return SizedBox(
        height: MediaQuery.of(context).size.height / 1.8,
        child: StoryView(
          controller: controller,
          progressPosition: ProgressPosition.top,
          storyItems: [
            StoryItem.text(
                title: "“Dieu est tout ce dont vous avez besoin...’’",
                backgroundColor: kPrimaryColor,
                textStyle: kPrimaryTextWhiteSmall,
                duration: const Duration(seconds: 8)),
            StoryItem.text(
                title:
                    "Ce texte signifie que yema Dieu est tout ce dont vous avez besoinDieu est tout ce dont vous avez besoinDieu est tout ce dont vous avez besoinDieu est tout ce dont vous avez besoin",
                backgroundColor: kPrimaryColor,
                textStyle: kPrimaryTextWhiteSmall,
                duration: const Duration(seconds: 10)),
            StoryItem.text(
              title: "Expliquez par wilfried Fotie",
              backgroundColor: kPrimaryColor,
            ),
            StoryItem.inlineProviderImage(
                const AssetImage("asset/img/icons/logo.png"),
                caption: const Text("Pasteur LeuDjeu")),
            StoryItem.text(
                title: "“Dieu est tout ce dont vous avez besoin...’’",
                backgroundColor: kPrimaryColor,
                textStyle: kPrimaryTextWhiteSmall,
                duration: const Duration(seconds: 8)),
          ],
          onStoryShow: (s) {
            print("Showing a story");
          },
          onComplete: () {
            status!();
          },
          repeat: false,
          inline: true,
        ));
  }
}

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

  bool _loader = false;

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
