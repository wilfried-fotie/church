import 'package:church/helper/extention.dart';
import 'package:church/tools.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../../Model/Meditation.dart';

class MeditationDetail extends StatefulWidget {
  const MeditationDetail({Key? key}) : super(key: key);

  @override
  State<MeditationDetail> createState() => _MeditationDetailState();
}

class _MeditationDetailState extends State<MeditationDetail> {
  bool language = true;

  @override
  Widget build(BuildContext context) {
    Meditation meditations = Provider.of<Meditation>(context, listen: false);
    String text = meditations.body;

    return Scaffold(
        appBar: AppBar(title: Text(meditations.ref), actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.translate)),
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    Share.share(
                        "\t ${meditations.titre.toTitleCase} \n \n \t\t ${meditations.ref} \n \n Message \n \n${meditations.body.substring(0, 400) + "... \t \n Lire la suite ici https://lien.com"} ${meditations.question == "" ? "" : "\n \n Question \n \n ${meditations.question}"} \n\n  ${meditations.pray == "" ? "" : "\n Prière \n ${meditations.pray}"}");
                  },
                  icon: const Icon(Icons.share)))
        ]),
        body: ListView(
          children: [
            const SizedBox(height: 20),
            // !language
            //     ? FutureBuilder<String>(
            //         future: translator
            //             .translate(meditations.body, to: 'en')
            //             .then((value) {
            //           print(value);
            //           return "Text";
            //         }),
            //         builder: (context, snapshot) {
            //           if (snapshot.hasData) {
            //             return Text(snapshot.data.toString());
            //           } else {
            //             return const Text("En cours de traduction");
            //           }
            //         })
            !language
                ? Container()
                : Center(
                    child: SelectableText(
                      meditations.titre.toTitleCase,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
            const Divider(
              thickness: 1.5,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SelectableText(
                text,
                textAlign: TextAlign.justify,
              ),
            ),
            meditations.question != ""
                ? const SizedBox(
                    height: 20,
                  )
                : Container(),
            meditations.question != ""
                ? Center(
                    child: SelectableText(
                      meditations.question != "" ? "Question" : "",
                      style: kBoldText.copyWith(
                          decoration: TextDecoration.underline),
                      textAlign: TextAlign.justify,
                    ),
                  )
                : Container(),
            meditations.question != ""
                ? const SizedBox(
                    height: 5,
                  )
                : Container(),
            meditations.question != ""
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SelectableText(meditations.question ?? ""),
                  )
                : Container(),
            meditations.question != ""
                ? const SizedBox(
                    height: 20,
                  )
                : Container(),
            Center(
              child: SelectableText(
                meditations.pray != "" ? "Prière " : "",
                style: kBoldText.copyWith(decoration: TextDecoration.underline),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SelectableText(meditations.pray ?? ""),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }
}
