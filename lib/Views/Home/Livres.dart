import 'package:cached_network_image/cached_network_image.dart';
import 'package:church/Services/LIvresServices.dart';
import 'package:church/Views/Home/LivreDetail.dart';
import 'package:church/helper/extention.dart';
import 'package:church/tools.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../Model/Enseignement.dart';
import '../../Model/LivreModel.dart';
import '../Widgets/CustomButton.dart';
import '../Widgets/SmallButton.dart';

class LivresView extends StatefulWidget {
  const LivresView({Key? key}) : super(key: key);

  @override
  State<LivresView> createState() => _LivresViewState();
}

class _LivresViewState extends State<LivresView> {
  late ScrollController scroll = ScrollController();
  // ignore: constant_identifier_names
  static const int PEERPAGE = 20;
  int nbre = 20;

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
    return Expanded(
        child: StreamBuilder<List<LivreModel>>(
            stream: LivreService().getStreamLivres(nbre),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;
                return GridView.builder(
                    controller: scroll,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            childAspectRatio: 0.7),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LivreDetail(data: data[index])));
                        },
                        child: Card(
                          shadowColor: kBackColor,
                          child: Column(
                            children: [
                              data[index].image != null
                                  ? Expanded(
                                      child: CachedNetworkImage(
                                        height: 180,
                                        fit: BoxFit.cover,
                                        imageUrl: data[index].image!,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(
                                              color: kPrimaryColor),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    )
                                  : Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))),
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        width: double.maxFinite,
                                        child: Text(
                                            data[index]
                                                .titre
                                                .toCapitalized()
                                                .substring(0, 1),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontFamily: "Noto",
                                                fontSize: 100,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white)),
                                      ),
                                    ),
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        data[index].titre.length > 80
                                            ? data[index]
                                                    .titre
                                                    .substring(0, 80) +
                                                "..."
                                            : data[index].titre,
                                        style: kBoldText,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    data[index].prix != 0
                                        ? Text(
                                            data[index].prix.toString() +
                                                "  XAF",
                                          )
                                        : const Text(
                                            "Gratuit",
                                          ),
                                    Text(
                                      "Ecris par ${data[index].author}",
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              }
            }));
  }
}

class ModelLivre extends StatelessWidget {
  final String title, description, author;
  final String? image;
  final EnseignementModel data;
  const ModelLivre(
      {Key? key,
      required this.title,
      required this.description,
      required this.data,
      this.image,
      required this.author})
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
                Text(
                  title.toTitleCase,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    description.length > 130
                        ? description.substring(0, 130) + " ..."
                        : description,
                    textAlign: TextAlign.justify,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Ecris par: $author"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Provider<EnseignementModel>.value(
                                  value: data,
                                  child: const EnseignementDetail(),
                                )));
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
                          "Lire la suite",
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

class EnseignementDetail extends StatelessWidget {
  const EnseignementDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EnseignementModel enseignement =
        Provider.of<EnseignementModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(title: Text(enseignement.titre.toTitleCase), actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    Share.share(
                        "\t ${enseignement.titre.toTitleCase}  \n \n \t \t \t \t  Message \n \n${enseignement.body.substring(0, 400) + "... \t \n Lire la suite ici https://lien.com"} ");
                  },
                  icon: const Icon(Icons.share)))
        ]),
        body: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: SelectableText(
                enseignement.titre.toTitleCase,
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
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SelectableText(
                enseignement.body,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SelectableText(
                enseignement.morale != "" ? "Morale" : "",
                style: kBoldText.copyWith(decoration: TextDecoration.underline),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SelectableText(enseignement.morale ?? ""),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
