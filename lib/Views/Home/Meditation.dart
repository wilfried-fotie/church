import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../tools.dart';

class Meditation extends StatefulWidget {
  const Meditation({Key? key}) : super(key: key);

  @override
  _MeditationState createState() => _MeditationState();
}

class _MeditationState extends State<Meditation> {
  String text =
      "Capitule : << Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations >>\n\n Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations. Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations. Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations. Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message";
  bool showAllText = false;
  bool showDays = false;
  List<String> test = [];
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
        child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: kBackColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    DateFormat.yMMMEd().format(DateTime.now()),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: kPrimaryColor),
                  )),
              Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.translate)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
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
                      e.substring(0, 3),
                      e.substring(5, 8),
                      int.parse(e.substring(5, 8)) == DateTime.now().day))
                ],
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text(
                "L'espérence de la vie après la mort",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "1-Thess 1:13-14",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1.5,
        ),
        Padding(
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
                        text: showAllText ? text : text.substring(0, 500)),
                    text.length > 500 && !showAllText
                        ? const TextSpan(text: " ... ")
                        : const TextSpan(),
                    text.length > 500 && !showAllText
                        ? TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, "/meditationDetail");
                              },
                            text: " Lire la suite ",
                            style: const TextStyle(color: kPrimaryColor))
                        : const TextSpan(),
                  ])),
        ),
        const Center(
          child: Text(
            "Question",
            style: kBoldText,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
              "Il existe d'autres mécanismes pour charger les données de formatage de date implémentés, Pour le moment, cela inclura toutes les données, ce qui augmentera la taille du code ?"),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    ));
  }

  Container dateMaker(String day, String date, [act = false]) {
    return Container(
      decoration: act
          ? BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(10))
          : null,
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
        Text(
          day,
          style: act
              ? Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: kPrimaryColor)
              : null,
        ),
        const SizedBox(height: 20),
        Text(
          date,
          style: act
              ? Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: kPrimaryColor)
              : const TextStyle(fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}
