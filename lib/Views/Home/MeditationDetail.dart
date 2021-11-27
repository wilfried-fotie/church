import 'package:church/helper/extention.dart';
import 'package:church/tools.dart';
import 'package:flutter/material.dart';

class MeditationDetail extends StatelessWidget {
  const MeditationDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text =
        "Capitule : << Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations >>\n\n Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations. Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations. Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message Seule la chaîne de message peut avoir une interpolation. Le nom, la description, les arguments et les exemples doivent être des littéraux et ne pas contenir d'interpolations. Seul le paramètre args peut faire référence à des variables, et il doit répertorier exactement les paramètres de la fonction. Si vous transmettez des nombres ou des dates et que vous souhaitez les formater, vous devez effectuer le formatage en dehors de la fonction et transmettre la chaîne formatée dans le message";
    return Scaffold(
        appBar: AppBar(
            title: const Text("1 Thessalonicien 5:1-11"),
            actions: const [
              Padding(
                  padding: EdgeInsets.only(right: 20), child: Icon(Icons.share))
            ]),
        body: ListView(
          children: [
            Center(
              child: Text(
                "Vivre En Chretien Au sein de la Communauté".toTitleCase,
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
            Center(
              child: Text(
                "Message",
                style: kBoldText.copyWith(decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                text,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Question ",
                style: kBoldText.copyWith(decoration: TextDecoration.underline),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  "Il existe d'autres mécanismes pour charger les données de formatage de date implémentés, Pour le moment, cela inclura toutes les données, ce qui augmentera la taille du code ?"),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Prière ",
                style: kBoldText.copyWith(decoration: TextDecoration.underline),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  " Pour le moment, cela inclura toutes les données, ce qui augmentera la taille du code"),
            ),
          ],
        ));
  }
}
