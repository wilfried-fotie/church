import 'package:church/Views/Home/MeditationDetail.dart';
import 'package:church/helper/NotData.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../Model/Meditation.dart';
import '../../Services/MeditationService.dart';
import '../../helper/FecthingData.dart';
import '../../tools.dart';

class MeditationView extends StatefulWidget {
  const MeditationView({Key? key}) : super(key: key);

  @override
  _MeditationViewState createState() => _MeditationViewState();
}

class _MeditationViewState extends State<MeditationView> {
  bool showDays = false;
  List<String> test = [];
  final MeditationService _db = MeditationService();
  String startAt = DateFormat.yMMMEd().format(DateTime.now()).toString();
  String startDate = DateFormat.yMMMEd().format(DateTime.now()).toString();

  @override
  initState() {
    super.initState();

    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));

    setState(() {
      test = List.generate(7, (index) => index)
          .map((value) => DateFormat.yMMMEd()
              .format(firstDayOfWeek.add(Duration(days: value))))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamProvider<List<Meditation>>.value(
            value: MeditationService().getMonthStreamMeditation(startDate
                .toString()
                .substring(startDate.substring(5, 7).trim().length > 1 ? 8 : 7,
                    startDate.substring(5, 7).trim().length > 1 ? 11 : 10)
                .trim()),
            initialData: const [],
            catchError: null,
            child: Consumer<List<Meditation>>(
              builder: (_, meditations, __) => ListView(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              startDate =
                                  DateFormat.yMMMEd().format(DateTime.now());
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                DateFormat.yMMMEd().format(DateTime.now()),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: kPrimaryColor),
                              ))),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  showDays = !showDays;
                                });
                              },
                              icon: const Icon(Icons.calendar_today))
                        ],
                      )
                    ],
                  ),
                ),
                showDays
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...test.map((e) => dateMaker(
                              e.substring(0, 3).trim(),
                              e.substring(5, 7).trim(),
                              e.substring(5, 7).trim() ==
                                  DateTime.now().day.toString(),
                              e))
                        ],
                      )
                    : Container(),
                // const Divider(
                //   thickness: 1.5,
                // ),
                meditations.isEmpty
                    ? fectingData()
                    : MedTool(
                        startAt: startDate,
                      )
              ]),
            )));
  }

  InkWell dateMaker(String day, String date, [act = false, e]) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          startDate = e;
        });
      },
      child: Container(
        decoration: (startDate == e)
            ? BoxDecoration(
                color: kSecondaryColor, borderRadius: BorderRadius.circular(10))
            : null,
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Text(
            day,
            style: (startDate == e)
                ? Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kPrimaryColor)
                : null,
          ),
          const SizedBox(height: 20),
          Text(
            date,
            style: (startDate == e)
                ? Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: kPrimaryColor)
                : const TextStyle(fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }
}

class MedTool extends StatelessWidget {
  final String startAt;
  const MedTool({Key? key, required this.startAt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Meditation> meditations = Provider.of<List<Meditation>>(context);

    Meditation? currentMeditation = meditations
            .where((element) {
              return element.refDate == startAt;
            })
            .toList()
            .isNotEmpty
        ? meditations.where((element) {
            return element.refDate == startAt;
          }).toList()[0]
        : null;
    return currentMeditation == null
        ? notData("Aucune méditation définie pour ce jour")
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      currentMeditation.titre,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      currentMeditation.ref,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Provider<Meditation>.value(
                              value: currentMeditation,
                              child: const MeditationDetail())));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText2,
                            children: [
                              TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 15),
                                  text: currentMeditation.body.length > 500
                                      ? currentMeditation.body.substring(0, 500)
                                      : currentMeditation.body),
                              currentMeditation.body.length > 500
                                  ? const TextSpan(text: " ... ")
                                  : const TextSpan(),
                              currentMeditation.body.length > 500
                                  ? const TextSpan(
                                      text: " Lire la suite ",
                                      style: TextStyle(color: kPrimaryColor))
                                  : const TextSpan(),
                            ])),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  currentMeditation.question != "" ? "Question" : "",
                  style: kBoldText,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              currentMeditation.question != ""
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(currentMeditation.question ?? ""),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 20,
              ),
            ],
          );
  }
}
