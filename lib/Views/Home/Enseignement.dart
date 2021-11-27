import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../tools.dart';

class Enseignement extends StatefulWidget {
  const Enseignement({Key? key}) : super(key: key);

  @override
  _EnseignementState createState() => _EnseignementState();
}

class _EnseignementState extends State<Enseignement> {
  String text =
      "Capitule : << Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations >>\n\n Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations. Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations. Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations. Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message";

  bool showAllText = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Center(
            child: Text(
              "L'importance de la fidelité",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 1.5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
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
                                    context, "/detailEnseignement");
                              },
                            text: " Lire la suite ",
                            style: const TextStyle(color: kPrimaryColor))
                        : const TextSpan(),
                  ])),
        )
      ],
    ));
  }

  Container dateMaker(String day, String date, [act = false]) {
    return Container(
      decoration: act
          ? BoxDecoration(
              color: kBackColor, borderRadius: BorderRadius.circular(10))
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
