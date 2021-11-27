import 'package:church/Services/AddUser.dart';
import 'package:church/Views/Widgets/CustomButton.dart';
import 'package:church/helper/extention.dart';
import 'package:church/tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LivreDetail extends StatefulWidget {
  const LivreDetail({Key? key}) : super(key: key);

  @override
  State<LivreDetail> createState() => _LivreDetailState();
}

class _LivreDetailState extends State<LivreDetail> {
  int number = 1;
  int prix = 30000;
  @override
  Widget build(BuildContext context) {
    String description =
        "Le but d'envelopper le message dans une fonction est de lui permettre d'avoir des paramètres qui peuvent être utilisés dans le résultat. La chaîne de message est autorisée à utiliser une forme restreinte d'interpolation de chaîne Dart, où seuls les paramètres de la fonction peuvent être utilisés, et uniquement dans des expressions simples. Les variables locales ne peuvent pas être utilisées, ni les expressions avec accolades";

    return Scaffold(
      appBar: AppBar(
        title: Hero(tag: "bible", child: Text("la sainte bible".toTitleCase)),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Image.asset(
              "asset/img/bible.jpg",
              fit: BoxFit.contain,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Description",
              style: kBoldBlack,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              description,
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Text(
                "Prix: " + (number * prix).toString() + " XAF",
                style: kBoldBlack,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  "Quantité",
                  style: kBoldBlack,
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      if (number > 1) {
                        number--;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kSecondaryColor,
                    ),
                    child: const Icon(Icons.remove),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  number.toString(),
                  style: kBoldTextPrimaryColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      if (number < 20) {
                        number++;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kSecondaryColor,
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              alignment: Alignment.center,
              child: CustomButton(title: "Acheter le livre", onClick: () {})),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
