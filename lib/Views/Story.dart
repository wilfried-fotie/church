import 'package:church/Views/Eglises.dart';
import 'package:church/tools.dart';
import 'package:flutter/material.dart';
import "package:story_view/story_view.dart";
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

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
              Padding(
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
