import 'package:church/helper/extention.dart';
import 'package:church/tools.dart';
import 'package:flutter/material.dart';

class Livres extends StatelessWidget {
  const Livres({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String description =
        "Le but d'envelopper le message dans une fonction est de lui permettre d'avoir des paramètres qui peuvent être utilisés dans le résultat. La chaîne de message est autorisée à utiliser une forme restreinte d'interpolation de chaîne Dart, où seuls les paramètres de la fonction peuvent être utilisés, et uniquement dans des expressions simples. Les variables locales ne peuvent pas être utilisées, ni les expressions avec accolades";

    return Expanded(
        child: ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        ModelLivre(title: "la sainte bible", description: description),
        ModelLivre(title: "la sainte bible", description: description),
        ModelLivre(title: "la sainte bible", description: description),
        ModelLivre(title: "la sainte bible", description: description),
      ],
    ));
  }
}

class ModelLivre extends StatelessWidget {
  final String title, description;
  final String? image;
  const ModelLivre(
      {Key? key, required this.title, required this.description, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.5),
      child: Column(
        children: [
          Container(
              height:
                  image != null ? MediaQuery.of(context).size.height / 4 : 0,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                image: image == null
                    ? null
                    : DecorationImage(
                        fit: BoxFit.cover, image: AssetImage(image!)),
              )),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
                color: Theme.of(context).hoverColor,
                borderRadius: image == null
                    ? BorderRadius.circular(10)
                    : const BorderRadius.only(
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
                const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                    tag: "bible",
                    child: Text(
                      title.toTitleCase,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    description.substring(0, 100) + " ...",
                    textAlign: TextAlign.justify,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text("Ecris par: Wilfried FOTIE"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/livreDetail");
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Voir Le Livre",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        )),
                  ),
                )
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
